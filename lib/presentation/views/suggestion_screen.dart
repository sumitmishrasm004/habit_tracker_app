import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/assets_path.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/providers/habit_list_provider.dart';
import 'package:habit_tracker/presentation/providers/suggestion_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SuggestionScreen extends StatefulHookConsumerWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuggestionScreenState();
}

class _SuggestionScreenState extends ConsumerState<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male'; // Default gender
  String _suggestions = "";
  String bmiSuggestion = "";
  String calorieSuggestion = "";
  String fitnessSuggestion = "";
  String lifestyleSuggestion = "";
  bool _isPressed = false;

  String calculateBMI(double height, double weight) {
    double bmi = weight / ((height / 100) * (height / 100));

    if (bmi < 18.5) {
      return 'Underweight - Consider a diet rich in nutrients and regular exercise.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight - Maintain your current routine and aim for at least 10,000 steps a day.';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight - Aim to increase physical activity and reduce calorie intake.';
    } else {
      return 'Obese - Consider a comprehensive exercise plan and consult with a healthcare provider.';
    }
  }

  String suggestDailyCalories(
      double height, double weight, String gender, int age) {
    double bmr;
    gender = gender.toLowerCase(); // Convert to lowercase for uniformity

    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (gender == 'female') {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      // Default case for other gender options
      bmr = 10 * weight + 6.25 * height - 5 * age;
    }

    double dailyCalories = bmr * 1.2; // Assuming sedentary lifestyle

    return 'Your estimated daily caloric need is ${dailyCalories.toStringAsFixed(0)} calories.';
  }

  String suggestFitnessRoutine(double bmi, String gender) {
    if (gender.toLowerCase() == 'female') {
      if (bmi < 18.5) {
        return 'Focus on strength training and aim for 30 minutes of moderate exercise daily.';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return 'Aim for 150 minutes of aerobic activity per week along with muscle-strengthening exercises.';
      } else if (bmi >= 25 && bmi < 29.9) {
        return 'High-intensity workouts and 30 minutes of exercise 5 days a week is recommended.';
      } else {
        return 'Cardio and strength training combined with professional guidance is recommended.';
      }
    } else {
      if (bmi < 18.5) {
        return 'Include strength training 3 times a week and aim for 30 minutes of moderate exercise daily.';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return 'Maintain 150 minutes of moderate aerobic activity and muscle-strengthening exercises.';
      } else if (bmi >= 25 && bmi < 29.9) {
        return 'Incorporate high-intensity interval training (HIIT) and aim for at least 30 minutes of exercise daily.';
      } else {
        return 'Focus on cardio and strength training, and consult a fitness professional.';
      }
    }
  }

  String suggestLifestyleChanges(double bmi, String gender) {
    if (gender.toLowerCase() == 'female') {
      if (bmi < 18.5) {
        return 'Focus on increasing calorie intake with healthy foods and regular meals.';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return 'Maintain healthy eating habits and stay active to sustain your weight.';
      } else if (bmi >= 25 && bmi < 29.9) {
        return 'Reduce sugary foods, control portions, and increase physical activity.';
      } else {
        return 'Adopt a balanced diet and regular exercise, and consult with a healthcare provider.';
      }
    } else {
      if (bmi < 18.5) {
        return 'Focus on increasing calorie intake with nutrient-dense foods and regular meals.';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return 'Maintain healthy eating habits and stay active to maintain your weight.';
      } else if (bmi >= 25 && bmi < 29.9) {
        return 'Monitor portion sizes, reduce sugary and fatty foods, and increase physical activity.';
      } else {
        return 'Adopt a healthy eating plan with a balanced diet and regular exercise.';
      }
    }
  }

  void provideSuggestions(
      double height, double weight, String gender, int age) {
    double bmi = weight / ((height / 100) * (height / 100));
    bmiSuggestion = calculateBMI(height, weight);
    calorieSuggestion =
        suggestDailyCalories(height, weight, gender.toLowerCase(), age);
    fitnessSuggestion = suggestFitnessRoutine(bmi, gender);
    lifestyleSuggestion = suggestLifestyleChanges(bmi, gender);

    setState(() {
      _suggestions = '''
      $bmiSuggestion
      $calorieSuggestion
      $fitnessSuggestion
      $lifestyleSuggestion
      ''';
    });
  }

  HabitsModel setGoalBasedOnSuggestion(HabitsModel habitmodel, String habit) {
    final model = habitmodel;
    // Regular expression to match the number with or without commas (e.g., "10,000 steps")
    final RegExp stepsRegExp = RegExp(r'(\d{1,3}(,\d{3})*) steps');
    final RegExp minutesRegExp = RegExp(r'\d+ minutes');

    if (habit == 'walk') {
      // Check for step goal in bmiSuggestion
      if (stepsRegExp.hasMatch(bmiSuggestion)) {
        final stepsMatch = stepsRegExp.firstMatch(bmiSuggestion);
        if (stepsMatch != null) {
          String stepsString = stepsMatch.group(0)!.replaceAll(' steps', '');
          stepsString = stepsString.replaceAll(',', ''); // Remove commas
          model.goal = stepsString;
        }
      }
    } else {
      // Check for minutes goal in fitnessSuggestion
      if (minutesRegExp.hasMatch(fitnessSuggestion)) {
        final minutesMatch = minutesRegExp.firstMatch(fitnessSuggestion);
        if (minutesMatch != null) {
          String minutesString =
              minutesMatch.group(0)!.replaceAll(' minutes', '');
          model.goal = minutesString;
        }
      }
    }

    return model;
  }

  addHabitsInSuggestionProvider() {
    if (bmiSuggestion.contains("steps"))
      ref.read(suggestionProvider).add('steps');
    if (fitnessSuggestion.contains("minutes"))
      ref.read(suggestionProvider).add('min');
    if (lifestyleSuggestion.contains("reduce sugary"))
      ref.read(suggestionProvider).add('gm');
  }

  @override
  Widget build(BuildContext context) {
    var habitListProvider =
        ref.watch(getHabitsListProvider(AssetPath.buildHabits));
    var quitHabitListProvider =
        ref.watch(getHabitsListProvider(AssetPath.quitHabits));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Enter Your Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Gender",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    items: ['Male', 'Female', 'Other'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _gender = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Please enter a valid height';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Center(
                      child: AnimatedScale(
                    scale: _isPressed ? 0.95 : 1.0,
                    duration: Duration(milliseconds: 100),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context)
                            .unfocus(); // Dismiss the keyboard
                      },
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          // Trigger animation on press
                          setState(() {
                            _isPressed = true;
                          });

                          // Simulate some delay to show animation (optional)
                          await Future.delayed(Duration(milliseconds: 100));

                          // Call your existing logic
                          if (_formKey.currentState!.validate()) {
                            double height =
                                double.parse(_heightController.text);
                            double weight =
                                double.parse(_weightController.text);
                            String gender = _gender;
                            int age = int.parse(_ageController.text);
                            provideSuggestions(height, weight, gender, age);
                            addHabitsInSuggestionProvider();
                          }

                          // Reset the animation after logic is complete
                          setState(() {
                            _isPressed = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          child: Text('Submit', style: TextStyle(fontSize: 18)),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 30),
                  if (_suggestions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalized Suggestions:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          bmiSuggestion,
                          style: TextStyle(fontSize: 16),
                        ),
                        if (bmiSuggestion.contains("steps") &&
                            ref
                                .read(suggestionProvider.notifier)
                                .containsHabit('steps'))
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (habitListProvider.value != null) {
                                  HabitsModel habitsModel =
                                      habitListProvider.value![0].copyWith();
                                  HabitsModel model = setGoalBasedOnSuggestion(
                                      habitsModel, 'walk');
                                  // model.goal = '10000';
                                  AutoRouter.of(context).push(CustomHabitRoute(
                                      habitsModel: model,
                                      screen: 'suggestion'));
                                }
                              },
                              child: Text('Create Walk Habit',
                                  style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 15),
                        Text(
                          calorieSuggestion,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 15),
                        Text(
                          fitnessSuggestion,
                          style: TextStyle(fontSize: 16),
                        ),
                        if (ref
                            .read(suggestionProvider.notifier)
                            .containsHabit('min'))
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (habitListProvider.value != null) {
                                  HabitsModel habitsModel =
                                      habitListProvider.value![3].copyWith();
                                  HabitsModel model = setGoalBasedOnSuggestion(
                                      habitsModel, 'exercise');
                                  // model.goal = 30;
                                  AutoRouter.of(context).push(CustomHabitRoute(
                                      habitsModel: model,
                                      screen: 'suggestion'));
                                }
                              },
                              child: Text('Create Exercise Habit',
                                  style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 15),
                        Text(
                          lifestyleSuggestion,
                          style: TextStyle(fontSize: 16),
                        ),
                        if (lifestyleSuggestion.contains("reduce sugary") &&
                            ref
                                .read(suggestionProvider.notifier)
                                .containsHabit('gm'))
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (habitListProvider.value != null) {
                                  HabitsModel habitsModel =
                                      quitHabitListProvider.value![2]
                                          .copyWith();
                                  // HabitsModel model =
                                  //     quitHabitListProvider.value![2];
                                  // model.goal = '10000';
                                  AutoRouter.of(context).push(CustomHabitRoute(
                                      habitsModel: habitsModel,
                                      screen: 'suggestion'));
                                }
                              },
                              child: Text('Reduce sugary foods',
                                  style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 15),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
