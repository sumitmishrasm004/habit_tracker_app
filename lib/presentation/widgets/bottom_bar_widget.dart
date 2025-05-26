import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/presentation/providers/bottom_bar_provider.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomBottomBar extends ConsumerWidget {
  final List<BottomBarItem> bottomBarItems = [
    BottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text('Home'),
        activeColor: AppColors.primaryBlue,
        activeIconColor: AppColors.primaryBlue.withOpacity(0.8),
        activeTitleColor: AppColors.primaryBlue.withOpacity(0.8),
        inactiveColor: Colors.grey),
    BottomBarItem(
        icon: const Icon(Icons.summarize),
        title: const Text('Stats'),
        activeColor: Colors.red,
        activeIconColor: Colors.red.shade600,
        activeTitleColor: Colors.red.shade700,
        inactiveColor: Colors.grey),
    BottomBarItem(
        icon: const Icon(Icons.file_copy),
        title: const Text('Reports'),
        backgroundColorOpacity: 0.1,
        activeColor: Colors.greenAccent,
        activeIconColor: Colors.greenAccent.shade400,
        activeTitleColor: Colors.greenAccent.shade700,
        inactiveColor: Colors.grey),
    // BottomBarItem(
    //     icon: const Icon(Icons.group),
    //     title: const Text('Group'),
    //     activeColor: Colors.red,
    //     activeIconColor: Colors.red.shade600,
    //     activeTitleColor: Colors.red.shade700,
    //     inactiveColor: Colors.grey),
    BottomBarItem(
        icon: const Icon(Icons.settings),
        title: const Text('Settings'),
        activeColor: Colors.orange,
        activeIconColor: Colors.orange.shade600,
        activeTitleColor: Colors.orange.shade700,
        inactiveColor: Colors.grey),
  ];

  CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(bottomBarProvider);
    return BottomBar(
        selectedIndex: selectedIndex,
        items: bottomBarItems,
        onTap: (index) {
          ref.read(bottomBarProvider.notifier).updateIndex(index);
        });
  }
}
