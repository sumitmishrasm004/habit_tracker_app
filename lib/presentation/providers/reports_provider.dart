import 'package:habit_tracker/domain/models/stats_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final reportsValueProvider =
    NotifierProvider<ReportsValueNotifier, int>(ReportsValueNotifier.new);

class ReportsValueNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void updateReportsValue(int reportsValue) =>
      (state = reportsValue > 100 ? 100 : reportsValue);
}

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void updateSelectedDate(DateTime selectedDate) => (state = selectedDate);
}

final selectedReportsTypeProvider =
    NotifierProvider<SelectedReportsTypeProvider, int>(
        SelectedReportsTypeProvider.new);

class SelectedReportsTypeProvider extends Notifier<int> {
  @override
  int build() => 0;

  void updateSelectedReportsType(int selectedReportType) =>
      (state = selectedReportType);
}

final bestDayStreaksProvider =
    NotifierProvider<BestDayStreaksNotifier, int>(BestDayStreaksNotifier.new);

class BestDayStreaksNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void updateBestDayStreaksNotifier(int streaksValue) => (state = streaksValue);
}

final statsProvider =
    NotifierProvider<StatsNotifier, StatsModel>(StatsNotifier.new);

class StatsNotifier extends Notifier<StatsModel> {
  @override
  StatsModel build() =>
      StatsModel(startDate: DateTime.now(), endDate: DateTime.now());

  void updateProperties({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final updatedStartDate = startDate;
    final updatedEndDate = endDate;

    state = StatsModel(
      startDate: updatedStartDate,
      endDate: updatedEndDate,
    );
  }
}

final reportsHabitsDataProvider =
    NotifierProvider<ReportHabitsDataNotifier, Map<String, dynamic>>(
        ReportHabitsDataNotifier.new);

class ReportHabitsDataNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => Map<String, dynamic>();
  void updateReportsHabitsData(Map<String, dynamic> reportsHabitsData) =>
      (state = reportsHabitsData);
}

final bestDayListProvider =
    NotifierProvider<BestDayListNotifier, List<DateTime>>(
        BestDayListNotifier.new);

class BestDayListNotifier extends Notifier<List<DateTime>> {
  List<DateTime> list = [];
  @override
  List<DateTime> build() => list;
  void updateBestDayList(List<DateTime> bestDayList) => (state = bestDayList);
}

final totalHabitsDoneProvider =
    NotifierProvider<TotalHabitsDoneNotifier, int>(
        TotalHabitsDoneNotifier.new);

class TotalHabitsDoneNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void updateTotalHabitsDone(int totalHabitsDone) => (state = totalHabitsDone);
}


final loaderProvider = NotifierProvider<LoaderNotifier , bool>(LoaderNotifier.new);

class LoaderNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void updateProgressValue(bool progressValue) => (state = progressValue);
}