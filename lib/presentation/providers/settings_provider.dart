import 'package:hooks_riverpod/hooks_riverpod.dart';

final dailyNotificationStatusProvider = NotifierProvider<DailyNotificationStatusNotifier , bool>(DailyNotificationStatusNotifier.new);

class DailyNotificationStatusNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void updateDailyNotificationStatus(bool status) => (state = status);
}