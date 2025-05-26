import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/helper.dart';
import 'package:intl/intl.dart';

class Utils {
  static final Random random = Random();
  static bool otpValidate(String input) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(input);
  }

  static int dateForDb(DateTime dateTime) {
    try {
      String dateFormat = DateFormat("yyyy-MM-dd").format(dateTime);
      DateTime currentDateTime = DateTime.parse(dateFormat);
      return currentDateTime.millisecondsSinceEpoch;
    } on FormatException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Date format issue");
    }
  }

  static DateTime convertTimestampToDateTime(int dbDateTime) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(dbDateTime);
    } on FormatException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Date format issue");
    }
  }

  static List<int> splitHoursAndMinutes(String time) {
    // Split the time string using ':' as the delimiter
    List<String> parts = time.split(':');

    if (parts.length == 2) {
      // Extract hours and minutes
      String hour = parts[0]; // '10'
      String minute = parts[1]; // '20'

      // Convert to integers if needed
      int hourInt = int.parse(hour);
      int minuteInt = int.parse(minute);
      return [hourInt, minuteInt];
    } else {
      print('Invalid time format');
      return [0, 0];
    }
  }

  static String convertDateTimeToHoursMinutes(String dateTimeString) {
    // Logger.log(message: 'dateTimeString ===> ${dateTimeString}');
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    Logger.log(message: 'formattedTime ===> $formattedTime');
    return formattedTime;
  }

  static Color generateRandomColor() {
    return Color.fromRGBO(
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
      1.0, // Alpha (1.0 for opaque)
    );
  }

  static DateTime parseDate({required String date}) {
    // Logger.log(message: "ParseDate : ${DateTime.parse(date)}");
    return DateTime.parse(date);
  }

  static String formatDate({required DateTime dateTime}) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    // Logger.log(message: "FormatDate : $formattedDate");
    return formattedDate;
  }

  static String showDateOnly(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString().length == 1
        ? '0${dateTime.day.toString()}'
        : dateTime.day.toString();
    return '$year-$month-$day';
  }

  static String formatTimer(int timerValue) {
    final minutes = (timerValue / 60).floor();
    final seconds = timerValue % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static int convertIntoSeconds({required String type, required int time}) {
    if (type == 'min') {
      return time * 60;
    } else if (type == 'hr') {
      return time * 60 * 60;
    }
    return time;
  }

  static int roundoffSeconds({required String type, required int time}) {
    double value = 0.0;
    int roundoffValue = time;
    if (type == 'min') {
      value = time / 60;
      roundoffValue = value.round();
      return roundoffValue;
    } else if (type == 'hr') {
      value = time / 360;
      roundoffValue = value.round();
      return roundoffValue;
    }
    return roundoffValue;
  }

  static int convertToMin({required String type, required int time}) {
    double value = 0.0;
    int roundoffValue = time;
    if (type == 'sec') {
      value = time / 60;
      roundoffValue = value.round();
      return roundoffValue;
    } else if (type == 'hr') {
      value = time * 60;
      roundoffValue = value.round();
      return roundoffValue;
    }
    return roundoffValue;
  }

  static DateTime getLastDayOfMonth(DateTime date) {
    int lastDay = DateTime(date.year, date.month + 1, 0).day;
    return DateTime(date.year, date.month, lastDay);
  }

  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getFirstDateOfWeek(DateTime date) {
    // Calculate the difference between the given date's weekday and Monday
    int difference = date.weekday - DateTime.monday;

    // Subtract the difference to get the first day of the week
    DateTime firstDayOfWeek = date.subtract(Duration(days: difference));

    // Reset the time to midnight
    firstDayOfWeek =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);

    return firstDayOfWeek;
  }

  static DateTime getLastDateOfWeek(DateTime date) {
    // Calculate the difference between the given date's weekday and Sunday
    int difference = DateTime.sunday - date.weekday;

    // Add the difference to get the last day of the week
    DateTime lastDayOfWeek = date.add(Duration(days: difference));

    // Reset the time to the end of the day
    lastDayOfWeek = DateTime(
      lastDayOfWeek.year,
      lastDayOfWeek.month,
      lastDayOfWeek.day,
      23,
      59,
      59,
      999,
    );
    return lastDayOfWeek;
  }

  static bool isConsecutiveDate(DateTime previousDate, DateTime nextDate) {
    // Calculate the difference in days between the two dates
    int differenceInDays = nextDate.difference(previousDate).inDays;

    // Check if the difference is exactly 1 day
    return differenceInDays == 1;
  }

  static String getMonthName(DateTime date) {
    String formattedStartDate = DateFormat.MMM().format(date);
    return formattedStartDate;
  }

  static roundOffPercentage(double percentage) {
    String formattedPercentage = percentage.toStringAsFixed(2);

// Check if the formatted percentage ends with ".00" and remove it
    if (formattedPercentage.endsWith('.00')) {
      formattedPercentage =
          formattedPercentage.substring(0, formattedPercentage.length - 3);
    }
    return formattedPercentage;
  }

  static int customRounding(double number) {
  int integerPart = number.floor(); // Extract the integer part
  double decimalPart = number - integerPart; // Extract the decimal part
  
  // Check if the decimal part is greater than or equal to 0.5
  if (decimalPart >= 0.5) {
    // Round up
    return integerPart + 1;
  } else {
    // Round down
    return integerPart;
  }
}

 static Color getTextColorForBackground(Color backgroundColor) {
  // Calculate the relative luminance of the background color
  double luminance = backgroundColor.computeLuminance();

  // Determine the contrast ratio against white (1.0) and black (0.0)
  double whiteContrast = (1.0 + 0.05) / (luminance + 0.05);
  double blackContrast = (luminance + 0.05) / (0.0 + 0.05);

  // Return white if the contrast ratio against white is higher, otherwise return black
  return whiteContrast > blackContrast ? Colors.white : Colors.black;
}

static showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
          message),
      duration: const Duration(seconds: 2), // Duration to show the Snackbar
      action: SnackBarAction(
        label: 'Close', // Action label
        onPressed: () {
          // Action to perform when the user taps on the action button
        },
      ),
      behavior: SnackBarBehavior.floating, // Set behavior to floating
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}
