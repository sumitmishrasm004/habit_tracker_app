import 'package:hooks_riverpod/hooks_riverpod.dart';

final progressValueProvider = NotifierProvider<ProgressValueNotifier , int>(ProgressValueNotifier.new);

class ProgressValueNotifier extends Notifier<int> {


  @override
  int build() => 0;

  void updateProgressValue(int progressValue) => (state = progressValue);
}