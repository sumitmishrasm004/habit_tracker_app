import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/domain/repositories/api_repository.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';

class AuthenticationRepository extends BaseRepository {
  // Google Authentication
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        Logger.log(
            message: 'Error: Both accessToken and idToken are required.');
        throw Exception('Error: Both accessToken and idToken are required.');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      final response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Logger.log(message: "Response =====> $response");
      return response;
    } on FirebaseAuthException catch (error) {
      Logger.log(message: "Error in sign in with google ${error.code}");
      throw error.code;
    } catch (error) {
      Logger.log(message: "Error in sign in with google ${error}");
      throw error.toString();
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      // Log before attempting to sign in
      Logger.log(message: "Attempting to sign in with Apple ID.");

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      // Log successful sign-in
      Logger.log(
          message: "Apple sign-in successful. UserCredential: $userCredential");

      return userCredential;
    } on FirebaseAuthException catch (error) {
      // Log FirebaseAuth specific error
      Logger.log(
          message:
              "FirebaseAuthException: Error in sign in with Apple ID - ${error.message}");
      throw Exception("FirebaseAuthException: ${error.message}");
    } on PlatformException catch (error) {
      // Log Platform specific error
      Logger.log(
          message:
              "PlatformException: Error in sign in with Apple ID - ${error.message}");
      throw Exception("PlatformException: ${error.message}");
    } catch (error) {
      // Log unexpected errors
      Logger.log(
          message:
              "Unexpected Error: Error in sign in with Apple ID - ${error.toString()}");
      throw Exception("Unexpected Error: ${error.toString()}");
    }
  }

  Future signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      Logger.log(message: 'userCredential ==> ${userCredential}');
      return userCredential;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "operation-not-allowed":
          Logger.log(
              message: "Anonymous auth hasn't been enabled for this project.");
          throw error.code;
        default:
          Logger.log(
              message:
                  "Unknown error. code - ${error.code} , message - ${error.message}");
          throw error.code;
      }
    } catch (error) {
      Logger.log(message: "Error occured : ${error}");
      throw error.toString();
    }
  }

// Future<String> sendOtp(String phoneNumber) async {
//     String value = '';
//     final auth = FirebaseAuth.instance;
//    print("top ====>");
//    try {
//      await auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//           // '+${selectedCountry.value.phoneCode}${mobileController.value.text}',
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // status.value = Status.COMPLETED;
//         Logger.log(message: "firebase success value ===> $credential");
//          Logger.log(message: "code verificationCompleted value===> ${value}");
//         // mobileErrorText.value = '';
//         //   isMobileErrorTextVisible.value = false;
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         // status.value = Status.ERROR;
//         // Utils.toastMessage(e.toString());
//         Logger.log(message: "error messgae 153===> ${e.message}");
//         Logger.log(message: "error code 153===> ${e.code}");
//         Logger.log(message: "code verificationFailed value===> ${value}");
//         // if (e.code == AppConstant.invalidPhoneNumber) {
//         //   Utils.printLog(message: 'The provided phone number is not valid.');
//         //   mobileErrorText.value = "The provided phone number is not valid";
//         //   isMobileErrorTextVisible.value = true;
//         // } else if (e.code == AppConstant.quotaExceeded) {
//         //   updateCurrentPage(AppConstant.skipOtpScreen);
//         // }
//         // if(e.code == AppConstant.tooManyRequests) {
//         //   updateCurrentPage(AppConstant.skipOtpScreen);
//         // }
//       },
//       timeout: const Duration(seconds: 30),
//       codeSent: (String verificationID, int? token) {
//         // status.value = Status.COMPLETED;
//         value = verificationID;
//         Logger.log(message: "code sent===> ${value}");
//         Logger.log(message: "code value===> ${value}");
//         Logger.log(message: "code verificationID===> ${verificationID}");

//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // status.value = Status.COMPLETED;
//         Logger.log(message: "code codeAutoRetrievalTimeout value===> ${value}");
//       },
//       // forceResendingToken: resendToken?.value,
//     );
//     // status.value = Status.COMPLETED;

//    } catch (e) {
//      Logger.log(message: "Error in sending Otp, $e");
//    }
//      Logger.log(message: "value in last ===> ${value}");
//      print("bottom ====>");
//     return value;
//   }

// Future<String> sendOtp({required String phoneNumber}) async {
//   final auth = FirebaseAuth.instance;
//   final completer = Completer<String>();

//   try {
//     await auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Handle verification completion
//         completer.complete(credential.smsCode ?? '');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         // Handle verification failure
//         completer.completeError(e);
//       },
//       codeSent: (String verificationID, int? token) {
//         // Handle code sent
//         completer.complete(verificationID);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Handle auto retrieval timeout
//         // You can decide how to handle this case
//         completer.completeError('Auto retrieval timeout');
//       },
//       timeout: const Duration(seconds: 30),
//     );
//   } catch (e) {
//     completer.completeError(e);
//   }

//   return completer.future;
// }

// Future<Map<String, dynamic>> sendOtp({required String phoneNumber}) async {
//   final auth = FirebaseAuth.instance;
//   final completer = Completer<Map<String, dynamic>>();

//   try {
//     await auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Handle verification completion
//         final smsCode = credential.smsCode ?? '';
//         completer.complete({'verificationId': '', 'smsCode': smsCode});
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         // Handle verification failure
//         completer.completeError(e);
//       },
//       codeSent: (String verificationID, int? token) {
//         // Handle code sent
//         completer.complete({'verificationId': verificationID, 'smsCode': ''});
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Handle auto retrieval timeout
//         // You can decide how to handle this case
//         completer.completeError('Auto retrieval timeout');
//       },
//       timeout: const Duration(seconds: 30),
//     );
//   } catch (e) {
//     completer.completeError(e);
//   }

//   return completer.future;
// }

  Future<Map<String, dynamic>> sendOtp({required String phoneNumber}) async {
    final auth = FirebaseAuth.instance;
    final completer = Completer<Map<String, dynamic>>();

    try {
      String? verificationID;
      int? forceResendingToken;

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Handle verification completion
          final smsCode = credential.smsCode ?? '';
          // completer.complete({
          //   'verificationId': verificationID ?? '',
          //   'forceResendingToken': forceResendingToken?.toString() ?? '',
          //   'smsCode': smsCode,
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          Logger.log(message: "error messgae 153===> ${e.message}");
          Logger.log(message: "error code 153===> ${e.code}");
          if (e.code == invalidPhoneNumber) {
            Logger.log(message: 'The provided phone number is not valid.');
            completer.completeError('The provided phone number is not valid.');
            // mobileErrorText.value = "The provided phone number is not valid";
            // isMobileErrorTextVisible.value = true;
          } else if (e.code == quotaExceeded) {
            completer.completeError(e.code);
            // updateCurrentPage(AppConstant.skipOtpScreen);
          }
          if (e.code == tooManyRequests) {
            completer.completeError(e.code);
            // updateCurrentPage(AppConstant.skipOtpScreen);
          }
          completer.completeError("Custom Error");
        },
        codeSent: (String verificationID, int? token) {
          // Handle code sent
          verificationID = verificationID;
          forceResendingToken = token;
          completer.complete({
            'verificationId': verificationID ?? '',
            'forceResendingToken': token?.toString() ?? '',
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto retrieval timeout
          // You can decide how to handle this case
          completer.completeError('Auto retrieval timeout');
        },
        timeout: const Duration(seconds: 30),
      );
    } catch (e) {
      Logger.log(message: "error in repo  ====> ${e} ");
      completer.completeError("Custom Error");
    }
    Logger.log(message: "complete value sendOtp ===> ${completer.future}");
    return completer.future;
  }

  Future<Map<String, String>> resendOtp({
    required String phoneNumber,
    required String verificationId,
    int? forceResendingToken,
  }) async {
    final auth = FirebaseAuth.instance;
    final completer = Completer<Map<String, String>>();

    try {
      String? newVerificationID;
      int? newForceResendingToken;

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Handle verification completion
          final smsCode = credential.smsCode ?? '';
          // completer.complete({
          //   'verificationId': newVerificationID ?? '',
          //   'forceResendingToken': newForceResendingToken?.toString() ?? '',
          //   'smsCode': smsCode,
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          completer.completeError(e);
        },
        codeSent: (String verificationID, int? token) {
          // Handle code sent
          newVerificationID = verificationID;
          newForceResendingToken = token;
          completer.complete({
            'verificationId': verificationID ?? '',
            'forceResendingToken': token?.toString() ?? '',
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 30),
        forceResendingToken: forceResendingToken,
      );
    } catch (e) {
      completer.completeError(e);
    }
    Logger.log(message: "complete value resendOtp ===> ${completer.future}");
    return completer.future;
  }
}
