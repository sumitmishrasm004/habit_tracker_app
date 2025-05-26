import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/progress_value_provider.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:habit_tracker/widgets/all_custom_widgets.dart';
import 'package:habit_tracker/widgets/custom_progress_counter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ProgressValueScreen extends HookConsumerWidget {
  final HabitsModel habitsModel;
  final DateTime currentDate;

  ProgressValueScreen(
      {super.key, required this.habitsModel, required this.currentDate});

  ScrollController scrollController = ScrollController();
  TextEditingController addController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int progressValue = ref.watch(progressValueProvider);
    Logger.log(
        message:
            'model print ====> ${habitsModel.toJson()} ${habitsModel.htId}');
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
              child: const Text('Edit'))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async {
            await saveHabitValue(progressValue);
            return true;
          },
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
                  size: 300.0,
                  totalValue: int.parse(habitsModel.goal),
                  completedValue: progressValue,
                  onIncrement: (newValue) {
                    if (newValue <= int.parse(habitsModel.goal)) {
                      ref
                          .read(progressValueProvider.notifier)
                          .updateProgressValue(newValue);
                      saveHabitValue(newValue);
                    } else {
                       Utils.showSnackBar(context,'The value should not be greater than the goal');
                    }
                  },
                  onDecrement: (newValue) {
                    ref
                        .read(progressValueProvider.notifier)
                        .updateProgressValue(newValue);
                    saveHabitValue(newValue);
                  },
                  unit: habitsModel.goalUnit,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                        onPressed: () {
                          // scrollController.animateTo(250,
                          //     duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            FocusScope.of(context)
                                .requestFocus(textFieldFocusNode);
                          });
                          addValueWidget(context, progressValue, ref);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                        onPressed: () {
                          ref
                              .read(progressValueProvider.notifier)
                              .updateProgressValue(0);
                          saveHabitValue(0);
                        },
                        icon: const Icon(
                          Icons.replay,
                          color: AppColors.primaryBlue,
                        )),
                  )
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

  void addValueWidget(BuildContext context, int progressValue, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextFormField(
                    focusNode: textFieldFocusNode,
                    controller: addController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter value",
                      fillColor: Colors.black,
                      contentPadding: EdgeInsets.only(left: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      counterText: '',
                    ),
                    cursorColor: Colors.black,
                    maxLength: 10,
                  ),
                ),
                submitButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    int addValue =
                        progressValue + int.parse(addController.text);
                    if (addValue <= int.parse(habitsModel.goal)) {
                      ref
                          .read(progressValueProvider.notifier)
                          .updateProgressValue(addValue);
                      saveHabitValue(addValue);
                    } else {
                       Utils.showSnackBar(context,'The value should not be greater than the goal');
                    }
                    addController.clear();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
