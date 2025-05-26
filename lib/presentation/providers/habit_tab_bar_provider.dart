import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitTabNotifier extends StateNotifier<int> {
  HabitTabNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}

final habitTabProvider =
    StateNotifierProvider<HabitTabNotifier, int>((ref) {
  return HabitTabNotifier();
});


// class SelectedCategoryNotifier extends StateNotifier<int?> {
//   SelectedCategoryNotifier() : super(null);

//   void setSelectedCategoryIndex(int index) {
//     state = index;
//   }
// }
// final selectedCategoryProvider =
//     StateNotifierProvider<SelectedCategoryNotifier, int?>((ref) {
//   return SelectedCategoryNotifier();
// });
// // final selectedCategoryProvider = StateProvider<int>((ref) => 0);
final selectedCategoryProvider = StateProvider<int?>((ref) => null);
