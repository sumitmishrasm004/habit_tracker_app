import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerModel {
  int seconds;
  bool isTimerRunning;

  TimerModel({this.seconds = 0, this.isTimerRunning = false});

  TimerModel copyWith({int? seconds, bool? isTimerRunning}) {
    return TimerModel(
      seconds: seconds ?? this.seconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, TimerModel>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerModel> {
  Timer? _timer;

  TimerNotifier() : super(TimerModel());

  void toggleTimer() {
    if (state.isTimerRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        state = state.copyWith(seconds: state.seconds + 1);
      });
    }
    state = state.copyWith(isTimerRunning: !state.isTimerRunning);
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        state = state.copyWith(seconds: state.seconds + 1, isTimerRunning: true);
      });
      // state = state.copyWith(isTimerRunning: true);
  }

  void stopTimer() {
    if(state.isTimerRunning){
      _timer?.cancel();
    }
    state = state.copyWith(isTimerRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = TimerModel();
  }

  void increaseTimer(int secondsToReduce) {
    final newSeconds = state.seconds + secondsToReduce;
    state = state.copyWith(seconds: newSeconds > 0 ? newSeconds : 0);
  }

  void updateTimer(int seconds) {
    state = state.copyWith(seconds: seconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}