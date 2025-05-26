import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/services/notification_service.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

mixin CustomHabitMixin {
  Future<void> saveHabit(HabitsModel habitsModel) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      habitsModel.saveStatus = SaveStatusEnum.pending.name;
      // save new user in the database
      if (habitsModel.id == null) {
        habitsModel.id = await databaseImpl.insert(
            tableName: HtDatabaseImpl.habitTableName,
            data: habitsModel.toJson());
        Logger.log(message: "HabitID : ${habitsModel.id}");
      } else {
        // update new user in the database
        await databaseImpl.update(
            tableName: HtDatabaseImpl.habitTableName,
            data: habitsModel.toJson(),
            whereCondition: "id = ${habitsModel.id}");
      }

      /// Update last Sync time with HealthApp
      //  int? id = await databaseImpl.update(
      //       tableName: HtDatabaseImpl.habitTableName,
      //       data: habitsModel.toJson(),
      //       whereCondition: "id = ${habitsModel.id}");
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  void handlingNotificationForEndingHabits(HabitsModel habitsModel) async {
    DateTime startDate =
        Utils.convertTimestampToDateTime(habitsModel.habitStartDate);
    DateTime endedDate =
        Utils.convertTimestampToDateTime(habitsModel.habitEndDate);
    List<List<int>> endHabitsRemindersTime = [
      [17, 0]
    ];
    int difference = endedDate.difference(startDate).inDays;
    startDate = difference > 3
        ? endedDate.subtract(const Duration(days: 2))
        : startDate; // Last 3 days
    List<int> pendingNotificationId = [];
    habitsModel.habitEndNotificationID?.split(',').forEach((element) {
      if (element != "") pendingNotificationId.add(int.parse(element));
    });
    pendingNotificationId.forEach((element) async {
      await NotificationService().cancelAwesomeNotifications(id: element);
    });
    pendingNotificationId.clear();
    await NotificationService().scheduleCustomHabitNotifications(
        title: 'Habit Reminder - ${habitsModel.habitName}',
        body: 'Your habit ${habitsModel.habitName} is about to end',
        remindertime: endHabitsRemindersTime,
        startDate: startDate,
        endDate: endedDate);

    List<NotificationModel> pendingNotificationRequests =
        await NotificationService().getPendingAwesomeNotifications();
    pendingNotificationRequests.forEach((NotificationModel element) async {
      // if (element.body ==
      //     'Your habit ${habitsModel.habitName} is about to end') {
      //   pendingNotificationId.add(element.id);
      // }

      if (element.content?.body ==
              'Your habit ${habitsModel.habitName} is about to end' &&
          element.content!.id != null) {
        pendingNotificationId.add(element.content!.id!);
      }
    });
    habitsModel.habitEndNotificationID = pendingNotificationId.join(',');
  }

  Future<List<int>> getPendingNotifications (HabitsModel habitsModel, String value, String content) async{
    List<int> pendingNotificationId = [];
     List<NotificationModel> pendingNotificationRequests =
        await NotificationService().getPendingAwesomeNotifications();
    pendingNotificationRequests.forEach((NotificationModel element) async {
      if(value == 'title') {
        if (element.content?.title ==
              content &&
          element.content!.id != null) {
        pendingNotificationId.add(element.content!.id!);
      }
      } else {
        if (element.content?.body ==
              content &&
          element.content!.id != null) {
        pendingNotificationId.add(element.content!.id!);
      }
      }
    });
    return pendingNotificationId;
  }

  Future<void> cancelAllPreviousNotifications(List<int> pendingNotificationId) async{
     pendingNotificationId.forEach((element) async {
      await NotificationService().cancelAwesomeNotifications(id: element);
    });
  }
}
