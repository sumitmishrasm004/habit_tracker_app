import 'package:habit_tracker/domain/models/login_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginModel>(LoginNotifier.new);

class LoginNotifier extends Notifier<LoginModel>{

@override
 LoginModel build() => LoginModel(
  isSubmitBtnClicked: false,
  submitButtonLoading : false,
  sendOtpLoading : false,
  resendOtpLoading : false,
  googleLoading : false,
  verificationId: '',
  errorMessage: '',
  resendToken: 0,
 );

  // Create a common function to update the properties
  void updateProperties({
    bool? newIsSubmitBtnClicked,
    bool? newIsSubmitButtonLoading,
    bool? newIsSendOtpLoading,
    bool? newIsResendOtpLoading,
    bool? newIsGoogleLoading,
    String? newVerificationId,
    String? errorMessage,
    int? newResendToken,
  }) {
    final currentIsSubmitBtnClicked = newIsSubmitBtnClicked ?? state.isSubmitBtnClicked;
    final currentIssubmitButtonLoading = newIsSubmitButtonLoading ?? state.submitButtonLoading;
    final currentIsSendOtpLoading = newIsSendOtpLoading ?? state.sendOtpLoading;
    final currentIsResendOtpLoading = newIsResendOtpLoading ?? state.resendOtpLoading;
    final currentIsGoogleLoading = newIsGoogleLoading ?? state.googleLoading;
    final currentVerificationId = newVerificationId ?? state.verificationId;
    final currentErrorMessage = errorMessage ?? state.errorMessage;
    final currentResendToken = newResendToken ?? state.resendToken;
   state = LoginModel(
      isSubmitBtnClicked: currentIsSubmitBtnClicked,
      submitButtonLoading: currentIssubmitButtonLoading,
      sendOtpLoading: currentIsSendOtpLoading,
      resendOtpLoading: currentIsResendOtpLoading,
      googleLoading: currentIsGoogleLoading,
      verificationId: currentVerificationId,
      errorMessage: currentErrorMessage,
      resendToken: currentResendToken,
    );
  }
}



// final submitBtnProvider = NotifierProvider<SubmitBtnNotifier , bool>(SubmitBtnNotifier.new);

// class SubmitBtnNotifier extends Notifier<bool> {
//  @override
//   bool build() => false;

//   void updateValue(bool value) => (state = value);
// }

// final submitBtnLoaderProvider = NotifierProvider<SubmitBtnLoaderNotifier , bool>(SubmitBtnLoaderNotifier.new);


// class SubmitBtnLoaderNotifier extends Notifier<bool> {
// @override
//   bool build() => false;

//   void updateValue(bool value) => (state = value);
// }

// final otpLoaderProvider = NotifierProvider<OtpSubmitBtnNotifier , bool>(OtpSubmitBtnNotifier.new);

// class OtpSubmitBtnNotifier extends Notifier<bool> {
// @override
//   bool build() => false;

//   void updateValue(bool value) => (state = value);
// }

// final resendOtpLoaderProvider = NotifierProvider<OtpSubmitBtnNotifier , bool>(OtpSubmitBtnNotifier.new);

// class ResendOtpLoaderNotifier extends Notifier<bool> {
// @override
//   bool build() => false;

//   void updateValue(bool value) => (state = value);
// }