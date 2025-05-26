import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/count_timer_provider.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:habit_tracker/widgets/all_custom_widgets.dart';
import 'package:habit_tracker/widgets/custom_progress_counter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ProgressTimerScreen extends HookConsumerWidget {
  final HabitsModel habitsModel;
  final DateTime currentDate;

  ProgressTimerScreen(
      {super.key, required this.habitsModel, required this.currentDate});

  // String screenType = 'Exercise';
  ScrollController scrollController = ScrollController();
  TextEditingController addController = TextEditingController();

  void convertIntoMinutesAndSeconds() {}

  FocusNode textFieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerModel = ref.watch(timerProvider);
    Logger.log(message: 'model print ====> ${habitsModel.toJson()}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(habitsModel.habitName),
        actions: [
          TextButton(
              onPressed: () {
                AutoRouter.of(context)
                    .push(CustomHabitRoute(habitsModel: habitsModel));
              },
              child: const Text('Edit')),
        ],
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          int roundoffValue = Utils.roundoffSeconds(
              type: habitsModel.goalUnit, time: timerModel.seconds);
          int convertIntoSeconds = Utils.convertIntoSeconds(
              type: habitsModel.goalUnit, time: roundoffValue);
          if (convertIntoSeconds <= int.parse(habitsModel.goal) * 60) {
            await saveHabitValue(convertIntoSeconds);
          } else {
            await saveHabitValue(int.parse(habitsModel.goal) * 60);
            // Utils.showSnackBar(context,
            //     'The value should not be greater than the goal');
          }
          ref.read(timerProvider.notifier).stopTimer();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CustomProgressCounter(
                  valueType: habitsModel.valueType,
                  unit: habitsModel.goalUnit,
                  size: 300.0,
                  totalValue: Utils.convertIntoSeconds(
                      type: habitsModel.goalUnit,
                      time: int.parse(habitsModel.goal)),
                  completedValue: timerModel.seconds,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                      onPressed: () {
                        ref.read(timerProvider.notifier).stopTimer();
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: TextFormField(
                                        focusNode: textFieldFocusNode,
                                        controller: addController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: "Enter value in min",
                                          fillColor: Colors.black,
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          counterText: '',
                                        ),
                                        maxLength: 10,
                                        cursorColor: Colors.black,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(context).unfocus();
                                          int addValue = int.tryParse(
                                                  addController.text) ??
                                              0;
                                          addValue = addValue * 60;
                                          if (addValue + timerModel.seconds <=
                                            int.parse(habitsModel.goal) * 60) {
                                          ref
                                              .read(timerProvider.notifier)
                                              .increaseTimer(addValue);
                                          saveHabitValue(timerModel.seconds);
                                        } else {
                                          Utils.showSnackBar(context,
                                              'The value should not be greater than the goal');
                                        }
                                          addController.clear();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    submitButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        int addValue =
                                            int.tryParse(addController.text) ??
                                                0;
                                          addValue = addValue * 60;
                                        if (addValue + timerModel.seconds <=
                                            int.parse(habitsModel.goal) * 60) {
                                          ref
                                              .read(timerProvider.notifier)
                                              .increaseTimer(addValue);
                                          saveHabitValue(timerModel.seconds);
                                        } else {
                                          Utils.showSnackBar(context,
                                              'The value should not be greater than the goal');
                                        }
                                        addController.clear();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                      onPressed: () {
                        ref.read(timerProvider.notifier).toggleTimer();
                        if (timerModel.seconds <= int.parse(habitsModel.goal) * 60) {
                          saveHabitValue(timerModel.seconds);
                        } else {
                          saveHabitValue(int.parse(habitsModel.goal) * 60);
                          // Utils.showSnackBar(context,
                          //     'The value should not be greater than the goal');
                        }
                      },
                      icon: Icon(
                        timerModel.isTimerRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                        onPressed: () {
                          ref.read(timerProvider.notifier).resetTimer();
                          saveHabitValue(0);
                        },
                        icon: const Icon(
                          Icons.replay,
                          color: AppColors.primaryBlue,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveHabitValue(int habitValue) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, dynamic> map = {
        "habitId": habitsModel.id,
        "habitTrackingDate": Utils.dateForDb(currentDate),
        "habitCompletedValue": habitValue
      };
      if (habitsModel.htId == null) {
        map.putIfAbsent("saveStatus", () => SaveStatusEnum.pending.name);
        habitsModel.htId = await databaseImpl.insert(
            tableName: HtDatabaseImpl.habitTrackingTableName, data: map);
      } else {
        map.putIfAbsent("saveStatus", () => SaveStatusEnum.updated.name);

        await databaseImpl.update(
            tableName: HtDatabaseImpl.habitTrackingTableName,
            data: map,
            whereCondition: "htId = ${habitsModel.htId}");
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }
}
