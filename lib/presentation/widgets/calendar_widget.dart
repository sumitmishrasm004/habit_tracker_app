import 'dart:async';

import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/mixin/reports_mixin.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

class CustomCalendarWidget extends ConsumerStatefulWidget {
  const CustomCalendarWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends ConsumerState<CustomCalendarWidget>
    with ReportsMixin {
  List<DateTime> selectedDates = [];
  DateTime splitDate = DateTime.now();
  List<HabitsModel> habitsList = <HabitsModel>[];
  List<String> remindersTime = [];
  List<String> labels = ['Daily', 'Weekly', 'Monthly'];
  bool _isBottomSheetOpen = false;
  bool clickDate = false;
  Timer? _debounceTimer;

  Future<void> getHabit(int date) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      List<Map<dynamic, dynamic>> datesValue =
          await databaseImpl.getHabitsValueByDate(
        currentDate: date,
      );
      habitsList = datesValue
          .map((e) => HabitsModel.fromJson(e as Map<String, Object?>))
          .toList();
      for (var element in habitsList) {
        remindersTime = element.reminderTime?.split(',') ?? [];
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  void _openBottomSheet(BuildContext context) {
    if (_isBottomSheetOpen) {
      // If bottom sheet is already open, return early
      return;
    }

    // Cancel any existing debounce timer
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      // Set flag to indicate bottom sheet is open
      _isBottomSheetOpen = true;

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          // Add your bottom sheet content here
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the bottom sheet
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            )),
                        Text(
                          Utils.showDateOnly(splitDate),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                      ],
                    ),
                    habitsList.isEmpty
                        ? const Column(
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              Center(
                                child: Text('No habits data',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey)),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: habitsList.length,
                                itemBuilder: (context, int index) {
                                  final reminderTime = habitsList[index]
                                          .reminderTime
                                          ?.split(',') ??
                                      [];
                                  int currentValue =
                                      habitsList[index].valueType == 'progress'
                                          ? habitsList[index]
                                                  .habitCompletedValue ??
                                              0
                                          : Utils.roundoffSeconds(
                                              type: habitsList[index].goalUnit,
                                              time: habitsList[index]
                                                      .habitCompletedValue ??
                                                  0);
                                  String time = reminderTime[0].length == 4
                                      ? ' ${reminderTime[0]}'
                                      : reminderTime[0];
                                  return ListTile(
                                    leading: Text(
                                      time,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    title: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(habitsList[index]
                                                    .habitIcon!),
                                                const SizedBox(
                                                    width:
                                                        8), // Add spacing if needed
                                                Flexible(
                                                  child: Text(
                                                    habitsList[index]
                                                        .habitName
                                                        .trim(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text('$currentValue'),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                  ],
                ),
              ),
            ),
          );
        },
      ).whenComplete(() {
        // Reset flag when bottom sheet is closed
        _isBottomSheetOpen = false;
        setState(() {}); // Trigger rebuild to reflect the updated flag
      });
    });
  }

  @override
  void dispose() {
    // Dispose the debounce timer to prevent memory leaks
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int reportsValue = ref.watch(reportsValueProvider);
    // DateTime selectDate = ref.watch(selectedDateProvider);
    return AbsorbPointer(
      absorbing: _isBottomSheetOpen,
      child: CleanCalendar(
        enableDenseViewForDates: true,
        enableDenseSplashForDates: true,
        dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
        datePickerCalendarView: DatePickerCalendarView.monthView,
        startWeekday: WeekDay.monday,
        selectedDates: selectedDates,
        onCalendarViewDate: (DateTime calendarViewDate) async {
          Logger.log(
              message:
                  'view calendar ${calendarViewDate.isUtc} $calendarViewDate');
          ref
              .read(selectedDateProvider.notifier)
              .updateSelectedDate(calendarViewDate);
          int reportType = ref.watch(selectedReportsTypeProvider);
          await getReportsData(
              ref: ref,
              selectedDate: calendarViewDate,
              reportsType: labels[reportType]);
        },
        onSelectedDates: (List<DateTime> value) async {
          splitDate = value.first;
          clickDate = true;
          // setState(() {});
          ref.read(selectedDateProvider.notifier).updateSelectedDate(splitDate);
          int reportType = ref.watch(selectedReportsTypeProvider);
          await getReportsData(
              ref: ref,
              selectedDate: splitDate,
              reportsType: labels[reportType]);
          await getHabit(Utils.dateForDb(splitDate));

          _openBottomSheet(context);
          selectedDates.clear();
          setState(() {
            clickDate = false;
            selectedDates.add(value.first);
            // if (selectedDates.contains(value.first)) {
            //   selectedDates.remove(value.first);
            // } else {
            //   selectedDates.add(value.first);
            // }
          });
        },
      ),
    );
  }
}
