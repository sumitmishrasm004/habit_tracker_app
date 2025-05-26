import 'dart:async';
import 'package:flutter/material.dart';


class OtpTimer extends StatefulWidget {
  final int countdownDuration;
  final TextStyle textStyle;
   bool isOtpTimerVisible;

  OtpTimer({required this.countdownDuration, required this.textStyle, required this.isOtpTimerVisible});

  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingSeconds = widget.countdownDuration;
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_remainingSeconds > 0) {
       _remainingSeconds = _remainingSeconds - 1;
      } else {
        _timer.cancel();
        widget.isOtpTimerVisible = false;
      }
    });
  }

  String getFormattedTime() {
    int minutes = (_remainingSeconds ~/ 60);
    int seconds = _remainingSeconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (seconds < 10) ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 0), (i) => i),
      builder: (context, snapshot) {
        return Text(
          getFormattedTime(),
          style: widget.textStyle,
        );
      },
    );
  }
}
