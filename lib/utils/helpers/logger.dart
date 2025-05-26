import 'package:flutter/foundation.dart';

class Logger {
  static log({required String message}) {
    if(kDebugMode){
      print(message);
    }
  }
}