import 'dart:convert';

import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/data/repository/homepage_repository.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'homepage_provider.g.dart';

// New: Add these constants
// TO DO: Replace with your App Group ID
const String appGroupId = 'group.thinksys.habitTracker';
const String iOSWidgetName = 'Habit_caWidgets';
const String androidWidgetName = 'HabiticaWidget';

@riverpod
Future<List<HabitsModel>?> getAllHabitsFromDatabase(GetAllHabitsFromDatabaseRef ref,
    {required int currentDate}) async {
  try {
    ref.read(saveDataForHomeWidgetProvider);
    return ref.watch(homepageRepositoryProvider).getAllHabitsFromDatabase(currentDate: currentDate);
  } catch (e) {
    throw Exception("Failed to get habits details");
  }
}

@riverpod
Future<void> saveDataForHomeWidget(SaveDataForHomeWidgetRef ref) async {
  try {
    HomeWidget.setAppGroupId(appGroupId);
    List<Map>? habitsMap = await ref
        .watch(homepageRepositoryProvider)
        .getAllHabitsAsMap(currentDate: Utils.dateForDb(DateTime.now()));
    if(habitsMap != null) {
      // final habitsMap = habitsList.map((e) => e.toJson()).toList();
      final habitJson = jsonEncode(habitsMap);
      Logger.log(message: "HabitsJson : $habitJson");
      await HomeWidget.saveWidgetData<String>('habits_list', habitJson.toString());
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );
    }
  } catch (e) {
    throw Exception("Failed save widget data");
  }
}

@riverpod
Future<void> uploadHabitsToFirebaseDatabase(UploadHabitsToFirebaseDatabaseRef ref) async {
  try {
    return ref.watch(homepageRepositoryProvider).savePendingHabitsToFirebaseDatabase();
  } catch (e) {
    throw Exception("Failed to save habits to Firebase");
  }
}

@riverpod
Future<void> uploadHabitsValuesToFirebaseDatabase(UploadHabitsToFirebaseDatabaseRef ref) async {
  try {
    return ref.watch(homepageRepositoryProvider).savePendingHabitsValuesToFirebaseDatabase();
  } catch (e) {
    throw Exception("Failed to save habits to Firebase");
  }
}
