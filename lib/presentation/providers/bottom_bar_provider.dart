import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomBarProvider = NotifierProvider<BottomBarNotifier, int>(BottomBarNotifier.new);

class BottomBarNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void updateIndex(int index) => (state = index);
}
