import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

class CustomProgressCounter extends StatefulWidget {
  final double size;
  final int totalValue;
  final int completedValue;
  final String valueType;
  final ValueChanged<int>? onIncrement;
  final ValueChanged<int>? onDecrement;
  final String unit;

  const CustomProgressCounter({
    super.key,
    required this.size,
    required this.totalValue,
    required this.completedValue,
    required this.valueType,
    this.onIncrement,
    this.onDecrement,
    this.unit = '',
  });

  @override
  _CustomProgressCounterState createState() => _CustomProgressCounterState();
}

class _CustomProgressCounterState extends State<CustomProgressCounter> {
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
                strokeWidth: 4.0,
                value: widget.completedValue / widget.totalValue,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: widget.valueType == 'progress'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.onDecrement != null &&
                                widget.completedValue > 0) {
                              widget.onDecrement!(widget.completedValue - 1);
                            }
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.grey,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.completedValue} ${widget.unit}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '/${widget.totalValue}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.onIncrement != null &&
                                widget.completedValue < widget.totalValue) {
                              widget.onIncrement!(widget.completedValue + 1);
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Utils.formatTimer(widget.completedValue)} ${widget.unit}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '/${Utils.formatTimer(widget.totalValue)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
