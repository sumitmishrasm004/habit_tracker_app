import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/presentation/providers/count_timer_provider.dart';
import 'package:habit_tracker/presentation/providers/homepage_provider.dart';
import 'package:habit_tracker/presentation/providers/progress_value_provider.dart';
import 'package:habit_tracker/presentation/providers/settings_provider.dart';
import 'package:habit_tracker/presentation/widgets/horizontal_calendar_widget.dart';
import 'package:habit_tracker/presentation/widgets/slider_widget.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/helper.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@RoutePage()
class HomepageScreen extends StatefulHookConsumerWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends ConsumerState<HomepageScreen> {
  DateTime currentDate = DateTime.now();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int? steps = 0;
  late TutorialCoachMark tutorialCoachMark;
  bool notificationStatus = true;
  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    bool shouldShowToolTip = SharedprefUtils.getBool(isFirstTimeUser);
    Logger.log(message: "shouldShowToolTip =====> $shouldShowToolTip");
    if (shouldShowToolTip) {
      createTutorial();
      Future.delayed(Duration(seconds: 1), showTutorial);
    }
    notificationStatus = SharedprefUtils.getBool(isNotificationOn);
    updateNotificationStatus();
    super.initState();
  }

  Future<void> updateNotificationStatus() async {
    Future.delayed(Duration(microseconds: 1)).then((_) {
      ref
          .read(dailyNotificationStatusProvider.notifier)
          .updateDailyNotificationStatus(notificationStatus);
    });
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Add New Habit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap the '+' button to create a new habit and start tracking your goals.",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     controller.previous();
                  //   },
                  //   child: const Icon(Icons.chevron_left),
                  // ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    return targets;
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      textStyleSkip: TextStyle(fontSize: 18.0, color: Colors.white),
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      unFocusAnimationDuration: const Duration(milliseconds: 600),
      onFinish: () {
        Logger.log(message: "finish");
        SharedprefUtils.setBool(isFirstTimeUser, false);
      },
      onClickTarget: (target) {
        Logger.log(message: 'onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        Logger.log(message: "target: $target");
        Logger.log(
            message:
                "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        Logger.log(message: 'onClickOverlay: $target');
      },
      onSkip: () {
        Logger.log(message: "skip");
        SharedprefUtils.setBool(isFirstTimeUser, false);
        return true;
      },
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    ref.read(uploadHabitsToFirebaseDatabaseProvider);
    ref.read(uploadHabitsValuesToFirebaseDatabaseProvider);

    return Scaffold(
      body: scaffoldBody(context, ref),
      floatingActionButton: FloatingActionButton(
          key: keyButton,
          backgroundColor: AppColors.primaryBlue,
          onPressed: () async {
            final result =
                await AutoRouter.of(context).push(const HabitRoute());
            if (result != null) {
              Helper.print("Refreshing");
              refreshKey.currentState!.show();
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Widget scaffoldBody(BuildContext context, WidgetRef ref) {
    //  int selectedIndex = ref.watch(bottomBarProvider);
    //   if (selectedIndex == 0) {
    //    currentDate = Date;
    //           refreshKey.currentState!.show();
    // }
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () {
        // dispose all the pages previously fetched. Next read will refresh them
        ref.invalidate(getAllHabitsFromDatabaseProvider);
        // keep showing the progress indicator until the first page is fetched
        return ref.read(
          getAllHabitsFromDatabaseProvider(
            currentDate: Utils.dateForDb(currentDate),
          ).future,
        );
      },
      child: ListView(
        children: [
          HorizontalCalendarWidget(
            currentDate: currentDate,
            onDateChange: (currentDateTime) {
              currentDate = currentDateTime;
              refreshKey.currentState!.show();
            },
          ),
          showHabitList(context, ref),
        ],
      ),
    );
  }

  Widget showHabitList(BuildContext context, WidgetRef ref) {
    final habitListProvider = ref.watch(getAllHabitsFromDatabaseProvider(
        currentDate: Utils.dateForDb(currentDate)));
    return habitListProvider.when(data: (data) {
      if (data != null && data.isNotEmpty) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (_, index) {
              int currentValue = data[index].valueType == 'progress'
                  ? data[index].habitCompletedValue ?? 0
                  : Utils.roundoffSeconds(
                      type: data[index].goalUnit,
                      time: data[index].habitCompletedValue ?? 0);
              return SliderWidget(
                habitName: data[index].habitName,
                habitCurrentValue: currentValue,
                habitMaxValue: int.parse(data[index].goal),
                habitUnit: data[index].goalUnit,
                habitColor: Color(int.parse(data[index].habitColor ?? '')),
                habitIcon: data[index].habitIcon!,
                onTap: () async {
                  if (Utils.dateForDb(currentDate) <=
                      Utils.dateForDb(DateTime.now())) {
                    if (data[index].valueType == 'progress') {
                      ref
                          .read(progressValueProvider.notifier)
                          .updateProgressValue(
                              data[index].habitCompletedValue ?? 0);
                      final result = await AutoRouter.of(context).push(
                          ProgressValueRoute(
                              habitsModel: data[index],
                              currentDate: currentDate));
                    } else {
                      ref
                          .read(timerProvider.notifier)
                          .updateTimer(data[index].habitCompletedValue ?? 0);
                      final result = await AutoRouter.of(context).push(
                          ProgressTimerRoute(
                              habitsModel: data[index],
                              currentDate: currentDate));
                    }
                    refreshKey.currentState!.show();
                  }
                },
              );
            });
      } else {
        return const Padding(
          padding: EdgeInsets.only(top: 250),
          child: Center(
            child: Text("No Habits available!"),
          ),
        );
      }
    }, error: (e, stacktrace) {
      //   Helper.print(e.toString());
      return const Center(
        child: Text("Habit list is not available, please try again"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
