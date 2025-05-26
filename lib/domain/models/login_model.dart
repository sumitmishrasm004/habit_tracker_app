
class LoginModel {
  final bool isSubmitBtnClicked;
  final bool submitButtonLoading;
  final bool sendOtpLoading;
  final bool resendOtpLoading;
  final bool googleLoading;
  final String? verificationId;
  final String? errorMessage;
  final int? resendToken;

  LoginModel({
    this.isSubmitBtnClicked = false,
    this.submitButtonLoading = false,
    this.sendOtpLoading = false,
    this.resendOtpLoading = false,
    this.googleLoading = false,
    this.verificationId,
    this.errorMessage,
    this.resendToken,
  });

}


// class LoadingModel{
//   final bool? submitButtonLoading;
//   final bool? sendOtpLoading;
//   final bool? resendOtpLoading;
//   final bool? googleLoading;

//   LoadingModel({
//     this.submitButtonLoading,
//     this.sendOtpLoading,
//     this.resendOtpLoading,
//     this.googleLoading,
//   });
// }