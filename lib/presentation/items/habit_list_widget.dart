import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/habit_list_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

class HabitListWidget extends HookConsumerWidget {
  final String assetPath;

  const HabitListWidget({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitListProvider = ref.watch(getHabitsListProvider(assetPath));
    return habitListProvider.when(data: (data) {
      return showHabitList(data, ref);
    }, error: (e, stacktrace) {
      return const Center(
        child: Text("Habit list is not available, please try again"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget showHabitList(List<HabitsModel> list, WidgetRef ref) {
    return GroupedListView<HabitsModel, String>(
      padding: const EdgeInsets.only(bottom: 100),
      elements: list,
      groupBy: (element) => element.habitCategory,
      groupSeparatorBuilder: (String groupByValue) => ListTile(
        title: Text(
          groupByValue,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onTap: () {},
      ),
      itemBuilder: (context, HabitsModel element) => ListTile(
        leading: Text(
          element.habitIcon!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        title: Text(
          element.habitName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
        ), // Add drop-down icon here
        onTap: () {
          // Handle tapping on the category here
          // ref.read(getHabitsListProvider(assetPath))
          AutoRouter.of(context).push(CustomHabitRoute(habitsModel: element));
        },
      ),
      itemComparator: (item1, item2) =>
          item1.habitName.compareTo(item2.habitName),
      floatingHeader: true,
      order: GroupedListOrder.ASC, // optional
    );
  }
}
