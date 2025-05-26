import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';

class HorizontalCalendarWidget extends StatefulWidget {
  final Function(DateTime currentDate) onDateChange;
  final DateTime currentDate;
  const HorizontalCalendarWidget({Key? key,required this.currentDate, required this.onDateChange}) : super(key: key);

  @override
  State<HorizontalCalendarWidget> createState() => _HorizontalCalendarWidgetState();
}

class _HorizontalCalendarWidgetState extends State<HorizontalCalendarWidget> {
  late DateTime _selectedDate;


  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: widget.currentDate,
      onDateChange: widget.onDateChange,
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
      ),
      dayProps: const EasyDayProps(
        dayStructure: DayStructure.dayStrDayNum,
        height: 90,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
