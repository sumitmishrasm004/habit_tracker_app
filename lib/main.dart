import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/config/router/app_router.dart';
import 'package:habit_tracker/config/themes/app_theme.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/services/notification_service.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedprefUtils.init();
  await initNotifications();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
      //  options: DefaultFirebaseOptions.currentPlatform,
      );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // FirebaseCrashlytics.instance.crash(); // Force a crash
  await HtDatabaseImpl().database;
  await authorize();
  if (kReleaseMode) {
    // Release mode
    Logger.log(message: 'Running in release mode');
  } else {
    // Debug or profile mode
    Logger.log(message: 'Running in debug or profile mode');
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
  // await authorize();
}

Future<void> initNotifications() async {
  NotificationService notificationService = NotificationService();
  // await notificationService.initNotification();
  await notificationService.initAwesomeNotifications();
  notificationService.requestAwesomeNotificationsPermission();
  if (Platform.isIOS) {
    await notificationService.requestIOSPermissions();
  } else {
    await notificationService.requestAndroidPermission();
  }
}

Future authorize() async {
  Health().configure(useHealthConnectIfAvailable: true);
  final types = [
    HealthDataType.STEPS,
    //  HealthDataType.WEIGHT,
    // HealthDataType.HEIGHT,
    // HealthDataType.BLOOD_GLUCOSE,
    // HealthDataType.WORKOUT,
    // HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    // HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    // Uncomment these lines on iOS - only available on iOS
    // HealthDataType.AUDIOGRAM
  ];

  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();
  Health health = Health();
  Health().configure(useHealthConnectIfAvailable: true);

  await Permission.activityRecognition.request();
  await Permission.location.request();

  // Check if we have permission
  bool? hasPermissions =
      await health.hasPermissions(types, permissions: permissions);

  hasPermissions = false;

  bool authorized = false;
  if (!hasPermissions) {
    // requesting access to the data types before reading them
    try {
      authorized =
          await health.requestAuthorization(types, permissions: permissions);
    } catch (error) {
      Logger.log(message: "Exception in authorize: $error");
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
      title: 'Habitron',
      theme: AppTheme.light,
      // home: const MyHomePage(title: 'Habitron'),
    );
  }
}
