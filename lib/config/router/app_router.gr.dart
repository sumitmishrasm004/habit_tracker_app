// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:habit_tracker/domain/models/habits_model.dart' as _i17;
import 'package:habit_tracker/presentation/views/custom_habit_screen.dart'
    as _i1;
import 'package:habit_tracker/presentation/views/dashboard_screen.dart' as _i2;
import 'package:habit_tracker/presentation/views/habit_manager_screen.dart'
    as _i3;
import 'package:habit_tracker/presentation/views/habit_screen.dart' as _i4;
import 'package:habit_tracker/presentation/views/homepage_screen.dart' as _i5;
import 'package:habit_tracker/presentation/views/login_screen.dart' as _i6;
import 'package:habit_tracker/presentation/views/onboarding_screen.dart' as _i7;
import 'package:habit_tracker/presentation/views/progress_timer_screen.dart'
    as _i8;
import 'package:habit_tracker/presentation/views/progress_value_screen.dart'
    as _i9;
import 'package:habit_tracker/presentation/views/report_ui_screen.dart' as _i10;
import 'package:habit_tracker/presentation/views/settings_screen.dart' as _i11;
import 'package:habit_tracker/presentation/views/splash_screen.dart' as _i12;
import 'package:habit_tracker/presentation/views/stats_screen.dart' as _i13;
import 'package:habit_tracker/presentation/views/suggestion_screen.dart'
    as _i14;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    CustomHabitRoute.name: (routeData) {
      final args = routeData.argsAs<CustomHabitRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CustomHabitScreen(
          key: args.key,
          habitsModel: args.habitsModel,
          screen: args.screen,
        ),
      );
    },
    DashboardRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardRouteArgs>(
          orElse: () => const DashboardRouteArgs());
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.DashboardScreen(key: args.key),
      );
    },
    HabitManager.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HabitManager(),
      );
    },
    HabitRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.HabitScreen(),
      );
    },
    HomepageRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomepageScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoginScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.OnboardingScreen(),
      );
    },
    ProgressTimerRoute.name: (routeData) {
      final args = routeData.argsAs<ProgressTimerRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ProgressTimerScreen(
          key: args.key,
          habitsModel: args.habitsModel,
          currentDate: args.currentDate,
        ),
      );
    },
    ProgressValueRoute.name: (routeData) {
      final args = routeData.argsAs<ProgressValueRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ProgressValueScreen(
          key: args.key,
          habitsModel: args.habitsModel,
          currentDate: args.currentDate,
        ),
      );
    },
    ReportUIRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ReportUIScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SettingsScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashScreen(),
      );
    },
    StatsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.StatsScreen(),
      );
    },
    SuggestionRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SuggestionScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.CustomHabitScreen]
class CustomHabitRoute extends _i15.PageRouteInfo<CustomHabitRouteArgs> {
  CustomHabitRoute({
    _i16.Key? key,
    required _i17.HabitsModel? habitsModel,
    String screen = 'home',
    List<_i15.PageRouteInfo>? children,
  }) : super(
          CustomHabitRoute.name,
          args: CustomHabitRouteArgs(
            key: key,
            habitsModel: habitsModel,
            screen: screen,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomHabitRoute';

  static const _i15.PageInfo<CustomHabitRouteArgs> page =
      _i15.PageInfo<CustomHabitRouteArgs>(name);
}

class CustomHabitRouteArgs {
  const CustomHabitRouteArgs({
    this.key,
    required this.habitsModel,
    this.screen = 'home',
  });

  final _i16.Key? key;

  final _i17.HabitsModel? habitsModel;

  final String screen;

  @override
  String toString() {
    return 'CustomHabitRouteArgs{key: $key, habitsModel: $habitsModel, screen: $screen}';
  }
}

/// generated route for
/// [_i2.DashboardScreen]
class DashboardRoute extends _i15.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i16.Key? key,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          DashboardRoute.name,
          args: DashboardRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i15.PageInfo<DashboardRouteArgs> page =
      _i15.PageInfo<DashboardRouteArgs>(name);
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.HabitManager]
class HabitManager extends _i15.PageRouteInfo<void> {
  const HabitManager({List<_i15.PageRouteInfo>? children})
      : super(
          HabitManager.name,
          initialChildren: children,
        );

  static const String name = 'HabitManager';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HabitScreen]
class HabitRoute extends _i15.PageRouteInfo<void> {
  const HabitRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HabitRoute.name,
          initialChildren: children,
        );

  static const String name = 'HabitRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HomepageScreen]
class HomepageRoute extends _i15.PageRouteInfo<void> {
  const HomepageRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomepageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomepageRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.OnboardingScreen]
class OnboardingRoute extends _i15.PageRouteInfo<void> {
  const OnboardingRoute({List<_i15.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ProgressTimerScreen]
class ProgressTimerRoute extends _i15.PageRouteInfo<ProgressTimerRouteArgs> {
  ProgressTimerRoute({
    _i16.Key? key,
    required _i17.HabitsModel habitsModel,
    required DateTime currentDate,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ProgressTimerRoute.name,
          args: ProgressTimerRouteArgs(
            key: key,
            habitsModel: habitsModel,
            currentDate: currentDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ProgressTimerRoute';

  static const _i15.PageInfo<ProgressTimerRouteArgs> page =
      _i15.PageInfo<ProgressTimerRouteArgs>(name);
}

class ProgressTimerRouteArgs {
  const ProgressTimerRouteArgs({
    this.key,
    required this.habitsModel,
    required this.currentDate,
  });

  final _i16.Key? key;

  final _i17.HabitsModel habitsModel;

  final DateTime currentDate;

  @override
  String toString() {
    return 'ProgressTimerRouteArgs{key: $key, habitsModel: $habitsModel, currentDate: $currentDate}';
  }
}

/// generated route for
/// [_i9.ProgressValueScreen]
class ProgressValueRoute extends _i15.PageRouteInfo<ProgressValueRouteArgs> {
  ProgressValueRoute({
    _i16.Key? key,
    required _i17.HabitsModel habitsModel,
    required DateTime currentDate,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ProgressValueRoute.name,
          args: ProgressValueRouteArgs(
            key: key,
            habitsModel: habitsModel,
            currentDate: currentDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ProgressValueRoute';

  static const _i15.PageInfo<ProgressValueRouteArgs> page =
      _i15.PageInfo<ProgressValueRouteArgs>(name);
}

class ProgressValueRouteArgs {
  const ProgressValueRouteArgs({
    this.key,
    required this.habitsModel,
    required this.currentDate,
  });

  final _i16.Key? key;

  final _i17.HabitsModel habitsModel;

  final DateTime currentDate;

  @override
  String toString() {
    return 'ProgressValueRouteArgs{key: $key, habitsModel: $habitsModel, currentDate: $currentDate}';
  }
}

/// generated route for
/// [_i10.ReportUIScreen]
class ReportUIRoute extends _i15.PageRouteInfo<void> {
  const ReportUIRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ReportUIRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportUIRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SettingsScreen]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SplashScreen]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i13.StatsScreen]
class StatsRoute extends _i15.PageRouteInfo<void> {
  const StatsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          StatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StatsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SuggestionScreen]
class SuggestionRoute extends _i15.PageRouteInfo<void> {
  const SuggestionRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SuggestionRoute.name,
          initialChildren: children,
        );

  static const String name = 'SuggestionRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}
