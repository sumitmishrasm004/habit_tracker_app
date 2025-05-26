import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/image_strings.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/data/repository/homepage_repository.dart';
import 'package:habit_tracker/presentation/mixin/settings_mixin.dart';
import 'package:habit_tracker/presentation/providers/bottom_bar_provider.dart';
import 'package:habit_tracker/presentation/providers/settings_provider.dart';
import 'package:habit_tracker/presentation/providers/suggestion_provider.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/widgets/all_custom_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SettingsScreen extends StatefulHookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SettingsMixin {
  bool isAnonymous = false;
  String username = '';
  bool isLoginWithMobileNumber = false;
  String mobileNumber = '';
  bool isSwitched = false;
  bool notificationStatus = true;
  String selectedOption = '';
  HtDatabaseImpl databaseImpl = HtDatabaseImpl();
  HomepageRepository? homepageRepository;

  @override
  void initState() {
    super.initState();
    isAnonymous = SharedprefUtils.getBool('isAnonymous');
    username = SharedprefUtils.getString(userName);
    isLoginWithMobileNumber = SharedprefUtils.getBool(isSignInWithMobile);
    mobileNumber = SharedprefUtils.getString(phoneNumber);
    notificationStatus = SharedprefUtils.getBool(isNotificationOn);
    updateNotificationStatus();
    homepageRepository = HomepageRepository(databaseImpl);
  }

  Future<void> updateNotificationStatus() async {
    Future.delayed(Duration(microseconds: 1)).then((_) {
      ref
          .read(dailyNotificationStatusProvider.notifier)
          .updateDailyNotificationStatus(notificationStatus);
    });
  }

  void toggleSwitch({required WidgetRef ref, required bool value}) {
    SharedprefUtils.setBool(isNotificationOn, value);
    ref
        .read(dailyNotificationStatusProvider.notifier)
        .updateDailyNotificationStatus(value);
    if (value) {
      setNotifiications();
    } else {
      stopNotifications();
    }
  }

  Future<void> handleNavigation(String option, VoidCallback navigate) async {
    setState(() {
      selectedOption = option;
    });
    await Future.delayed(
        const Duration(milliseconds: 200)); // Animation duration
    navigate();
  }

  // Function to show the confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text(
              "Do you really want to delete your Account/Data? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                // Perform delete action here
                await _deleteAccountOrData();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete the account or data (you can replace this with your logic)
  Future<void> _deleteAccountOrData() async {
    // Add your deletion logic here
    await handleNavigation('Delete Account/Data', () async {
      // Delete all data locally and in Firebase
       Navigator.of(context).pop();
      await databaseImpl.deleteAllData();
      await homepageRepository?.deleteUserData();
      // Navigator.of(context).pop();
      stopNotifications();
      await logout(context);
      ref.read(bottomBarProvider.notifier).updateIndex(0);
      // // Clear all shared preferences
      // SharedprefUtils.clearAllSharedPreferences();
      //  // Close the dialog

      // // Navigate to LoginScreen and clear the navigation stack
      // Future.delayed(Duration(milliseconds: 500), (){
      //   AutoRouter.of(context).replaceAll([LoginRoute()]);
      // ref.read(bottomBarProvider.notifier).updateIndex(0);
      // });
    });
    Logger.log(message: 'Account/Data deleted');
  }

  @override
  Widget build(BuildContext context) {
    bool dailyNotificationStatus = ref.watch(dailyNotificationStatusProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: scaffoldBody(
          ref: ref, dailyNotificationStatus: dailyNotificationStatus),
    );
  }

  Widget userDetails() => Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(boy_image),
          ),
          const SizedBox(
            width: 10,
          ),
          isLoginWithMobileNumber
              ? Text(
                  mobileNumber,
                  style: const TextStyle(fontSize: 18),
                )
              : Text(
                  username,
                  style: const TextStyle(fontSize: 18),
                ),
        ],
      );

  Widget scaffoldBody(
          {required WidgetRef ref, required bool dailyNotificationStatus}) =>
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView(
          children: [
            isAnonymous
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () async {
                        await handleNavigation('Login', () {
                          AutoRouter.of(context).pushAndPopUntil(
                            LoginRoute(),
                            predicate: (route) => false,
                          );
                          ref.read(bottomBarProvider.notifier).updateIndex(0);
                        });
                      },
                    ),
                  )
                : userDetails(),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () async {
                  await handleNavigation('Suggestions', () {
                    AutoRouter.of(context).push(const SuggestionRoute());
                  });
                  ref.read(suggestionProvider.notifier).clearHabits();
                },
                child: buildSettingItem('Suggestions')),
            const SizedBox(
              height: 35,
            ),
            GestureDetector(
                onTap: () async {
                  await handleNavigation('Habit Manager', () {
                    AutoRouter.of(context).push(const HabitManager());
                  });
                },
                child: buildSettingItem('Habit Manager')),
            const SizedBox(
              height: 35,
            ),
            GestureDetector(
                onTap: () {
                  _showDeleteConfirmationDialog(context);
                },
                child: buildSettingItem('Delete Account/Data')),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Daily Notification',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
                  customSmallButton(
                    child: Center(
                        child: toggleSwitchButton(
                            color: AppColors.primaryBlue,
                            isSwitched: dailyNotificationStatus,
                            onChanged: (isSwitched) =>
                                toggleSwitch(ref: ref, value: isSwitched))),
                    backgroundColor: Colors.white,
                    width: 70,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            isAnonymous
                ? SizedBox()
                : GestureDetector(
                    onTap: () async {
                      await handleNavigation('Logout', () async {
                        await logout(context);
                        ref.read(bottomBarProvider.notifier).updateIndex(0);
                      });
                    },
                    child: buildSettingItem('Logout')),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      );

  Widget buildSettingItem(String title) {
    bool isSelected = selectedOption == title;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.primaryBlue : Colors.black,
        ),
      ),
    );
  }
}
