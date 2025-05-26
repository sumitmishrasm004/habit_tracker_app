import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/services/shared_preferences.dart';

mixin LoginMixin {
  void saveUserDetails(UserCredential userCredential, {String? email, String? displayName}) {
    SharedprefUtils.setBool(isSignin, true);
    SharedprefUtils.setString(userId, userCredential.user!.uid);
    SharedprefUtils.setString(userName, displayName ?? userCredential.user?.displayName ?? '');
    SharedprefUtils.setString(userEmail, email ?? userCredential.user?.email ?? '');
    SharedprefUtils.setBool(isAnonymous, userCredential.user?.isAnonymous ?? false);
  }

  void saveAnonymousUserDetails(UserCredential userCredential) {
    SharedprefUtils.setBool(isSignin, true);
    SharedprefUtils.setString(userId, userCredential.user?.uid ?? '');
    SharedprefUtils.setBool(isAnonymous, userCredential.user?.isAnonymous ?? false);
  }

  void savePhoneNumber(UserCredential userCredential) {
    SharedprefUtils.setBool(isSignin, true);
    SharedprefUtils.setBool(isSignInWithMobile, true);
    SharedprefUtils.setString(userId, userCredential.user!.uid);
    SharedprefUtils.setString(phoneNumber, userCredential.user?.phoneNumber ?? '');
    SharedprefUtils.setBool(isAnonymous, userCredential.user?.isAnonymous ?? false);
  }
}
