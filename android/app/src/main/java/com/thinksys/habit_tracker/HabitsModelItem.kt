package com.thinksys.habit_tracker

data class HabitsModelItem(
    var chartType: String?,
    var everydayFrequency: String?,
    var goal: Int?,
    var goalPeriod: String?,
    var goalUnit: String?,
    var habitCategory: String?,
    var habitColor: String?,
    var habitDescription: String?,
    var habitEndDate: Long?,
    var habitGesture: String?,
    var habitIcon: String?,
    var habitName: String?,
    var habitStartDate: Long?,
    var habitTimeRange: String?,
    var habitType: String?,
    var healthApp: Int?,
    var lastHealthSync: Int?,
    var reminderMessage: String?,
    var saveStatus: String?,
    var showHabitMemo: Int?,
    var tags: String?,
    var valueType: String?,
    var habitCompletedValue: Int?
)