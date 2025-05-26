import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/domain/models/stats_model.dart';
import 'package:habit_tracker/presentation/providers/reports_provider.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@Deprecated('This class is not in used')

@RoutePage()
class StatsScreen extends StatefulHookConsumerWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    StatsModel statsModel = ref.watch(statsProvider);
    int streaksValue = ref.watch(bestDayStreaksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Card(
              elevation: 5,
              // color: const Color.fromARGB(255, 236, 205, 113),
              color: AppColors.primaryBlue,
              // shadowColor: const Color.fromARGB(255, 180, 60, 100),
              // color: Color.fromARGB(255, 112, 164, 207),
              child: Column(
                children: [
                 const SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 100,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                       const Center(
                            child: Text(
                          'Total Streaks ',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                       const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          '${streaksValue}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                      ])),
                const  SizedBox(
                    height: 10,
                  ),
                 const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Start Date',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'End Date',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${Utils.formatDate(dateTime: statsModel.startDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${Utils.formatDate(dateTime: statsModel.endDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                 const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
