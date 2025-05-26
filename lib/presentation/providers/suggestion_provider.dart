import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define a provider for the list of suggested habits
final suggestionProvider =
    StateNotifierProvider<SuggestionNotifier, List<String>>(
  (ref) => SuggestionNotifier(),
);

class SuggestionNotifier extends StateNotifier<List<String>> {
  SuggestionNotifier()
      : super([
          'steps',
          'min',
          'gm',
          // Add other initial suggestions here
        ]);
        
  // Function to add a habit
  void addHabit(String habit) {
    if (!containsHabit(habit)) {
      state = [...state, habit];
    }
  }

  // Function to remove a habit
  void removeHabit(String habit) {
    state = state.where((item) => item != habit).toList();
  }

  // Function to check if a habit exists
  bool containsHabit(String habit) {
    return state.contains(habit);
  }

  void clearHabits() {
    state = [];
  }
}
