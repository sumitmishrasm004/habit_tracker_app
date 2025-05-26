import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';

part 'habits_tracking_model.freezed.dart';

part 'habits_tracking_model.g.dart';

@unfreezed
class HabitsTrackingModel with _$HabitsTrackingModel {
  factory HabitsTrackingModel(
      {int? id,
      int? isDataUploaded,
      required int habitId,
      required int habitTrackingDate,
      required String habitCompletedValue,
      String? habitMemo}) = _HabitsTrackingModel;

  factory HabitsTrackingModel.fromJson(Map<String, Object?> json) =>
      _$HabitsTrackingModelFromJson(json);

  factory HabitsTrackingModel.fromMap(Map<dynamic, dynamic> map) => HabitsTrackingModel(
      id: map["id"],
      habitId: map["habitId"],
      habitTrackingDate: map["habitTrackingDate"],
      habitCompletedValue: map["habitCompletedValue"],
      habitMemo: map["habitMemo"],
      isDataUploaded: map['isDataUploaded']);
}
