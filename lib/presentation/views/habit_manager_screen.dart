import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/mixin/custom_habit_mixin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HabitManager extends StatefulHookConsumerWidget {
  const HabitManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HabitManagerState();
}

class _HabitManagerState extends ConsumerState<HabitManager>
    with CustomHabitMixin {
  List<HabitsModel> allHabitsList = [];
  List<Map<dynamic, dynamic>> habitsValue = [];
  @override
  void initState() {
    super.initState();
    getAllValue();
  }

  getAllValue() async {
    HtDatabaseImpl databaseImpl = HtDatabaseImpl();
    habitsValue = await databaseImpl.getAllHabitsName();
    allHabitsList = habitsValue
        .map((e) => HabitsModel.fromJson(e as Map<String, Object?>))
        .toList();
    return allHabitsList;
  }

  deleteHabit({required int id}) async {
    HtDatabaseImpl databaseImpl = HtDatabaseImpl();
    await databaseImpl.deleteHabit(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Habits',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() => FutureBuilder(
      future: getAllValue(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Data Available'));
        } else {
          return allhabitsList();
        }
      });

  Widget allhabitsList() => ListView.builder(
      itemCount: allHabitsList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding:
              EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          tileColor: Colors.white,
          title: Text(
            allHabitsList[index].habitName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: Text(
            allHabitsList[index].habitIcon!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            onPressed: () async {
              List<int> pendingNotificationId = await getPendingNotifications(
                  allHabitsList[index],
                  'title',
                  'Habit Reminder - ${allHabitsList[index].habitName}');
              await cancelAllPreviousNotifications(pendingNotificationId);

              List<int> pendingEndingHabitsNotificationId =
                  await getPendingNotifications(allHabitsList[index], 'body',
                      'Your habit ${allHabitsList[index].habitName} is about to end');
              await cancelAllPreviousNotifications(
                  pendingEndingHabitsNotificationId);
              await deleteHabit(id: allHabitsList[index].id!);
              setState(() {});
            },
          ),
        );
      });
}
