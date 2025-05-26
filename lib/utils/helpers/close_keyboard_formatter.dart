import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloseKeyboardFormatter extends TextInputFormatter {
   final int textLength;
   const CloseKeyboardFormatter({
    required  this.textLength,
   });
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length == textLength) {
      // Close the keyboard
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    }
    return newValue;
  }
}
