// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitsModelImpl _$$HabitsModelImplFromJson(Map<String, dynamic> json) =>
    _$HabitsModelImpl(
      id: json['id'] as int?,
      habitTimeRange: json['habitTimeRange'] as String?,
      reminderTime: json['reminderTime'] as String?,
      habitEndNotificationID: json['habitEndNotificationID'] as String?,
      reminderMessage: json['reminderMessage'] as String?,
      showHabitMemo: json['showHabitMemo'] as int?,
      habitDescription: json['habitDescription'] as String?,
      habitIcon: json['habitIcon'] as String?,
      habitColor: json['habitColor'] as String?,
      tags: json['tags'] as String?,
      habitGesture: json['habitGesture'] as String?,
      chartType: json['chartType'] as String?,
      habitCompletedValue: json['habitCompletedValue'] as int?,
      habitMemo: json['habitMemo'] as String?,
      htId: json['htId'] as int?,
      healthApp: json['healthApp'] as int?,
      lastHealthSync: json['lastHealthSync'] as int?,
      saveStatus: json['saveStatus'] as String?,
      habitName: json['habitName'] as String,
      habitType: json['habitType'] as String,
      habitCategory: json['habitCategory'] as String,
      goal: json['goal'] as String,
      goalUnit: json['goalUnit'] as String,
      goalPeriod: json['goalPeriod'] as String,
      everydayFrequency: json['everydayFrequency'] as String,
      valueType: json['valueType'] as String,
      habitStartDate: json['habitStartDate'] as int,
      habitEndDate: json['habitEndDate'] as int,
    );

Map<String, dynamic> _$$HabitsModelImplToJson(_$HabitsModelImpl instance) =>
    <String, dynamic>{
      'habitTimeRange': instance.habitTimeRange,
      'reminderTime': instance.reminderTime,
      'habitEndNotificationID': instance.habitEndNotificationID,
      'reminderMessage': instance.reminderMessage,
      'showHabitMemo': instance.showHabitMemo,
      'habitDescription': instance.habitDescription,
      'habitIcon': instance.habitIcon,
      'habitColor': instance.habitColor,
      'tags': instance.tags,
      'habitGesture': instance.habitGesture,
      'chartType': instance.chartType,
      'healthApp': instance.healthApp,
      'lastHealthSync': instance.lastHealthSync,
      'saveStatus': instance.saveStatus,
      'habitName': instance.habitName,
      'habitType': instance.habitType,
      'habitCategory': instance.habitCategory,
      'goal': instance.goal,
      'goalUnit': instance.goalUnit,
      'goalPeriod': instance.goalPeriod,
      'everydayFrequency': instance.everydayFrequency,
      'valueType': instance.valueType,
      'habitStartDate': instance.habitStartDate,
      'habitEndDate': instance.habitEndDate,
    };
