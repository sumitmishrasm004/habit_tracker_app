import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'habits_model.freezed.dart';

part 'habits_model.g.dart';

@unfreezed
@JsonSerializable(explicitToJson: true, createToJson: true)
class HabitsModel with _$HabitsModel {
  factory HabitsModel(
      {@JsonKey(includeToJson: false) int? id,
      String? habitTimeRange,
      String? reminderTime,
      String? habitEndNotificationID,
      String? reminderMessage,
      int? showHabitMemo,
      String? habitDescription,
      String? habitIcon,
      String? habitColor,
      String? tags,
      String? habitGesture,
      String? chartType,
      @JsonKey(includeToJson: false) int? habitCompletedValue,
      @JsonKey(includeToJson: false) String? habitMemo,
      @JsonKey(includeToJson: false) int? htId,
      int? healthApp,
      int? lastHealthSync,
      String? saveStatus,
      required String habitName,
      required String habitType,
      required String habitCategory,
      required String goal,
      required String goalUnit,
      required String goalPeriod,
      required String everydayFrequency,
      required String valueType,
      required int habitStartDate,
      required int habitEndDate}) = _HabitsModel;

  factory HabitsModel.fromJson(Map<String, Object?> json) => _$HabitsModelFromJson(json);

  // factory HabitsModel.fromJsonForReports(Map<String, dynamic> json) => HabitsModel(
  //     habitName: json["habitName"] ?? '',
  //     habitType: json["habitType"] ?? '',
  //     habitCategory: json["habitCategory"] ?? '',
  //     goal: json["goal"] ?? '',
  //     goalUnit: json["goalUnit"] ?? '',
  //     goalPeriod: json["goalPeriod"] ?? '',
  //     everydayFrequency: json["everydayFrequency"] ?? '',
  //     valueType: json["valueType"] ?? '',
  //     habitCompletedValue:  json["habitCompletedValue"] ?? 0,
  //     habitStartDate: json["habitStartDate"] ?? 0,
  //     habitEndDate: json["habitEndDate"] ?? 0);

  factory HabitsModel.fromMap(Map<dynamic, dynamic> map) => HabitsModel(
      id: map["id"],
      habitTimeRange: map["habitTimeRange"],
      habitColor: map["habitColor"],
      habitDescription: map["habitDescription"],
      habitGesture: map["habitGesture"],
      habitIcon: map["habitIcon"],
      reminderMessage: map["reminderMessage"],
      reminderTime: map["reminderTime"],
      habitEndNotificationID: map["habitEndNotificationID"],
      showHabitMemo: map["showHabitMemo"],
      tags: map["tags"],
      valueType: map["valueType"],
      chartType: map["chartType"],
      habitName: map['habitName'],
      habitType: map["habitType"],
      habitCategory: map["habitCategory"],
      goal: map["goal"],
      goalUnit: map["goalUnit"],
      goalPeriod: map["goalPeriod"],
      everydayFrequency: map["everydayFrequency"],
      habitStartDate: map["habitStartDate"],
      habitEndDate: map["habitEndDate"],
      htId: map["htId"],
      habitCompletedValue: map["habitCompletedValue"],
      habitMemo: map["habitMemo"],
      healthApp: map["healthApp"],
      lastHealthSync: map["lastHealthSync"],
      saveStatus: map['saveStatus']
  );
}
