
import 'package:hooks_riverpod/hooks_riverpod.dart';

final timerValueProvider = NotifierProvider<TimerValueNotifier , int>(TimerValueNotifier.new);

class TimerValueNotifier extends Notifier<int> {
  @override
  int build() => 60 * 60;

  void updateProgressValue(int progressValue) => (state = progressValue);
}