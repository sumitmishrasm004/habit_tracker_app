import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const CustomButton({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
            height: 50,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
            ),
             child: const Center(child: Text("Login")),)
    ,
    );
  }
}
