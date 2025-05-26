import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/helper.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android-specific settings for the notification.
  final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'custom_habit_channel_id',
    'Custom Habit Notifications',
    channelDescription: 'Get custom habit notifications',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    enableVibration: true,
    playSound: true,
  );

  // iOS-specific settings for the notification.
  final iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    presentBanner: true,
    // subtitle : '',
  );

  Future<void> requestAwesomeNotificationsPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> requestAndroidPermission() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  Future<void> requestIOSPermissions() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('boy');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  Future<void> initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelGroupKey: "reminders_group",
              channelKey: 'reminders',
              channelName: 'Reminders',
              channelDescription: 'Notifications to remind habits',
              playSound: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              defaultColor: AppColors.primaryBlue,
              ledColor: AppColors.primaryBlue)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'reminders_group', channelGroupName: 'Habitica group')
        ],
        debug: true);
  }

  notificationDetails() {
    return NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    Logger.log(message: "inside notification");
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future scheduleNotification({required int id,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // tz.TZDateTime(tz.local, scheduledNotificationDateTime.year, scheduledNotificationDateTime.month, scheduledNotificationDateTime.day, scheduledNotificationDateTime.hour, scheduledNotificationDateTime.minute,),
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleCustomHabitNotifications({required List<List<int>> remindertime,
    required DateTime startDate,
    required DateTime endDate,
    String title = 'Habitron',
    String body = 'Reminder Alert'}) async {
     Logger.log(message: "remindertime =====> $remindertime  startDate ===> $startDate   endDate ====> $endDate");
    // Schedule notifications for each day between the start and end dates at custom times.
    for (DateTime date = startDate;
    date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
    date = date.add(const Duration(days: 1))) {
for (List<int> time in remindertime) {
        DateTime combinedTime = DateTime(date.year, date.month, date.day, time[0], time[1]);
        if (combinedTime.isAfter(DateTime.now())) {
          Logger.log(message: "Schedule Notification for $combinedTime");
      final notificationStatus = await createNotification(id: DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF, title: title,
              body: body,
              scheduledDateTime: combinedTime, repeats: false,);
          // await scheduleNotification(
          //     id: DateTime
          //         .now()
          //         .millisecondsSinceEpoch & 0x7FFFFFFF,
          //     title: title,
          //     body: body,
          //     scheduledNotificationDateTime: combinedTime);
        } else {
          Logger.log(message: "FAILED");

        }
      }
    }
  }

  Future<void> schedulePeriodicNotification(int id, String title, String body,
      List<List<int>> times, String payload, String frequencyType, int? hours,
      [DateTimeComponents? dateTimeComponents]) async {
    for (var i = 0; i < times.length; i++) {
      final eventTime = TimeOfDay(hour: times[i][0], minute: times[i][1]);
      DateTime scheduledDateTime = scheduledTime(eventTime, frequencyType, hours!);
      final notificationStatus = await createNotification(
          id:  DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF, title: title, body: body, scheduledDateTime: scheduledDateTime);
      Logger.log(message: "NOTIFICATION ID : $notificationStatus, $scheduledDateTime");
    }
  }

  Future<bool> createNotification({required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    bool repeats = true,
    bool preciseAlarm = true,
    bool allowWhileIdle = true}) async {
    final notificationStatus = await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'reminders',
            title: title,
            category: NotificationCategory.Reminder,
            body: body),
        schedule: NotificationCalendar.fromDate(
            date: scheduledDateTime,
            allowWhileIdle: allowWhileIdle,
            repeats: repeats,
            preciseAlarm: preciseAlarm));

    return notificationStatus;
  }

  DateTime scheduledTime(TimeOfDay eventTime, String frequencyType, int hours) {
    final DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      eventTime.hour,
      eventTime.minute,
    );

    if (frequencyType == 'daily') {
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    } else if (frequencyType == 'hourly') {
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(hours: hours));
      }
    }
    return scheduledDate;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<List<NotificationModel>> getPendingAwesomeNotifications() async {
    final List<NotificationModel> pendingNotificationRequests =
    await AwesomeNotifications().listScheduledNotifications();
    return pendingNotificationRequests;
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    final List<ActiveNotification> pendingNotificationRequests =
    await FlutterLocalNotificationsPlugin().getActiveNotifications();
    return pendingNotificationRequests;
  }

  Future<void> cancelNotifications({required int id}) async {
    Logger.log(message: "id cancelled ====> $id");
    await FlutterLocalNotificationsPlugin().cancel(id);
  }

  Future<void> cancelAwesomeNotifications({required int id}) async {
    Logger.log(message: "id cancelled ====> $id");
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelAllAwesomeNotifications() async {
    Logger.log(message: "All Notification cancelled");
    await AwesomeNotifications().cancelAll();
  }

  Future<void> cancelAllNotifications() async {
    Logger.log(message: "All Notification cancelled");
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}
