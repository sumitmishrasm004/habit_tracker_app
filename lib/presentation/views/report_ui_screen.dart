import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/constant/colors.dart';
import 'package:habit_tracker/domain/models/stats_model.dart';
import 'package:habit_tracker/presentation/mixin/reports_mixin.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

@RoutePage()
class ReportUIScreen extends StatefulHookConsumerWidget {
  const ReportUIScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportUIScreenState();
}

class _ReportUIScreenState extends ConsumerState<ReportUIScreen>
    with ReportsMixin {
  List<String> labels = [
    'Weekly',
    'Monthly',
  ];
  List<String> getDateRange(DateTime start, DateTime end) {
    List<String> result = [];
    for (var i = start; i.isBefore(end); i = i.add(const Duration(days: 1))) {
      String stringDate = Utils.formatDate(dateTime: i);
      DateTime date = Utils.parseDate(date: stringDate);
      result.add(date.toString());
    }
    return result;
  }

  List<DateTime> getDateRangeForMonths(
      {required DateTime start,
      required DateTime end,
      required StatsModel statsModel}) {
    List<DateTime> result = [];
    if (start.isBefore(statsModel.startDate)) {
      start = statsModel.startDate;
    }
    if (end.isAfter(statsModel.endDate)) {
      end = statsModel.endDate;
    }
    for (var i = start;
        i.isBefore(end) || i.isAtSameMomentAs(end);
        i = i.add(const Duration(days: 1))) {
      String stringDate = Utils.formatDate(dateTime: i);
      DateTime date = Utils.parseDate(date: stringDate);
      result.add(date);
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    getHabitsReports();
  }

  Future getHabitsReports() async {
    await Future.delayed(const Duration(milliseconds: 1), () async {
      ref
          .read(selectedReportsTypeProvider.notifier)
          .updateSelectedReportsType(0);
      ref.read(reportsHabitsDataProvider.notifier).updateReportsHabitsData({});
      DateTime startDate = Utils.getFirstDateOfWeek(DateTime.now());
      DateTime endDate = Utils.getLastDateOfWeek(DateTime.now());
      ref
          .read(statsProvider.notifier)
          .updateProperties(startDate: startDate, endDate: endDate);
      // getReportsData(ref: ref,);
      await showReports(
          ref: ref, reportsType: 'Weekly', selectedDate: startDate);
      await findBestStreak(
          ref: ref, selectedDate: startDate, reportsType: 'Weekly');
      int value = await getAllHabit(
          ref: ref, selectedDate: startDate, reportsType: 'Weekly');
      await findTotalHabitsDone(
          ref: ref, reportsType: 'Weekly', selectedDate: startDate);
      await calculateBestday(
          ref: ref, reportsType: 'Weekly', selectedDate: startDate);
      ref.read(reportsValueProvider.notifier).updateReportsValue(value);
    });
  }

  void moveToPreviousDate(
      {required DateTime startDate,
      required DateTime endDate,
      required selectedReportType}) {
    if (selectedReportType == 0) {
      startDate = startDate.subtract(const Duration(days: 7));
      endDate = endDate.subtract(const Duration(days: 7));
    } else {
      startDate = DateTime(startDate.year, startDate.month - 1, 1);
      endDate = DateTime(endDate.year, endDate.month,
          0); // Setting to last day of the previous month
    }
    updateDate(
        startDate: startDate,
        endDate: endDate,
        selectedReportType: selectedReportType);
  }

  void moveToNextDate(
      {required DateTime startDate,
      required DateTime endDate,
      required int selectedReportType}) {
    if (selectedReportType == 0) {
      startDate = startDate.add(const Duration(days: 7));
      endDate = endDate.add(const Duration(days: 7));
    } else {
      startDate = DateTime(startDate.year, startDate.month + 1, 1);
      endDate = DateTime(endDate.year, endDate.month + 2,
          0); // Setting to last day of the current month
    }
    updateDate(
        startDate: startDate,
        endDate: endDate,
        selectedReportType: selectedReportType);
  }

  Future<void> updateDate(
      {required DateTime startDate,
      required DateTime endDate,
      required int selectedReportType}) async {
    // Add any additional logic or UI update here
    String reportsType = selectedReportType == 0 ? 'Weekly' : 'Monthly';
    ref.read(loaderProvider.notifier).updateProgressValue(true);
    ref.read(reportsHabitsDataProvider.notifier).updateReportsHabitsData({});
    ref
        .read(statsProvider.notifier)
        .updateProperties(startDate: startDate, endDate: endDate);
    await showReports(
        ref: ref, reportsType: reportsType, selectedDate: startDate);
    await findBestStreak(
        ref: ref, selectedDate: startDate, reportsType: reportsType);
    int value = await getAllHabit(
        ref: ref, selectedDate: startDate, reportsType: reportsType);
    ref.read(reportsValueProvider.notifier).updateReportsValue(value);
    await findTotalHabitsDone(
        ref: ref, reportsType: reportsType, selectedDate: startDate);
    await calculateBestday(
        ref: ref, reportsType: reportsType, selectedDate: startDate);
    // ref
    //     .read(statsProvider.notifier)
    //     .updateProperties(startDate: startDate, endDate: endDate);

    ref.read(loaderProvider.notifier).updateProgressValue(false);
  }

  List<TableRow> buildTableRows(
      {required WidgetRef ref,
      required Map<String, dynamic> habitsData,
      required DateTime startDate,
      required DateTime endDate}) {
    List<TableRow> rows = [];

    habitsData.forEach((key, value) {
      List<DateTime> habitDateFormat = List<DateTime>.from(value['dates']);
      List<String> habitDates = [];
      for (var e in habitDateFormat) {
        habitDates.add(e.toString());
      }
      List<Color> rowColors = getDateRange(startDate, endDate)
          .map((date) => habitDates.contains(date)
              ? Color(int.parse(value['habitColor']))
              : Colors.grey.shade300)
          .toList();
      Widget lastColumnWidget() {
        return TableCell(
            child: SizedBox(
          height: 20,
          width: 20,
          child: value['numberOfDays'] == value['dates'].length
              ? const Icon(
                  Icons.star,
                  color: Colors.blueAccent,
                )
              : null,
        ));
      }

      rows.add(
        TableRow(
          children: [
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value['habitIcon'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          value['habitName'],
                          // maxLines: null, // Set to null to allow multiline
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )),
            ...rowColors.map((color) => TableCell(
                  child: Container(
                    width: 20,
                    height: 20,
                    // padding: EdgeInsets.all(5),
                    margin: const EdgeInsets.all(2),
                    // color: color,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: color,
                    ),
                    child: const SizedBox(
                        width: 20, height: 20), // Adjust size as needed
                  ),
                )),
            lastColumnWidget(),
          ],
        ),
      );
    });
    return rows;
  }

  TableRow rowDaysWidget(
      {required DateTime startDate, required DateTime endDate}) {
    List<String> rowDays = getDateRange(startDate, endDate)
        .map((date) =>
            DateFormat('EEEE').format(DateTime.parse(date)).substring(0, 1))
        .toList();
    return TableRow(
      children: [
        const TableCell(child: SizedBox()),
        for (var day in rowDays)
          TableCell(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              day,
              style: const TextStyle(),
              textAlign: TextAlign.center,
            ),
          )),
        const TableCell(
          child: SizedBox(
            height: 30,
            width: 20,
          ),
        ),
      ],
    );
  }

  TableRow lastRow(
      {required StatsModel statsModel, required List<DateTime> bestDayList}) {
    List<String> bestDayString = bestDayList.map((e) => e.toString()).toList();
    List<Widget> bestDaytableCell = getDateRange(
            statsModel.startDate, statsModel.endDate)
        .map((date) => bestDayString.contains(date)
            ? TableCell(
                child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: 20,
                width: 20,
                child: Center(
                  child: const Icon(
                    Icons.sunny_snowing,
                    color: Colors.red,
                  ),
                ),
              ))
            : TableCell(
                child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: 20,
                width: 20,
                child: const SizedBox(),
              )))
        .toList();
    return TableRow(
      children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              color: Colors.yellow.shade100,
              child: const Text(
                'BestDay',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )),
        for (Widget tableCell in bestDaytableCell) tableCell,
        const TableCell(
          child: SizedBox(
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  Widget reportsScoresWidget(
      {required String score,
      String unit = "",
      required String scoreType,
      Color scoreColor = Colors.red,
      Color unitColor = grey500,
      Color scoreTypeColor = grey700}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: const BoxDecoration(
          // border: Border.all()
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.baseline, // Adjust this property
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                score,
                style: TextStyle(
                    fontSize: 20,
                    color: scoreColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                unit,
                style: TextStyle(color: unitColor),
                textAlign: TextAlign.start,
              )
            ],
          ),
          Text(
            scoreType,
            style: TextStyle(color: scoreTypeColor, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget noHabitsText() {
    return ref.watch(loaderProvider)
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: Text(
                'No habits available ',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
          );
  }

  Widget weekReports(
      {required StatsModel statsModel,
      required Map<String, dynamic> habitsData,
      required int reportsValue,
      required List<DateTime> bestDayList,
      required int totalDone,
      required int bestDayStreaksValue}) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(100), // Set a fixed width for the first column
          },
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            rowDaysWidget(
              startDate: statsModel.startDate,
              endDate: statsModel.endDate,
            ),
            ...buildTableRows(
              ref: ref,
              habitsData: habitsData,
              startDate: statsModel.startDate,
              endDate: statsModel.endDate,
            ),
            lastRow(statsModel: statsModel, bestDayList: bestDayList),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget monthReports(
      {required StatsModel statsModel,
      required Map<String, dynamic> habitsData,
      required int reportsValue,
      required List<DateTime> bestDayList,
      required int totalDone,
      required int bestDayStreaksValue}) {
    List<Map<String, dynamic>> habitsList = [];
    habitsData.forEach((key, value) {
      DateTime startDate = Utils.convertTimestampToDateTime(value['startDate']);
      DateTime endDate = Utils.convertTimestampToDateTime(value['endDate']);
      value['totalDates'] = getDateRangeForMonths(
          start: startDate, end: endDate, statsModel: statsModel);
    });
    habitsData.forEach((key, value) => habitsList.add(value));
    var orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height:
          orientation == Orientation.portrait ? height * 0.55 : height * 0.25,
      child: GridView.builder(
          physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          reverse: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 11,
          ),
          itemCount: habitsList.length,
          itemBuilder: (context, index1) {
            double percentage = habitsList[index1]['totalDates'].length == 0
                ? 0
                : habitsList[index1]['dates'].length /
                    habitsList[index1]['totalDates'].length *
                    100;
            String formattedPercentage = Utils.roundOffPercentage(percentage);
            return Container(
              height: 300,
              padding: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(int.parse(habitsList[index1]['habitColor'])),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color:
                            Color(int.parse(habitsList[index1]['habitColor']))
                                .withOpacity(0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              habitsList[index1]['habitIcon'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            Flexible(
                              child: Text(
                                habitsList[index1]['habitName'],
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            )
                          ],
                        )),
                  ),
                  Container(
                    height: 105,
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 5,
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: habitsList[index1]['totalDates'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: habitsList[index1]['dates'].contains(
                                    habitsList[index1]['totalDates'][index])
                                ? Color(
                                    int.parse(habitsList[index1]['habitColor']))
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              '${habitsList[index1]['totalDates'][index].day}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: habitsList[index1]['dates'].contains(
                                          habitsList[index1]['totalDates']
                                              [index])
                                      ? Colors.white
                                      : Colors.black54),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 20,
                          color: Color.fromARGB(255, 3, 176, 93),
                        ),
                        Text(
                          " $formattedPercentage%",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const Icon(Icons.window,
                            size: 20, color: Colors.orangeAccent),
                        Text(
                          "${habitsList[index1]['totalDates'].length}d",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // )
                ],
              ),
            );
          }),
    );
  }

  Widget reportTypeWidget(
      {required StatsModel statsModel,
      required Map<String, dynamic> habitsData,
      required int reportsValue,
      required List<DateTime> bestDayList,
      required int totalDone,
      required int bestDayStreaksValue,
      required int selectedReportType}) {
    if (selectedReportType == 0) {
      return weekReports(
          statsModel: statsModel,
          habitsData: habitsData,
          reportsValue: reportsValue,
          bestDayList: bestDayList,
          totalDone: totalDone,
          bestDayStreaksValue: bestDayStreaksValue);
    } else {
      return monthReports(
          statsModel: statsModel,
          habitsData: habitsData,
          reportsValue: reportsValue,
          bestDayList: bestDayList,
          totalDone: totalDone,
          bestDayStreaksValue: bestDayStreaksValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    StatsModel statsModel = ref.watch(statsProvider);
    Map<String, dynamic> habitsData = ref.watch(reportsHabitsDataProvider);
    int bestDayStreaksValue = ref.watch(bestDayStreaksProvider);
    int reportsValue = ref.watch(reportsValueProvider);
    int totalDone = ref.watch(totalHabitsDoneProvider);
    List<DateTime> bestDayList = ref.watch(bestDayListProvider);
    int selectedReportType = ref.watch(selectedReportsTypeProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    //physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      // const Center(
                      //   child: Text(
                      //     "Habit!ca",
                      //     style: TextStyle(
                      //         fontSize: 34,
                      //         color: Colors.red,
                      //         fontStyle: FontStyle.italic,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => moveToPreviousDate(
                                selectedReportType: selectedReportType,
                                startDate: statsModel.startDate,
                                endDate: statsModel.endDate),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.arrow_left_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                              color: Colors.yellow.shade200,
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              child: Text(
                                selectedReportType == 0
                                    ? '${statsModel.startDate.month}/${statsModel.startDate.day}-${statsModel.endDate.month}/${statsModel.endDate.day}'
                                    : '${Utils.getMonthName(statsModel.startDate)} ${statsModel.startDate.year}',
                                style: const TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => moveToNextDate(
                                selectedReportType: selectedReportType,
                                startDate: statsModel.startDate,
                                endDate: statsModel.endDate),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.arrow_right_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      habitsData.isEmpty
                          ? noHabitsText()
                          : reportTypeWidget(
                              statsModel: statsModel,
                              habitsData: habitsData,
                              reportsValue: reportsValue,
                              bestDayList: bestDayList,
                              totalDone: totalDone,
                              bestDayStreaksValue: bestDayStreaksValue,
                              selectedReportType: selectedReportType),
                      const SizedBox(
                        height: 10,
                      ),
                      habitsData.isEmpty
                          ? const SizedBox()
                          : Container(
                              // decoration:
                              //     BoxDecoration(border: Border.all(width: 1.0)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  reportsScoresWidget(
                                    score: reportsValue.toString(),
                                    unit: "%",
                                    scoreType: "Met",
                                    scoreColor: Colors.red.shade200,
                                  ),
                                  reportsScoresWidget(
                                    score: bestDayList.length.toString(),
                                    unit: "d",
                                    scoreType: "BestDay",
                                    scoreColor:
                                        const Color.fromARGB(255, 69, 109, 141),
                                  ),
                                  reportsScoresWidget(
                                    score: totalDone.toString(),
                                    scoreType: "TotalDone",
                                    scoreColor: Colors.greenAccent.shade200,
                                  ),
                                  reportsScoresWidget(
                                    score: bestDayStreaksValue.toString(),
                                    unit: "d",
                                    scoreType: "BestStreak",
                                    scoreColor: Colors.orange.shade200,
                                  ),
                                ],
                              ),
                            ),
                      // const SizedBox(
                      //   height: 150,
                      // ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  minHeight: 40.0,
                  fontSize: 16.0,
                  borderColor: [Colors.grey.shade300],
                  borderWidth: 1.0,
                  initialLabelIndex: selectedReportType,
                  dividerColor: Colors.white,
                  dividerMargin: 0.0,
                  activeBgColor: const [
                    Colors.blue,
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: labels,
                  onToggle: (index) async {
                    ref.read(loaderProvider.notifier).updateProgressValue(true);
                    ref
                        .read(selectedReportsTypeProvider.notifier)
                        .updateSelectedReportsType(index ?? 0);
                    DateTime currentDate = DateTime.now();
                    if (index == 0) {
                      DateTime startDate =
                          Utils.getFirstDateOfWeek(currentDate);
                      DateTime endDate = Utils.getFirstDateOfWeek(currentDate)
                          .add(const Duration(days: 6));
                      await updateDate(
                          startDate: startDate,
                          endDate: endDate,
                          selectedReportType: index!);
                    } else {
                      DateTime startDate =
                          Utils.getFirstDayOfMonth(currentDate);
                      DateTime endDate = Utils.getLastDayOfMonth(currentDate);
                      await updateDate(
                          startDate: startDate,
                          endDate: endDate,
                          selectedReportType: index!);
                    }
                    ref
                        .read(loaderProvider.notifier)
                        .updateProgressValue(false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
