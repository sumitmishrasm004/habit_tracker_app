// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitsTrackingModelImpl _$$HabitsTrackingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HabitsTrackingModelImpl(
      id: json['id'] as int?,
      isDataUploaded: json['isDataUploaded'] as int?,
      habitId: json['habitId'] as int,
      habitTrackingDate: json['habitTrackingDate'] as int,
      habitCompletedValue: json['habitCompletedValue'] as String,
      habitMemo: json['habitMemo'] as String?,
    );

Map<String, dynamic> _$$HabitsTrackingModelImplToJson(
        _$HabitsTrackingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDataUploaded': instance.isDataUploaded,
      'habitId': instance.habitId,
      'habitTrackingDate': instance.habitTrackingDate,
      'habitCompletedValue': instance.habitCompletedValue,
      'habitMemo': instance.habitMemo,
    };
