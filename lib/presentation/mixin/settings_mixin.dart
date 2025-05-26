import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/services/notification_service.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

mixin SettingsMixin {
  Future<void> logout(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Sign out the user from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google if needed
      try {
        await googleSignIn.signOut();
      } catch (e) {
        Logger.log(message: 'Error signing out from Google: $e');
      }

      // For Apple Sign-In, FirebaseAuth.instance.signOut() is sufficient
      // Apple does not have an explicit sign-out API

      if (FirebaseAuth.instance.currentUser == null) {
        // Navigate to the login screen
        // AutoRouter.of(context).pushAndPopUntil(
        //   LoginRoute(),
        //   predicate: (route) => false,
        // );
        AutoRouter.of(context).replaceAll([LoginRoute()]);
        // Clear any stored user data
        SharedprefUtils.clearAllSharedPreferences();
      } else {
        Logger.log(message: 'Error: User not signed out successfully.');
      }
    } catch (e) {
      Logger.log(message: 'Error signing out: $e');
    }
  }

  Future<List<HabitsModel>> getAllHabit() async {
    List<HabitsModel> allHabitsList = [];
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      List<Map<dynamic, dynamic>> habitsValue =
          await databaseImpl.fetchAll(tableName: HtDatabaseImpl.habitTableName);
      Logger.log(message: "Calculation habit length : ${habitsValue.length}");
      if (habitsValue.isNotEmpty) {
        allHabitsList = habitsValue
            .map((e) => HabitsModel.fromJson(e as Map<String, Object?>))
            .toList();
      }
    } catch (e) {
      Logger.log(message: e.toString());
    }
    return allHabitsList;
  }

  List<List<int>> getAllReminders(String value) {
    List<List<int>> remindersTime = [];
    if (value != '') {
      List<String> values = value.split(',');
      if (values.isNotEmpty) {
        for (var element in values) {
          List<int> arr = Utils.splitHoursAndMinutes(element);
          remindersTime.add(arr);
        }
      }
    }
    // Logger.log(message:value);
    Logger.log(message: "allremindferTime ====> $remindersTime");
    return remindersTime;
  }

  Future<void> setNotifiications() async {
    List<HabitsModel> allHabitsList = await getAllHabit();
    if (allHabitsList.isNotEmpty) {
      for (var habitsModel in allHabitsList) {
        if (habitsModel.habitEndDate == 0) {
          NotificationService().schedulePeriodicNotification(
            DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF,
            'Habit Reminder - ${habitsModel.habitName}',
            habitsModel.habitDescription ?? '',
            getAllReminders(habitsModel.reminderTime ?? ''),
            'Periodic Notification',
            'daily',
            24,
          );
        } else {
          NotificationService().scheduleCustomHabitNotifications(
              title: 'Habit Reminder - ${habitsModel.habitName}',
              body: habitsModel.habitDescription ?? '',
              remindertime: getAllReminders(habitsModel.reminderTime ?? ''),
              startDate:
                  Utils.convertTimestampToDateTime(habitsModel.habitStartDate),
              endDate:
                  Utils.convertTimestampToDateTime(habitsModel.habitEndDate));
        }
        // call only if habit has ended date
        handlingNotificationForEndingHabits(habitsModel);
      }
    }
  }

  Future<void> stopNotifications() async {
    try {
      NotificationService().cancelAllAwesomeNotifications();
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  void handlingNotificationForEndingHabits(HabitsModel habitsModel) async {
    DateTime startDate =
        Utils.convertTimestampToDateTime(habitsModel.habitStartDate);
    DateTime endedDate =
        Utils.convertTimestampToDateTime(habitsModel.habitEndDate);
    List<List<int>> endHabitsRemindersTime = [
      [11, 0]
    ];
    int difference = endedDate.difference(startDate).inDays;
    startDate = difference > 3
        ? endedDate.subtract(const Duration(days: 2))
        : startDate; // Last 3 days
    List<int> pendingNotificationId = [];
    habitsModel.habitEndNotificationID?.split(',').forEach((element) {
      if (element != "") pendingNotificationId.add(int.parse(element));
    });
    pendingNotificationId.forEach((element) async {
      await NotificationService().cancelAwesomeNotifications(id: element);
    });
    pendingNotificationId.clear();
    await NotificationService().scheduleCustomHabitNotifications(
        title: 'Habit Reminder - ${habitsModel.habitName}',
        body: 'Your habit ${habitsModel.habitName} is about to end',
        remindertime: endHabitsRemindersTime,
        startDate: startDate,
        endDate: endedDate);

    // List<PendingNotificationRequest> pendingNotificationRequests =
    //     await NotificationService().getPendingNotifications();
    // pendingNotificationRequests.forEach((element) async {
    //   if (element.body ==
    //       'Your habit ${habitsModel.habitName} is about to end') {
    //     pendingNotificationId.add(element.id);
    //   }
    // });
    // habitsModel.habitEndNotificationID = pendingNotificationId.join(',');

    List<NotificationModel> pendingNotificationRequests =
        await NotificationService().getPendingAwesomeNotifications();
    pendingNotificationRequests.forEach((NotificationModel element) async {
      if (element.content?.body ==
              'Your habit ${habitsModel.habitName} is about to end' &&
          element.content!.id != null) {
        pendingNotificationId.add(element.content!.id!);
      }
    });
    habitsModel.habitEndNotificationID = pendingNotificationId.join(',');
  }
}
