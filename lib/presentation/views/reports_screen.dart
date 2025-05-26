import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/constant/colors.dart';
import 'package:habit_tracker/presentation/mixin/reports_mixin.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:habit_tracker/presentation/widgets/calendar_widget.dart';
import 'package:habit_tracker/presentation/widgets/overall_reports_widget.dart';
import 'package:habit_tracker/widgets/all_custom_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

@AutoRouter()
class ReportsScreen extends StatefulHookConsumerWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with ReportsMixin {
  List<String> labels = ['Daily', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    resetAllValue();
  }

  Future resetAllValue() async {
    await Future.delayed(const Duration(microseconds: 0), () {
      ref
          .read(selectedDateProvider.notifier)
          .updateSelectedDate(DateTime.now());
      ref
          .read(selectedReportsTypeProvider.notifier)
          .updateSelectedReportsType(2);
      getReportsData(
        ref: ref,
        selectedDate: DateTime.now(),
        reportsType: 'Monthly',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: scaffoldBody());
  }

  Widget scaffoldBody() {
    // int selectedReportType = ref.watch(selectedReportsTypeProvider);
    return ListView(
      children: [
        // Center(
        //   child: ToggleSwitch(
        //     minWidth: 83.0,
        //     minHeight: 50.0,
        //     fontSize: 16.0,
        //     initialLabelIndex: selectedReportType,
        //     dividerColor: Colors.white,
        //     dividerMargin: 0.0,
        //     activeBgColor: [
        //       Colors.blue,
        //     ],
        //     activeFgColor: Colors.white,
        //     inactiveBgColor: grey300,
        //     inactiveFgColor: Colors.grey[900],
        //     totalSwitches: 3,
        //     labels: labels,
        //     onToggle: (index) {
        //       ref
        //           .read(selectedReportsTypeProvider.notifier)
        //           .updateSelectedReportsType(index ?? 2);
        //       DateTime currentDate = ref.watch(selectedDateProvider);

        //       getReportsData(
        //           ref: ref,
        //           reportsType: labels[index!],
        //           selectedDate: currentDate);
        //     },
        //   ),
        // ),
        CustomCalendarWidget(),
        OverallReportsWidget(),
       const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
