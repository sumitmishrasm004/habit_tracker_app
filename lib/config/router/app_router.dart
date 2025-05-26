import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen,Route")
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        /// routes go here
        AutoRoute(page: HomepageRoute.page, initial: false),
        AutoRoute(page: LoginRoute.page, initial: false),
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HabitRoute.page, initial: false),
        AutoRoute(page: CustomHabitRoute.page, initial: false),
        AutoRoute(page: DashboardRoute.page, initial: false),
        AutoRoute(page: ProgressValueRoute.page, initial: false),
        AutoRoute(page: ProgressTimerRoute.page, initial: false),
        AutoRoute(page: SettingsRoute.page, initial: false),
        AutoRoute(page: HabitManager.page, initial: false),
        AutoRoute(page: StatsRoute.page, initial: false),
        AutoRoute(page: ReportUIRoute.page, initial: false),
        AutoRoute(page: SuggestionRoute.page, initial: false),
        AutoRoute(page: OnboardingRoute.page, initial: false),
        // AutoRoute(page: LoginScreen.page, initial: true,),
      ];
}
