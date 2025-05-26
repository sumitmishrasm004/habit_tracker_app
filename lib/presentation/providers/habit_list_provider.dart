import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_list_provider.g.dart';


// final habitListProvider =
//     NotifierProvider<HabitListNotifier, List<HabitsModel>>(HabitListNotifier.new);
//
// class HabitListNotifier extends Notifier<List<HabitsModel>> {
//   @override
//   List<HabitsModel> build() => [];
//
//   Future<void> readJson(String assetPath) async {
//     final String response = await rootBundle.loadString(assetPath);
//     final data = await json.decode(response);
//     final habitJson = data["habits"] as List;
//     state = habitJson.map((e) => HabitsModel.fromJson(e)).toList();
//   }
// }

@riverpod
Future<List<HabitsModel>> getHabitsList(GetHabitsListRef ref, String assetPath) async {
  final String response = await rootBundle.loadString(assetPath);
  final data = await json.decode(response);
  final habitJson = data["habits"] as List;
  List<HabitsModel> habitsList = habitJson.map((e) => HabitsModel.fromJson(e)).toList();
  return habitsList;
}
