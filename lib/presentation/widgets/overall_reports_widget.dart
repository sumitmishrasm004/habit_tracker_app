import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/icon_path.dart';
import 'package:habit_tracker/presentation/items/overall_rate_widget.dart';
import 'package:habit_tracker/presentation/mixin/reports_mixin.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OverallReportsWidget extends StatefulHookConsumerWidget {
  const OverallReportsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverallReportsWidgetState();
}

class _OverallReportsWidgetState extends ConsumerState<OverallReportsWidget>
    with ReportsMixin {
  @override
  Widget build(BuildContext context) {
    int reportsValue = ref.watch(reportsValueProvider);
    int bestDayStreaksValue = ref.watch(bestDayStreaksProvider);
    List<DateTime> perfectDayList = ref.watch(bestDayListProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Card(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            OervallRateWidget(
              size: 150.0,
              percentage: reportsValue,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  // onTap: () {
                  //   AutoRouter.of(context).push(StatsRoute());
                  // },
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(medal_icon),
                        height: 50,
                      ),
                      Text(
                        '${bestDayStreaksValue} ${bestDayStreaksValue > 1 ? "Days" : "Day"}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Best Streaks',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image(
                      image: AssetImage(
                        done_icon,
                      ),
                      height: 50,
                    ),
                    Text(
                      '${perfectDayList.length.toString()} Day',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Perfect days',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
