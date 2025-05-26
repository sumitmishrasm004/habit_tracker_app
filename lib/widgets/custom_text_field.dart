import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/constant/colors.dart';


class CustomTextField extends StatelessWidget {
  String? hintText;
  TextInputType keyboardType;
  FormFieldValidator<String?> validator;
  Function(String) onChange;
  TextEditingController? controller;
  Widget? prefixIcon;
  Widget? prefix;
  bool? autovalidateMode;
  String? initialValue;
  Color? color;
  List<TextInputFormatter>? inputFormatters;
  FocusNode? focusNode;
  Function(String value)? onSubmit;
  TextCapitalization textCapitalization;
  TextInputAction? textInputAction;
  bool autofocus;
  int? maxLength;
  Color? fillColor;
  double? borderRadius;
  TextAlign textAlign;
  Color textColor;
  double cursorHeight;
  Color cursorColor;
  Color borderColor;
  Color enabledBorderColor;
  double textFontSize;
  double hintTextFontSize;
  EdgeInsetsGeometry? contentPadding;

  CustomTextField(
      {Key? key, this.hintText,
      required this.keyboardType,
      required this.validator,
      this.controller,
      this.autovalidateMode,
      this.initialValue,
      required this.onChange,
      this.prefixIcon,
        this.prefix,
      this.color,
      this.inputFormatters,
      this.focusNode,
      this.onSubmit,
        this.autofocus = true,
        this.maxLength,
        this.textCapitalization = TextCapitalization.none,
        this.textInputAction = TextInputAction.done,
      this.fillColor = Colors.transparent,
      this.borderRadius = 20.0,
      this.textAlign = TextAlign.center,
      this.textColor = Colors.white,
      this.cursorHeight = 20,
      this.cursorColor = Colors.black,
      this.borderColor = Colors.transparent,
      this.enabledBorderColor = grey200,
      this.textFontSize = 20.0,
      this.hintTextFontSize = 14.0,
      this.contentPadding = const EdgeInsets.only(top: 10, left: 10.0, right: 10.0, bottom: 10),
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
          controller: controller,
          onChanged: (value){
            onChange(value);
          },
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
          onFieldSubmitted: onSubmit,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          validator: validator,
          focusNode: focusNode,
          keyboardType: keyboardType,
      maxLength: maxLength,
          style: TextStyle(
              color: textColor,
              fontSize: textFontSize,
              // fontFamily: AppConstant.overpass,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            isCollapsed: true,
            errorStyle: const TextStyle(color: Colors.red,),
            // suffixIconConstraints:
            //     const BoxConstraints(maxHeight: 20.0, maxWidth: 30.0),
            prefixIcon: prefixIcon,
            prefix: prefix,
            contentPadding:
            contentPadding,
                //  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderSide:  BorderSide(width: 0.5, color: borderColor,),
              borderRadius: BorderRadius.circular(0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0.5, color:  Colors.red,),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:  BorderSide(width: 0.5, color:  Colors.red,),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(width: 1.0, color: enabledBorderColor,),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(width: 1.0, color:  borderColor,),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            hintText: hintText,
            filled: true,
            fillColor:  fillColor,
            focusColor: Colors.white,
            hoverColor: Colors.black,
            hintStyle: TextStyle(
                fontFamily: 'Lato',
                fontSize: hintTextFontSize,
                fontWeight: FontWeight.w400,
                color: textColor),
                 counterText: '',
          ),
           cursorHeight: cursorHeight,
          cursorColor: cursorColor,
        );
  }
}