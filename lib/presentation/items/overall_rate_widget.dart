


import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';


class OervallRateWidget extends StatefulWidget {
  final double size;
  final int percentage;


  const OervallRateWidget({
    required this.size,
    required this.percentage,
  });

  @override
  _OervallRateWidgetState createState() => _OervallRateWidgetState();
}

class _OervallRateWidgetState extends State<OervallRateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 12.0,
                value: widget.percentage / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                backgroundColor: AppColors.primaryBlue.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.percentage}%',
                    style:const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Overall Rate',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
