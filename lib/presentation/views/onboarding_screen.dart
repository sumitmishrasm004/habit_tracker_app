import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/image_strings.dart';
import 'package:introduction_screen/introduction_screen.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  Widget buildImage(String path) {
    return Center(
      child: Image.asset(path, width: 350),
    );
  }

  PageDecoration getPageDecoration() {
    return PageDecoration(
      imageFlex: 3,
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 18),
      titlePadding: EdgeInsets.all(16).copyWith(bottom: 0),
      imagePadding: EdgeInsets.all(24),
      pageColor: Colors.white,
      fullScreen: false,
      // safeArea: 100,
    );
  }

  DotsDecorator getDotsDecorator() {
    return DotsDecorator(
      size: Size(10, 10),
      color: Colors.black26,
      activeSize: Size(22, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Track Your Progress",
          body: "Track your daily habits and progress with this detailed view.",
          image: buildImage(home_image),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Weekly Progress Report",
          body:
              "Review your weekly progress and see how your habits are shaping up. Get insights and stay motivated to reach your goals.",
          image: buildImage(weekly_report),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "App Settings",
          body:
              "Adjust your app settings: get suggestions, manage habits, control daily notifications, and securely delete your account or data.",
          image: buildImage(setting_image),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Smart Recommendations",
          body:
              "Based on your input, we provide smart habit recommendations that are designed to help you achieve your goals faster and more effectively.",
          image: buildImage(suggestion_image),
          decoration: getPageDecoration(),
        ),
      ],
      onDone: () {
        //  AutoRouter.of(context).push(DashboardRoute());
        AutoRouter.of(context).replaceAll([DashboardRoute()]);
        // AutoRouter.of(context).pushAndPopUntil(
        //   DashboardRoute(),
        //   predicate: (route) =>
        //       false, // This will clear all the routes in the stack
        // );
      },
      onSkip: () {
        //  AutoRouter.of(context).popAndPush(DashboardRoute());
        AutoRouter.of(context).replaceAll([DashboardRoute()]);
        //  AutoRouter.of(context).pushAndPopUntil(
        //     DashboardRoute(),
        //     predicate: (route) =>
        //         false, // This will clear all the routes in the stack
        //   );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: getDotsDecorator(),
    );
  }
}
