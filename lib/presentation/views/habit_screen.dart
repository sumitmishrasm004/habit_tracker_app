import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/assets_path.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/habit_tab_bar_provider.dart';
import 'package:habit_tracker/presentation/items/habit_list_widget.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

@RoutePage()
class HabitScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(habitTabProvider);
    final selectedCategoryIndex = ref.watch(selectedCategoryProvider);

    return DefaultTabController(
      length: 2,
      initialIndex: selectedTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Habit'),
          backgroundColor: Colors.white,
          bottom: TabBar(
            splashBorderRadius: BorderRadius.circular(10),
            tabs: const [
              Tab(text: 'Build'),
              Tab(text: 'Quit'),
            ],
            indicatorWeight: 5,
            indicatorColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              // color: Colors.green,
              color: AppColors.primaryBlue,
              // border: Border.all(
              //   width: 2.0,

              // ),
            ),
            labelStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(5.0),
            labelColor: Colors.white,
            onTap: (index) {
              ref.read(habitTabProvider.notifier).setTabIndex(index);
              ref.read(selectedCategoryProvider.notifier).state =
                  null; // Reset selected category if not null
            },
          ),
        ),
        bottomSheet: customHabitButton(context),
        body: const TabBarView(
          children: [
            // Build Habit Content
            HabitListWidget(assetPath: AssetPath.buildHabits),
            HabitListWidget(assetPath: AssetPath.quitHabits),
          ],
        ),
      ),
    );
  }

  Widget customHabitButton(BuildContext context) {
    return GestureDetector(
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: AppColors.primaryBlue,
        // ),
        onTap: () {
          HabitsModel habitsModel = HabitsModel(
              habitName: 'Custom Habit',
              habitTimeRange: 'Anytime',
              habitType: 'Build',
              reminderTime: '',
              healthApp: 0,
              habitCategory: 'Others',
              goal: '1',
              goalUnit: 'Count',
              goalPeriod: 'Day',
              everydayFrequency: 'Daily',
              valueType: 'progress',
              chartType: 'graphic_eq',
              habitIcon: '+',
              habitColor: Utils.generateRandomColor().value.toString(),
              habitStartDate: Utils.dateForDb(DateTime.now()),
              habitEndDate: Utils.dateForDb(DateTime.now()));
          AutoRouter.of(context)
              .push(CustomHabitRoute(habitsModel: habitsModel));
        },
        child: Container(
            width: 150,
            height: 60,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryBlue),
            child: const Center(
              child: Text(
                "Custom Habit",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )));
  }
}
