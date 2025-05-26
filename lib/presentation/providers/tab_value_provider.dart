import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabControllerNotifier extends StateNotifier<int> {
  TabControllerNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}

final tabControllerProvider =
    StateNotifierProvider<TabControllerNotifier, int>((ref) {
  return TabControllerNotifier();
});
