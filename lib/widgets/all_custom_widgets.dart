import 'package:flutter/material.dart';
import 'package:habit_tracker/constant/colors.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';

Widget iconButtonWithBackground(
    {Color backgroundColor = grey300,
    Color iconColor = Colors.greenAccent,
    double iconSize = 20.0,
    double width = 50,
    double height = 25,
    double borderRadius = 10.0,
    required Widget icon,
    void Function()? onPressed}) {
  return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      width: width,
      height: height,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: iconColor,
        padding: EdgeInsets.all(0),
      ));
}

Widget customSmallButton({
  Color backgroundColor = Colors.greenAccent,
  double borderRadius = 10,
  double width = 50,
  double height = 25,
  Widget? child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    width: width,
    height: height,
    child: child,
  );
}

Widget titleText({
  required String text,
  FontWeight? fontWeight,
  double? fontSize,
  Color? textColor,
}) {
  return Text(text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor,
      ));
}

Widget clipText({
  required String text,
  FontWeight? fontWeight,
  double? fontSize = 12.0,
  Color? textColor,
}) {
  return Text(text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor,
      ));
}

Widget toggleSwitchButton(
    {bool isSwitched = false,
    Function(bool)? onChanged,
    required Color color}) {
  return Switch(
    value: isSwitched,
    onChanged: onChanged,
    activeColor: Colors.white,
    activeTrackColor: color,
    inactiveThumbColor: Colors.grey,
    inactiveTrackColor: grey300,
  );
}

Widget chipsList({
  required List<String> list,
  required void Function(String value) onTap,
  String type = 'value',
  required Color color,
  double spacing = 10.0,
  EdgeInsetsGeometry? labelPadding,
  Color habitTextColor = Colors.black,
}) {
  return Wrap(
    spacing: spacing, // Adjust spacing between chips as needed
    children: list.map((value) {
      return GestureDetector(
        onTap: () {
          onTap(value);
        },
        child: Chip(
          label: clipText(text: value),
          labelPadding: labelPadding ??
              EdgeInsets.only(top: 1, left: 2, right: 2, bottom: 1),
          side: BorderSide(color: Colors.transparent),
          shape:
              // OutlinedBorder(side: BorderSide(color: Colors.red, width: 10.0),),
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //  side: BorderSide(color: Colors.red),
          ),
          backgroundColor: value == type ? color : grey300,
          labelStyle: TextStyle(
            color: value == type ? habitTextColor : Colors.black,
          ),
        ),
      );
    }).toList(),
  );
}

Widget submitButton({
  required void Function() onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
        // width: 150,
        height: 50,
        decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            border: Border(),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Center(
            child: Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ))),
  );
}
