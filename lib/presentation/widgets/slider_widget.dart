import 'package:bottom_picker/resources/extensions.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/utils/resources/utils.dart';

class SliderWidget extends StatefulWidget {
  final String habitName;
  final int habitCurrentValue;
  final int habitMaxValue;
  final String habitUnit;
  final String habitIcon;
  final Color habitColor;
  final GestureTapCallback? onTap;

  const SliderWidget(
      {Key? key,
      required this.habitName,
      required this.habitCurrentValue,
      required this.habitMaxValue,
      required this.habitUnit,
      required this.habitColor,
      required this.habitIcon,
      this.onTap})
      : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return linearProgressIndicator();
  }

  Widget linearProgressIndicator() {
    Color habitTextColor = Utils.getTextColorForBackground(widget.habitColor);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: (widget.habitCurrentValue / widget.habitMaxValue),
                minHeight: 70,
                backgroundColor: widget.habitColor.withOpacity(0.3),
                color: widget.habitColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // flex: 3,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          // Wrap Text widget with Flexible
                          child: Text(
                            widget.habitIcon,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          // Wrap Text widget with Flexible
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 70,
                            child: Text(
                              widget.habitName,
                              style:  TextStyle(
                                  color: habitTextColor, fontSize: 14),
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 70,
                    child: Text(
                      "${widget.habitCurrentValue}/${widget.habitMaxValue} ${widget.habitUnit}",
                      style:  TextStyle(color: habitTextColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget fillingSlider() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
      child: RotatedBox(
        quarterTurns: 2,
        child: FillingSlider(
            initialValue: 0.6,
            width: 150,
            height: 60,
            color: widget.habitColor.withOpacity(0.3),
            fillColor: widget.habitColor,
            direction: FillingSliderDirection.horizontal,
            childBuilder: (ctx, value) => AnimatedSwitcher(
                  layoutBuilder:
                      (Widget? currentChild, List<Widget> previousChildren) {
                    return currentChild!;
                  },
                  duration: const Duration(milliseconds: 100),
                  child: RotatedBox(
                      quarterTurns: 2,
                      child: Text(
                        widget.habitName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      )),
                )),
      ),
    );
  }

  Widget getIcon(double newVal) {
    return newVal > 0.5
        ? const Icon(Icons.brightness_2_outlined, size: 20, key: ValueKey(1))
        : const Icon(Icons.brightness_1_outlined, size: 20, key: ValueKey(2));
  }
}
