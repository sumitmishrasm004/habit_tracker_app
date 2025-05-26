import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/colors.dart';
import 'package:habit_tracker/constant/icon_path.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/data/repository/authentication_repository.dart';
import 'package:habit_tracker/domain/models/login_model.dart';
import 'package:habit_tracker/presentation/mixin/login_mixin.dart';
import 'package:habit_tracker/presentation/providers/login_provider.dart';
import 'package:habit_tracker/presentation/providers/otp_timer_provider.dart';
import 'package:habit_tracker/presentation/providers/verification_id_value.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/enum/sign_in_state.dart';
import 'package:habit_tracker/utils/helpers/close_keyboard_formatter.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:habit_tracker/widgets/custom_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// class CustomHabitScreen extends StatefulHookConsumerWidget {
//   final HabitsModel? habitsModel;

//   CustomHabitScreen({super.key, required this.habitsModel});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _CustomHabitScreenState();
// }

// class _CustomHabitScreenState extends ConsumerState<CustomHabitScreen> {
@RoutePage()
class LoginScreen extends StatefulHookConsumerWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with LoginMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final authenticationRepository = AuthenticationRepository();
  final StreamController<SignInState> _signInWithGoogleController =
      StreamController<SignInState>();
  final StreamController<SignInState> _signInWithAppleController =
      StreamController<SignInState>();
  final StreamController<SignInState> _signInAnonymouslyController =
      StreamController<SignInState>();
  String errorMessage = "Error occured, Please try again";
  String textErrorMessage = '';
  String countryCode = '';
  String phoneNumber = '';
  String number = '';
  final auth = FirebaseAuth.instance;

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _signInWithGoogleController.close();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).updateProperties(
            newIsSendOtpLoading: false,
            newIsSubmitBtnClicked: false,
          );
    });
  }

  Future<void> onSubmitBtnClick(
    WidgetRef ref,
    BuildContext context,
  ) async {
    Logger.log(message: 'Phone Number: $phoneNumber');
    if (mobileController.text.isNotEmpty && number.length >= 10) {
      ref
          .read(loginProvider.notifier)
          .updateProperties(newIsSubmitButtonLoading: true, errorMessage: '');
      try {
        Map<String, dynamic> value =
            await authenticationRepository.sendOtp(phoneNumber: phoneNumber);
        Logger.log(message: "Value received after ===> $value");
        Logger.log(
            message:
                "Value received after verificationId ===> ${value['verificationId']}");
        Logger.log(
            message:
                "Value received after forceResendingToken ===> ${value['forceResendingToken']}  ${value['forceResendingToken'].runtimeType}");
        //  verificationId = value;
        int? resendToken = (value['forceResendingToken'] != null &&
                value['forceResendingToken'] != '')
            ? int.parse(value['forceResendingToken'])
            : null;
        LoginModel model = LoginModel(
            verificationId: value['verificationId'], resendToken: resendToken);
        Logger.log(message: "model ====> $model");
        ref.read(loginProvider.notifier).updateProperties(
            newIsSubmitBtnClicked: true,
            newIsSubmitButtonLoading: false,
            newVerificationId: model.verificationId,
            newResendToken: model.resendToken);
        //  ref.read(verificationIdProvider.notifier).updateVerificationIdValue(value['verificationId']);
      } catch (e) {
        if (e == 'The provided phone number is not valid.') {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false,
              newIsSubmitBtnClicked: false,
              errorMessage: e.toString());
        } else if (e == quotaExceeded) {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false, newIsSubmitBtnClicked: false);

          bool containsKey = await SharedprefUtils.containsKey(isFirstTimeUser);
          // If the key doesn't exist, set it to true
          if (!containsKey) {
            SharedprefUtils.setBool(isFirstTimeUser, true);
          }
          AutoRouter.of(context).push(OnboardingRoute());
        } else if (e == tooManyRequests) {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false, newIsSubmitBtnClicked: false);
          // Check if the isFirstTimeUser key exists
          bool containsKey = await SharedprefUtils.containsKey(isFirstTimeUser);
          // If the key doesn't exist, set it to true
          if (!containsKey) {
            SharedprefUtils.setBool(isFirstTimeUser, true);
          }
          AutoRouter.of(context).push(OnboardingRoute());
        } else {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false,
              newIsSubmitBtnClicked: false,
              errorMessage: e.toString());
        }
        LoginModel model = ref.watch(loginProvider);
        showSnackBar(context, model.errorMessage.toString());
        Logger.log(message: "Error in submit mobile number ==> $e");
      }
    } else {
      textErrorMessage = 'Please enter a valid phone number';
      setState(() {});
    }
  }

  Future<void> onOtpSubmit(
      WidgetRef ref, BuildContext context, LoginModel loginModel) async {
    if (_formKey.currentState!.validate() && mobileController.text.isNotEmpty) {
      ref
          .read(loginProvider.notifier)
          .updateProperties(newIsSendOtpLoading: true);
      final credential = PhoneAuthProvider.credential(
          verificationId: loginModel.verificationId ?? '',
          smsCode: otpController.text);
      Logger.log(message: "credential ==> $credential");
      try {
        final userCredential = await auth.signInWithCredential(credential);
        if (userCredential.user?.phoneNumber != null &&
            userCredential.user?.phoneNumber != "") {
          _signInWithGoogleController.sink.add(SignInState.Success);
          savePhoneNumber(userCredential);
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false, newIsSubmitBtnClicked: false);
          // Check if the isFirstTimeUser key exists
          bool containsKey = await SharedprefUtils.containsKey(isFirstTimeUser);
          // If the key doesn't exist, set it to true
          if (!containsKey) {
            SharedprefUtils.setBool(isFirstTimeUser, true);
          }
          AutoRouter.of(context).push(OnboardingRoute());
        }
      } catch (e) {
        // Error during OTP verification
        String verificationFailed =
            '[firebase_auth/invalid-verification-code] The multifactor verification code used to create the auth credential is invalid.Re-collect the verification code and be sure to use the verification code provided by the user.';
        if (e.toString() == verificationFailed) {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false, errorMessage: 'Invalid Otp');
        } else {
          ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false, errorMessage: e.toString());
        }
        showSnackBar(context, loginModel.errorMessage ?? '');
        Logger.log(message: "Error in verifying otp ==> $e");
      }
    }
  }

  void onOtpResubmit(
      WidgetRef ref, BuildContext context, LoginModel loginModel) async {
    if (mobileController.text.isNotEmpty && number.length >= 10) {
      ref
          .read(loginProvider.notifier)
          .updateProperties(newIsResendOtpLoading: true);
      try {
        Map<String, dynamic> value = await authenticationRepository.resendOtp(
            phoneNumber: phoneNumber,
            verificationId: loginModel.verificationId ?? '',
            forceResendingToken: loginModel.resendToken);
        ref.read(loginProvider.notifier).updateProperties(
            newIsResendOtpLoading: false,
            newVerificationId: value['verificationId'],
            newResendToken: int.parse(value['forceResendingToken']));
      } catch (e) {
        ref.read(loginProvider.notifier).updateProperties(
              newIsResendOtpLoading: false,
            );
        Logger.log(message: 'Error in resending otp and error ==> $e');
      }
    }
  }

  void onGoogleBtnClick(BuildContext context) async {
    _signInWithGoogleController.sink.add(SignInState.Loading);
    try {
      final userCredential = await authenticationRepository.signInWithGoogle();
      if (userCredential?.user?.email != null &&
          userCredential?.user?.email != "") {
        _signInWithGoogleController.sink.add(SignInState.Success);
        if (userCredential != null) saveUserDetails(userCredential);
        ref.read(loginProvider.notifier).updateProperties(
            newIsSendOtpLoading: false, newIsSubmitBtnClicked: false);
        // Check if the isFirstTimeUser key exists
        bool containsKey = await SharedprefUtils.containsKey(isFirstTimeUser);
        // If the key doesn't exist, set it to true
        if (!containsKey) {
          SharedprefUtils.setBool(isFirstTimeUser, true);
        }
        AutoRouter.of(context).push(OnboardingRoute());
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      Logger.log(message: "e.message ====> ${e.message}");
      _signInWithGoogleController.sink.add(SignInState.Error);
      errorMessage = e.message ?? 'An error occurred';
      showSnackBar(context, errorMessage);
      Logger.log(message: 'FirebaseAuthException: $errorMessage  ${e.code}');
    } on PlatformException catch (e) {
      Logger.log(message: "e.message ====> ${e.message}");
      // Handle PlatformException (for example, if Google Sign-In is not available)
      _signInWithGoogleController.sink.add(SignInState.Error);
      errorMessage = e.message ?? 'An error occurred';
      showSnackBar(context, errorMessage);
      Logger.log(message: 'PlatformException: $errorMessage ${e.code}');
    } catch (e) {
      Logger.log(message: "catch error ====> ${e}");
      // Catch any other unexpected exceptions
      _signInWithGoogleController.sink.add(SignInState.Error);
      errorMessage = e.toString();
      if (errorMessage !=
          'Exception: Error: Both accessToken and idToken are required.') {
        showSnackBar(context, errorMessage);
      }
      Logger.log(message: 'Unexpected Exception: $errorMessage ');
    }
  }

  void onAppleBtnClick(BuildContext context) async {
    _signInWithAppleController.sink.add(SignInState.Loading);
    try {
      final userCredential = await authenticationRepository.signInWithApple();
      if (userCredential?.user != null) {
        // Extract email and displayName from additionalUserInfo.profile
        final additionalInfo = userCredential!.additionalUserInfo?.profile;
        String? email = additionalInfo?['email'] as String?;
        String? displayName = additionalInfo?['name'] as String?;

        // Set default values if null
        email ??= userCredential.user?.email;
        displayName ??= userCredential.user?.displayName;

        // Save user details with extracted information
        saveUserDetails(userCredential, email: email, displayName: displayName);

        _signInWithAppleController.sink.add(SignInState.Success);
        ref.read(loginProvider.notifier).updateProperties(
              newIsSendOtpLoading: false,
              newIsSubmitBtnClicked: false,
            );
        // Check if the isFirstTimeUser key exists
        bool containsKey = await SharedprefUtils.containsKey(isFirstTimeUser);
        // If the key doesn't exist, set it to true
        if (!containsKey) {
          SharedprefUtils.setBool(isFirstTimeUser, true);
        }
        AutoRouter.of(context).push(OnboardingRoute());
      }
    } on FirebaseAuthException catch (e) {
      Logger.log(message: "e.message ====> ${e.message}");
      _signInWithAppleController.sink.add(SignInState.Error);
      showSnackBar(context, e.message ?? 'An error occurred');
    } on PlatformException catch (e) {
      Logger.log(message: "e.message ====> ${e.message}");
      _signInWithAppleController.sink.add(SignInState.Error);
      showSnackBar(context, e.message ?? 'An error occurred');
    } catch (e) {
      Logger.log(message: "catch error ====> ${e}");
      _signInWithAppleController.sink.add(SignInState.Error);
      showSnackBar(context, e.toString());
    }
  }

  Widget customButton(
          {required BuildContext context,
          required VoidCallback onPressed,
          required String text,
          Color backgroundColor = Colors.white,
          Color textColor = Colors.black,
          Image? image}) =>
      GestureDetector(
        onTap: onPressed,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: image != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image,
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        text,
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                  ),
          ),
        ),
      );

  Widget guestButton(BuildContext context) => TextButton(
      style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.red,
          textStyle: const TextStyle(color: Colors.black)),
      onPressed: () async {
        _signInAnonymouslyController.sink.add(SignInState.Loading);
        try {
          final userCredential =
              await authenticationRepository.signInAnonymously();
          if (userCredential.user?.uid != null &&
              userCredential.user?.uid != "") {
            _signInAnonymouslyController.sink.add(SignInState.Success);
            saveAnonymousUserDetails(userCredential);
            bool containsKey =
                await SharedprefUtils.containsKey(isFirstTimeUser);
            // If the key doesn't exist, set it to true
            if (!containsKey) {
              SharedprefUtils.setBool(isFirstTimeUser, true);
            }
            AutoRouter.of(context).pushAndPopUntil(
              OnboardingRoute(),
              predicate: (route) => false,
            );
          }
        } catch (e) {
          _signInAnonymouslyController.sink.add(SignInState.Error);
          errorMessage = e.toString();
          Logger.log(message: "catch error in guest login ====> ${e}");
          showSnackBar(context, errorMessage);
        }
      },
      child: const SizedBox(
        height: 40,
        // width: MediaQuery.of(context).size.width * 0.1,
        child: Center(
          child: Text(
            "Skip",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ));

  Widget otpContents(
      {required BuildContext context,
      required WidgetRef ref,
      required LoginModel loginModel}) {
    return Column(
      children: [
        // const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: CustomTextField(
              hintText: "Enter Otp",
              borderColor: grey500,
              enabledBorderColor: grey500,
              color: Colors.black,
              textColor: Colors.black,
              hintTextFontSize: 18,
              contentPadding: const EdgeInsets.only(
                  top: 15, left: 10.0, right: 10.0, bottom: 15),
              onChange: (value) {},
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly,
                const CloseKeyboardFormatter(textLength: 6),
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    (Utils.otpValidate(value))) {
                  Logger.log(message: "Otp Validated");
                } else {
                  return "Enter correct otp";
                }
                return null;
              },
              controller: otpController),
        ),
        const SizedBox(height: 20),
        loginModel.sendOtpLoading
            ? const CircularProgressIndicator(
                color: Colors.blue,
              )
            : customButton(
                context: context,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                onPressed: () => onOtpSubmit(ref, context, loginModel),
                text: "Submit Otp"),
        const SizedBox(
          height: 10,
        ),
        //  loginModel.resendOtpLoading
        //       ? Center(
        //         child: OtpTimer(
        //             countdownDuration: 30, // 60 seconds
        //             textStyle:
        //                 const TextStyle(fontSize: 24, color: Colors.white),
        //             isOtpTimerVisible: loginModel.resendOtpLoading,
        //           ),
        //       )
        //       : Center(
        //         child: InkWell(
        //             onTap: () async {
        //               // await widget.addVisitorController.resendOtp();
        //               // widget.addVisitorController.isOtpTimerVisible.value = true;
        //             },
        //             child: Text(
        //               "Resend Otp",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 16,
        //                 textBaseline: TextBaseline.alphabetic,
        //                 letterSpacing: 2.0,
        //                 height: 1.5,
        //                 decoration: TextDecoration.underline,
        //                 decorationThickness: 1.5,
        //               ),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //       ),
        loginModel.resendOtpLoading
            ? const CircularProgressIndicator(
                color: Colors.blue,
              )
            : Center(
                child: TextButton(
                    onPressed: () => onOtpResubmit(ref, context, loginModel),
                    child: const Text(
                      "Resend Otp",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),
              ),
      ],
    );
  }

  // Function to show a SnackBar
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Optional: Set the duration
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Handle undo action if needed
            // This is a button within the SnackBar
          },
        ),
      ),
    );
  }

  Widget submitBtn(LoginModel loginModel) => loginModel.submitButtonLoading
      ? const Center(
          child: CircularProgressIndicator(
          color: Colors.blue,
        ))
      : customButton(
          context: context,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            onSubmitBtnClick(ref, context);
          },
          text: "Submit");

  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = ref.watch(loginProvider);
    String verificationId = ref.watch(verificationIdProvider);
    bool isOtpTimerVisible = ref.watch(otpTimerProvider);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(login_image),
                //   fit: BoxFit.cover,
                // ),
                ),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Image(
                              image: AssetImage(fitness_icon),
                              // height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // IntlPhoneField(
                          //   disableLengthCheck: true,
                          //   inputFormatters: [
                          //     LengthLimitingTextInputFormatter(10),
                          //     FilteringTextInputFormatter.digitsOnly,
                          //     const CloseKeyboardFormatter(textLength: 10),
                          //   ],
                          //   dropdownTextStyle: const TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 16.0,
                          //       // fontFamily: AppConstant.overpass,
                          //       fontWeight: FontWeight.w400),
                          //   style: const TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 18.0,
                          //       // fontFamily: AppConstant.overpass,
                          //       fontWeight: FontWeight.w400),
                          //   decoration: InputDecoration(
                          //       // labelText: 'Enter your number',
                          //       prefixStyle: const TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 16.0,
                          //           // fontFamily: AppConstant.overpass,
                          //           fontWeight: FontWeight.w400),
                          //       hintText: 'Enter your number',
                          //       hintStyle: const TextStyle(color: Colors.white),
                          //       border: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //           width: 0.5,
                          //           color: Colors.blue,
                          //         ),
                          //         borderRadius: BorderRadius.circular(0),
                          //       ),
                          //       errorBorder: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //           width: 0.5,
                          //           color: Colors.red,
                          //         ),
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //       focusedErrorBorder: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //           width: 0.5,
                          //           color: Colors.red,
                          //         ),
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //           width: 1.0,
                          //           color: grey500,
                          //         ),
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //           width: 1.0,
                          //           color: grey500,
                          //         ),
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //       fillColor: grey500),
                          //   onChanged: (phone) {
                          //     countryCode = phone.countryCode;
                          //     phoneNumber = phone.completeNumber;
                          //     if (textErrorMessage != '') {
                          //       textErrorMessage = '';
                          //       setState(() {});
                          //     }
                          //     // Handle changes to the phone number field
                          //   },
                          //   onCountryChanged: (phone) {
                          //     // Handle changes to the selected country code
                          //     countryCode = phone.dialCode;
                          //   },
                          //   controller: mobileController,
                          //   initialCountryCode:
                          //       'IN', // Set your initial country code
                          //   validator: (phone) {
                          //     phoneNumber = phone?.completeNumber ?? '';
                          //     number = phone?.number ?? '';
                          //     // if (phone != null) {
                          //     //   return 'Please enter a phone number';
                          //     // }
                          //     if ((phone?.number == "" ||
                          //         phone?.number == null)) {
                          //       return 'Please enter a valid phone number';
                          //     }
                          //     return null; // Return null if the phone number is valid
                          //   },
                          // ),
                          // textErrorMessage != ''
                          //     ? Container(
                          //         margin: const EdgeInsets.only(top: 10),
                          //         padding: const EdgeInsets.only(left: 12),
                          //         child: Text(
                          //           textErrorMessage,
                          //           style: const TextStyle(
                          //               color: Color.fromARGB(255, 204, 18, 5),
                          //               fontSize: 12),
                          //         ))
                          //     : const SizedBox(),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // !loginModel.isSubmitBtnClicked
                          //     ? submitBtn(loginModel)
                          //     : otpContents(
                          //         context: context,
                          //         ref: ref,
                          //         loginModel: loginModel),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // const Center(
                          //   child: Text(
                          //     'OR',
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),

                          //  isOtpTimerVisible
                          //       ? Center(
                          //         child: OtpTimer(
                          //             countdownDuration: 30, // 60 seconds
                          //             textStyle:
                          //                 const TextStyle(fontSize: 24, color: Colors.white),
                          //             isOtpTimerVisible: isOtpTimerVisible,
                          //           ),
                          //       )
                          //       : Center(
                          //         child: InkWell(
                          //             onTap: () async {
                          //               // await widget.addVisitorController.resendOtp();
                          //               // widget.addVisitorController.isOtpTimerVisible.value = true;
                          //             },
                          //             child: Text(
                          //               "Resend Otp",
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 16,
                          //                 textBaseline: TextBaseline.alphabetic,
                          //                 letterSpacing: 2.0,
                          //                 height: 1.5,
                          //                 decoration: TextDecoration.underline,
                          //                 decorationThickness: 1.5,
                          //               ),
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //       ),

                          // CustomTextField(
                          //   controller: emailController,
                          //   hintText: "Email",
                          //   textInputType: TextInputType.emailAddress,
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          // CustomTextField(
                          //   controller: passwordController,
                          //   hintText: "Password",
                          //   obscureText: true,
                          // ),
                          // SizedBox(
                          //   height: 50,
                          // ),
                          // CustomButton(
                          //   title: "Login",
                          //   onTap: () {
                          //     print("Clicked");
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 600,
                          // ),
                          StreamBuilder<SignInState>(
                            stream: _signInWithGoogleController.stream,
                            initialData: SignInState.Success,
                            builder: (context, snapshot) {
                              switch (snapshot.data) {
                                case SignInState.Loading:
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  );
                                case SignInState.Error:
                                  return Column(
                                    children: [
                                      customButton(
                                          context: context,
                                          image: const Image(
                                            image: AssetImage(
                                              google_icon,
                                            ),
                                            height: 30,
                                          ),
                                          backgroundColor: Colors.white,
                                          text: "Login with Google",
                                          onPressed: () {
                                            onGoogleBtnClick(context);
                                          }),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Text("${errorMessage}")
                                    ],
                                  );
                                case SignInState.Success:
                                  return customButton(
                                      context: context,
                                      image: const Image(
                                        image: AssetImage(
                                          google_icon,
                                        ),
                                        height: 30,
                                      ),
                                      backgroundColor: Colors.white,
                                      text: "Login with Google",
                                      onPressed: () =>
                                          onGoogleBtnClick(context));
                                default:
                                  return customButton(
                                      context: context,
                                      image: const Image(
                                        image: AssetImage(
                                          google_icon,
                                        ),
                                        height: 30,
                                      ),
                                      backgroundColor: Colors.white,
                                      text: "Login with Google",
                                      onPressed: () =>
                                          onGoogleBtnClick(context));
                              }
                            },
                          ),
                          Platform.isIOS
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(),
                          Platform.isIOS
                              ? StreamBuilder<SignInState>(
                                  stream: _signInWithAppleController.stream,
                                  initialData: SignInState.Success,
                                  builder: (context, snapshot) {
                                    switch (snapshot.data) {
                                      case SignInState.Loading:
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        );
                                      case SignInState.Error:
                                        return Column(
                                          children: [
                                            customButton(
                                                context: context,
                                                image: const Image(
                                                  image: AssetImage(
                                                    apple_icon,
                                                  ),
                                                  height: 30,
                                                ),
                                                backgroundColor: Colors.white,
                                                text: "Login with Apple",
                                                onPressed: () {
                                                  onAppleBtnClick(context);
                                                }),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // Text("${errorMessage}")
                                          ],
                                        );
                                      case SignInState.Success:
                                        return customButton(
                                            context: context,
                                            image: const Image(
                                              image: AssetImage(
                                                apple_icon,
                                              ),
                                              height: 30,
                                            ),
                                            backgroundColor: Colors.white,
                                            text: "Login with Apple",
                                            onPressed: () {
                                              onAppleBtnClick(context);
                                            });
                                      default:
                                        return customButton(
                                            context: context,
                                            image: const Image(
                                              image: AssetImage(
                                                apple_icon,
                                              ),
                                              height: 30,
                                            ),
                                            backgroundColor: Colors.white,
                                            text: "Login with Apple",
                                            onPressed: () {
                                              onAppleBtnClick(context);
                                            });
                                    }
                                  },
                                )
                              : SizedBox(),
                          const SizedBox(
                            height: 120,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 40,
                        right: 1,
                        height: 50,
                        width: 80,
                        child: StreamBuilder<SignInState>(
                          stream: _signInAnonymouslyController.stream,
                          initialData: SignInState.Success,
                          builder: (context, snapshot) {
                            switch (snapshot.data) {
                              case SignInState.Loading:
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                );
                              case SignInState.Error:
                                return guestButton(context);
                              case SignInState.Success:
                                return guestButton(context);
                              default:
                                return guestButton(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
