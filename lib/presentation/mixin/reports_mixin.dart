import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

mixin ReportsMixin {
  Map<String, DateTime> getStartAndEndDate(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) {
    DateTime date = selectedDate ?? DateTime.now();
    String formattedDate = Utils.formatDate(dateTime: date);
    DateTime startDate = Utils.parseDate(date: formattedDate);
    DateTime endDate = DateTime.now();
    if (reportsType == 'Monthly') {
      startDate = Utils.getFirstDayOfMonth(date);
      endDate = Utils.getLastDayOfMonth(date);
    } else if (reportsType == 'Weekly') {
      startDate = Utils.getFirstDateOfWeek(date);
      endDate = Utils.getLastDateOfWeek(date);
    } else {
      DateTime currentDate = DateTime.now();
      formattedDate = Utils.formatDate(dateTime: currentDate);
      DateTime parsedDate = Utils.parseDate(date: formattedDate);
      startDate = parsedDate;
      endDate = parsedDate;
    }
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Future<int> getAllHabit(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) async {
    int averagePercentage = 0;
    int targetValue = 0;
    int completedValue = 0;
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, DateTime> dates = getStartAndEndDate(
          selectedDate: selectedDate, ref: ref, reportsType: reportsType);
      DateTime startDate = dates['startDate']!;
      DateTime endDate = dates['endDate']!;
      List<Map<dynamic, dynamic>> allHabitsBetweenDates =
          await databaseImpl.getAllHabitsBetweenDates(
        startDate: Utils.dateForDb(startDate),
        endDate: Utils.dateForDb(endDate),
      );
      if (allHabitsBetweenDates.isNotEmpty) {
        List<HabitsModel> allHabitsList = allHabitsBetweenDates
            .map((e) => HabitsModel.fromMap(e as Map<String, Object?>))
            .toList();
        for (var model in allHabitsList) {
          late DateTime reportStartDate;
          late DateTime reportEndDate;
          List<Map<dynamic, dynamic>> allHabitsValueBetweenDates =
              await databaseImpl.getHabitsValueBetweenDates(
            habitId: model.id.toString(),
            startDate: startDate.millisecondsSinceEpoch,
            endDate: endDate.millisecondsSinceEpoch,
          );
          if (allHabitsValueBetweenDates.isNotEmpty) {
            int? sum =
                allHabitsValueBetweenDates.first["SUM(habitCompletedValue)"];
            if (sum != null) {
              if(model.valueType == 'progress'){
                 completedValue += sum;
              } else{
                 completedValue += sum ~/ 60;
              }
            }
            Logger.log(message: "Total completed value : $completedValue");
          }

          DateTime habitStartDate =
              Utils.convertTimestampToDateTime(model.habitStartDate);
          DateTime habitEndDate =
              Utils.convertTimestampToDateTime(model.habitEndDate);
          if (startDate.isAfter(habitStartDate)) {
            reportStartDate = startDate;
          } else {
            reportStartDate = habitStartDate;
          }
          if (habitEndDate.toString() == '1970-01-01 05:30:00.000') {
            reportEndDate = endDate;
            model.habitEndDate = Utils.dateForDb(endDate);
          } else if (endDate.isAfter(habitEndDate) &&
              habitEndDate.toString() != '1970-01-01 05:30:00.000') {
            reportEndDate = habitEndDate;
          } else {
            reportEndDate = endDate;
          }
          int days = reportEndDate.difference(reportStartDate).inDays + 1;

          /// Total value calculation for progress type habits
          if (model.valueType == 'progress') {
            if (days > 0) targetValue += int.parse(model.goal) * days;

            /// Total value calculation for timer type habits
          } else {
            targetValue += Utils.convertToMin(
                    type: model.goalUnit, time: int.parse(model.goal)) *
                days;
          }
        }
        Logger.log(message: "Total target value : $targetValue");
        allHabitsList
            .sort((a, b) => a.habitStartDate.compareTo(b.habitStartDate));
        // averagePercentage = ((completedValue / targetValue) * 100).toInt();
        double value = ((completedValue / targetValue) * 100);
        averagePercentage = Utils.customRounding(value);
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
    return averagePercentage;
  }

  Future<void> showReports(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, DateTime> dates = getStartAndEndDate(
          selectedDate: selectedDate, ref: ref, reportsType: reportsType);
      DateTime startDate = dates['startDate']!;
      DateTime endDate = dates['endDate']!;
      ref
          .read(statsProvider.notifier)
          .updateProperties(startDate: startDate, endDate: endDate);
      Map<String, dynamic> habitsProps = {};

      List<Map<dynamic, dynamic>> allHabitsBetweenDates =
          await databaseImpl.getAllHabitsBetweenDates(
        startDate: Utils.dateForDb(startDate),
        endDate: Utils.dateForDb(endDate),
      );
      if (allHabitsBetweenDates.isNotEmpty) {
        List<HabitsModel> allHabitsList = allHabitsBetweenDates
            .map((e) => HabitsModel.fromMap(e as Map<String, Object?>))
            .toList();
        Logger.log(message: "habitsProps ===> $habitsProps");
        for (var model in allHabitsList) {
          late DateTime reportStartDate;
          late DateTime reportEndDate;
          List<Map<dynamic, dynamic>> allHabitsAllValueBetweenDates =
              await databaseImpl.getHabitsAllValuesBetweenDates(
            habitId: model.id.toString(),
            startDate: startDate.millisecondsSinceEpoch,
            endDate: endDate.millisecondsSinceEpoch,
          );
          List<DateTime> habitsDates = [];
          if (allHabitsAllValueBetweenDates.isNotEmpty) {
            for (var element in allHabitsAllValueBetweenDates) {
              if (element['habitTrackingDate'] != null &&
                  element['habitCompletedValue'] > 0) {
                habitsDates.add(Utils.convertTimestampToDateTime(
                    element["habitTrackingDate"]));
              }
            }
          }

          DateTime habitStartDate =
              Utils.convertTimestampToDateTime(model.habitStartDate);
          DateTime habitEndDate =
              Utils.convertTimestampToDateTime(model.habitEndDate);
          if (startDate.isAfter(habitStartDate)) {
            reportStartDate = startDate;
          } else {
            reportStartDate = habitStartDate;
          }

          if (habitEndDate.toString() == '1970-01-01 05:30:00.000') {
            reportEndDate = endDate;
            model.habitEndDate = Utils.dateForDb(endDate);
          } else if (endDate.isAfter(habitEndDate)) {
            reportEndDate = habitEndDate;
          } else {
            reportEndDate = endDate;
          }
          int days = reportEndDate.difference(reportStartDate).inDays + 1;
          habitsDates.sort((a, b) => a.compareTo(b));
          if(days > 0){
          habitsProps['${model.id}'] = {
            'dates': habitsDates,
            'habitName': model.habitName,
            'habitIcon': model.habitIcon,
            'startDate': model.habitStartDate,
            'endDate': model.habitEndDate,
            'habitColor': model.habitColor,
            'numberOfDays': days,
          };}
        }
        ref
            .read(reportsHabitsDataProvider.notifier)
            .updateReportsHabitsData(habitsProps);
      } 
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  Future<void> findTotalHabitsDone(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, DateTime> dates = getStartAndEndDate(
          selectedDate: selectedDate, ref: ref, reportsType: reportsType);
      DateTime startDate = dates['startDate']!;
      DateTime endDate = dates['endDate']!;
      int totalHabitsDone = 0;
      ref
          .read(totalHabitsDoneProvider.notifier)
          .updateTotalHabitsDone(totalHabitsDone);
      List<Map<dynamic, dynamic>> allHabitsBetweenDates =
          await databaseImpl.getAllHabitsBetweenDates(
        startDate: Utils.dateForDb(startDate),
        endDate: Utils.dateForDb(endDate),
      );
      if (allHabitsBetweenDates.isNotEmpty) {
        List<HabitsModel> allHabitsList = allHabitsBetweenDates
            .map((e) => HabitsModel.fromMap(e as Map<String, Object?>))
            .toList();
        for (var model in allHabitsList) {
          List<Map<dynamic, dynamic>> allHabitsAllValueBetweenDates =
              await databaseImpl.getHabitsAllValuesBetweenDates(
            habitId: model.id.toString(),
            startDate: startDate.millisecondsSinceEpoch,
            endDate: endDate.millisecondsSinceEpoch,
          );
          if (allHabitsAllValueBetweenDates.isNotEmpty) {
            for (var element in allHabitsAllValueBetweenDates) {
              if (element['habitTrackingDate'] != null &&
                  element['habitCompletedValue'] > 0) totalHabitsDone++;
            }
          }
        }
        ref
            .read(totalHabitsDoneProvider.notifier)
            .updateTotalHabitsDone(totalHabitsDone);
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  Future<void> calculateBestday(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, DateTime> dates = getStartAndEndDate(
          selectedDate: selectedDate, ref: ref, reportsType: reportsType);
      DateTime startDate = dates['startDate']!;
      DateTime endDate = dates['endDate']!;
      List<DateTime> totalBestDay = [];
      // ref.read(bestDayListProvider.notifier).updateBestDayList(totalBestDay);
      for (var i = startDate;
          i.isBefore(endDate) || i.isAtSameMomentAs(endDate);
          i = i.add(const Duration(days: 1))) {
        List<Map<dynamic, dynamic>> allHabitsBetweenDates =
            await databaseImpl.getAllHabitsBetweenDates(
          startDate: Utils.dateForDb(i),
          endDate: Utils.dateForDb(i),
        );
        if (allHabitsBetweenDates.isNotEmpty) {
          List<HabitsModel> allHabitsList = allHabitsBetweenDates
              .map((e) => HabitsModel.fromMap(e as Map<String, Object?>))
              .toList();

          int habitsCount = 0;
          for (var model in allHabitsList) {
            List<Map<dynamic, dynamic>> allHabitsAllValueBetweenDates =
                await databaseImpl.getHabitsAllValuesBetweenDates(
              habitId: model.id.toString(),
              startDate: i.millisecondsSinceEpoch,
              endDate: i.millisecondsSinceEpoch,
            );
            List<DateTime> habitsDates = [];
            if (allHabitsAllValueBetweenDates.isNotEmpty) {
              if (allHabitsAllValueBetweenDates[0]['habitCompletedValue'] > 0) {
                habitsCount++;
              }
            }
          }
          if (habitsCount == allHabitsList.length) {
            totalBestDay.add(i);
            habitsCount = 0;
          }
        }
      }
      ref.read(bestDayListProvider.notifier).updateBestDayList(totalBestDay);
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  Future<void> findBestStreak(
      {DateTime? selectedDate,
      required WidgetRef ref,
      required String reportsType}) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, DateTime> dates = getStartAndEndDate(
          selectedDate: selectedDate, ref: ref, reportsType: reportsType);
      DateTime startDate = dates['startDate']!;
      DateTime endDate = dates['endDate']!;
      int maxValue = 0;
      // ref
      //     .read(statsProvider.notifier)
      //     .updateProperties(startDate: startDate, endDate: endDate);
      int countOfBestStreaks = 0;
      ref
          .read(bestDayStreaksProvider.notifier)
          .updateBestDayStreaksNotifier(countOfBestStreaks);
      Map datesAndValue = {};
      List<Map<dynamic, dynamic>> allHabitsBetweenDates =
          await databaseImpl.getAllHabitsBetweenDates(
        startDate: Utils.dateForDb(startDate),
        endDate: Utils.dateForDb(endDate),
      );
      if (allHabitsBetweenDates.isNotEmpty) {
        List<HabitsModel> allHabitsList = allHabitsBetweenDates
            .map((e) => HabitsModel.fromMap(e as Map<String, Object?>))
            .toList();
        for (var model in allHabitsList) {
          List<Map<dynamic, dynamic>> allHabitsAllValueBetweenDates =
              await databaseImpl.getHabitsAllValuesBetweenDates(
            habitId: model.id.toString(),
            startDate: startDate.millisecondsSinceEpoch,
            endDate: endDate.millisecondsSinceEpoch,
          );
          for (var element in allHabitsAllValueBetweenDates) {
            if (element['habitCompletedValue'] > 0) {
              datesAndValue[element['habitTrackingDate']] =
                  Utils.convertTimestampToDateTime(
                      element['habitTrackingDate']);
            }
          }
          List datesList = [];
          datesList.addAll(datesAndValue.values);
          datesList.sort((a, b) => a.compareTo(b));
          countOfBestStreaks = datesList.isEmpty ? 0 : 1;
          for (int i = 1; i < datesList.length; i++) {
            DateTime previousDate = datesList[i - 1];
            DateTime nextDate = datesList[i];
            bool isConsecutiveDate =
                Utils.isConsecutiveDate(previousDate, nextDate);
            if (isConsecutiveDate) {
              countOfBestStreaks++;
            }
          }
          datesAndValue = {};
          maxValue =
              countOfBestStreaks > maxValue ? countOfBestStreaks : maxValue;
        }
        ref
            .read(bestDayStreaksProvider.notifier)
            .updateBestDayStreaksNotifier(maxValue);
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  Future<void> getReportsData(
      {required WidgetRef ref,
      DateTime? selectedDate,
      String reportsType = 'Daily'}) async {
    int value = await getAllHabit(
        selectedDate: selectedDate, ref: ref, reportsType: reportsType);
    ref.read(reportsValueProvider.notifier).updateReportsValue(value);
    findBestStreak(
        ref: ref, selectedDate: selectedDate, reportsType: reportsType);
    // showReports(ref: ref, reportsType: 'Weekly');
    // await findTotalHabitsDone(
    //     selectedDate: selectedDate, ref: ref, reportsType: reportsType);
    await calculateBestday(
        selectedDate: selectedDate, ref: ref, reportsType: reportsType);
  }
}
