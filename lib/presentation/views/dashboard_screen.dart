import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habit_tracker/presentation/providers/bottom_bar_provider.dart';
import 'package:habit_tracker/presentation/providers/homepage_provider.dart';
import 'package:habit_tracker/presentation/views/homepage_screen.dart';
import 'package:habit_tracker/presentation/views/report_ui_screen.dart';
import 'package:habit_tracker/presentation/views/reports_screen.dart';
import 'package:habit_tracker/presentation/views/settings_screen.dart';
import 'package:habit_tracker/presentation/widgets/bottom_bar_widget.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardScreen extends HookConsumerWidget {
  DashboardScreen({super.key});

  final List<Widget> pages = [
    HomepageScreen(),
    ReportsScreen(),
    ReportUIScreen(),
    // const Center(
    //   child: Text('Groups'),
    // ),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(bottomBarProvider);
    return PopScope(
     canPop: true, //When false, blocks the current route from being popped.
    onPopInvoked: (didPop) {
        //do your logic here:
        // setStatusBarColor(
        //     statusBarColorPrimary,
        //     statusBarIconBrightness: Brightness.light,
        // );
        // finish(context);
    },
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: SafeArea(child: CustomBottomBar()),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
