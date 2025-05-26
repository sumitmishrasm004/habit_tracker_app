import 'package:auto_route/auto_route.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/constant/colors.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/presentation/mixin/custom_habit_mixin.dart';
import 'package:habit_tracker/presentation/providers/settings_provider.dart';
import 'package:habit_tracker/presentation/providers/suggestion_provider.dart';
import 'package:habit_tracker/services/notification_service.dart';
import 'package:habit_tracker/utils/constants/app_colors.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:habit_tracker/widgets/all_custom_widgets.dart';
import 'package:habit_tracker/widgets/custom_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CustomHabitScreen extends StatefulHookConsumerWidget {
  final HabitsModel? habitsModel;
  final String screen;
  const CustomHabitScreen(
      {super.key, required this.habitsModel, this.screen = 'home'});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomHabitScreenState();
}

class _CustomHabitScreenState extends ConsumerState<CustomHabitScreen>
    with CustomHabitMixin {
  TextEditingController tagsController = TextEditingController();
  FocusNode tagsFieldFocus = FocusNode();
  bool isSwitched = false;
  Color themeColor = Colors.greenAccent;

  List<String> habitTypeList = ['Build', 'Quit'];
  List<String> goalPeriodList = ['Day'];
  List<String> timeRangeList = [
    'Anytime',
    'Morning',
    'Afternoon',
    'Evening',
  ];
  List<String> tagsList = [];
  List<String> reminderList = [];
  List<List<int>> remindersTime = [];
  List<List<int>> updatedRemindersTime = [];
  List<List<int>> endHabitsRemindersTime = [];
  DateTime startedDate = DateTime.now();
  // DateTime endedDate = DateTime.now().add(const Duration(days: 7));
  DateTime? endedDate;
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController habitNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Color habitTextColor = Colors.black;

  String selectedEmoji = '';
  // String? habitUnit = '';
  List<String> unitsList = [];

  void onEmojiSelected(String emoji) {
    widget.habitsModel?.habitIcon = emoji;
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> showEmojiPicker() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: EmojiPicker(
              onEmojiSelected: (_, emoji) => onEmojiSelected(emoji.emoji),
              onBackspacePressed: () {
                Navigator.pop(context);
              },
              // customWidget: (config, state) {
              //   return TextField(
              //     controller: searchController,
              //     decoration: InputDecoration(
              //       hintText: 'Search Emoji',
              //       prefixIcon: Icon(Icons.search),
              //     ),
              //     onChanged: (value) {
              //       // Handle search logic here
              //       // You can filter the emojis based on the search query
              //     },
              //   );
              // },
              config: const Config(
                columns: 7,
                emojiSizeMax: 32.0,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                initCategory: Category.ACTIVITIES,
                bgColor: Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                // progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                // showRecentsTab: true,
                recentsLimit: 28,
                // noRecentsText: 'No Recents',
                // noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
                categoryIcons: CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          );
        });
  }

  void _openTimePicker(BuildContext context) {
    DateTime currentlyOpenTime = DateTime.now();
    BottomPicker.time(
      pickerTitle: Text(
        "Set Reminders",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      // title: 'Set Remainders',
      initialTime: Time(
          hours: currentlyOpenTime.hour, minutes: currentlyOpenTime.minute),
      titleAlignment: Alignment.center,
      // titleStyle: const TextStyle(
      //   fontWeight: FontWeight.bold,
      //   fontSize: 18,
      //   color: Colors.black,
      // ),
      buttonWidth: MediaQuery.of(context).size.width * 0.8,
      buttonSingleColor: AppColors.primaryBlue,
      onSubmit: (index) {
        String formattedTime = Utils.convertDateTimeToHoursMinutes('$index');
        addTime(formattedTime);
      },
      onClose: () {
        Logger.log(message: 'Picker closed');
        Navigator.pop(context);
      },
      bottomPickerTheme: BottomPickerTheme.blue,
      use24hFormat: true,
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    getTagsList(widget.habitsModel?.tags ?? '');
    getRemindersList(widget.habitsModel?.reminderTime ?? '');
    isSwitched = widget.habitsModel?.showHabitMemo == 1 ? true : false;
    themeColor = Utils.generateRandomColor();
    // themeColor = randomColor;
    setInitialVale();
    if (widget.habitsModel?.habitType == 'Quit') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showQuitDialog();
      });
    }
  }

  setInitialVale() {
    unitsList = widget.habitsModel?.goalUnit.split(",") ?? [];
    String? habitUnit = widget.habitsModel?.goalUnit.split(",")[0];
    widget.habitsModel?.goalUnit = habitUnit ?? '';
    goalController.text = widget.habitsModel?.goal ?? '1';
    habitNameController.text = widget.habitsModel?.habitName ?? 'Custom Habit';
    descriptionController.text =
        widget.habitsModel?.habitDescription ?? "Habit description";
    widget.habitsModel?.habitStartDate = widget.habitsModel?.habitStartDate == 0
        ? Utils.dateForDb(startedDate)
        : widget.habitsModel!.habitStartDate;
    // widget.habitsModel?.habitEndDate = widget.habitsModel?.habitEndDate == 0
    //     ? Utils.dateForDb(endedDate ?? 0)
    //     : widget.habitsModel!.habitEndDate;
    widget.habitsModel?.habitColor = widget.habitsModel?.habitColor != ''
        ? widget.habitsModel?.habitColor
        : themeColor.value.toString();
    themeColor = Color(int.parse(widget.habitsModel!.habitColor!));
    startedDate =
        Utils.convertTimestampToDateTime(widget.habitsModel!.habitStartDate);
    if (widget.habitsModel?.habitEndDate != 0) {
      endedDate =
          Utils.convertTimestampToDateTime(widget.habitsModel!.habitEndDate);
    }
    habitTextColor = Utils.getTextColorForBackground(themeColor);
  }

  getTagsList(String value) {
    if (value.isNotEmpty) {
      tagsList = value.split(',');
    }
  }

  getRemindersList(String value) {
    if (value != '') {
      reminderList = value.split(',');
      if (reminderList.isNotEmpty) {
        for (var element in reminderList) {
          List<int> arr = Utils.splitHoursAndMinutes(element);
          remindersTime.add(arr);
        }
      }
    }
    // Logger.log(message:value);
    Logger.log(message: "allremindferTime ====> $remindersTime");
  }

  void addTime(String newTime) {
    List<int> result = concatenateInnerElements(remindersTime);
    bool flag = result
        .contains(int.parse(Utils.splitHoursAndMinutes(newTime).join('')));

    if (!flag) {
      if (widget.habitsModel!.htId != null) {
        updatedRemindersTime.add(Utils.splitHoursAndMinutes(newTime));
      }
      if (reminderList.contains(newTime)) {
        Logger.log(message: 'Reminder time already present ==> $newTime');
      } else {
        setState(() {
          reminderList.add(newTime);
          widget.habitsModel?.reminderTime = reminderList.join(',');
          remindersTime.add(Utils.splitHoursAndMinutes(newTime));
          Logger.log(message: "remainders times ====> $remindersTime");
        });
      }
    }
  }

  List<int> concatenateInnerElements(List<List<int>> array) {
    List<int> result = [];

    for (List<int> element in array) {
      int value = int.parse(element.join(''));
      result.add(value);
    }

    return result;
  }

  void handleDateChange(List<DateTime?> dates, String type) {
    Logger.log(message: 'Notification Scheduled for ${dates[0]}');
    _singleDatePickerValueWithDefaultValue = dates;
    if (type == 'start') {
      if (endedDate == null ||
          (endedDate != null &&
              endedDate!.isAfter(_singleDatePickerValueWithDefaultValue[0]!))) {
        startedDate = _singleDatePickerValueWithDefaultValue[0]!;
        widget.habitsModel?.habitStartDate = Utils.dateForDb(startedDate);
      } else {
        Utils.showSnackBar(context,
            'Please ensure that the start date precedes the end date.');
      }
    } else {
      if (!startedDate.isAfter(_singleDatePickerValueWithDefaultValue[0]!)) {
        endedDate = _singleDatePickerValueWithDefaultValue[0]!;
        widget.habitsModel?.habitEndDate = Utils.dateForDb(endedDate!);
      } else {
        Utils.showSnackBar(context,
            'Please ensure that the start date precedes the end date.');
        // FocusScope.of(context).unfocus();
      }
    }
    setState(() {});
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  Widget _buildDefaultSingleDatePickerWithValue(BuildContext context,
      {required String type}) {
    final config = CalendarDatePicker2Config(
        selectedDayHighlightColor: AppColors.primaryBlue,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        firstDayOfWeek: 1,
        controlsHeight: 80,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: const TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        disabledDayTextStyle: const TextStyle(
          color: Colors.grey,
          // fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        selectableDayPredicate: (day) {
          DateTime today = DateTime.now();
          DateTime selectedDay = day;
          // print("dates ============> $_singleDatePickerValueWithDefaultValue");
          // if (type == 'start') {
          //   if (endedDate == null) {
          //     return !selectedDay
          //         .isBefore(today.subtract(const Duration(days: 1)));
          //   } else if (endedDate != null &&
          //       endedDate!
          //           .isAfter(_singleDatePickerValueWithDefaultValue[0]!)) {
          //     return !selectedDay
          //         .isBefore(endedDate!.subtract(const Duration(days: 1)));
          //   }
          // } else {
          //   if (endedDate != null &&
          //       endedDate!
          //           .isAfter(startedDate)) {
          //     return !selectedDay
          //         .isAfter(startedDate!.subtract(const Duration(days: 1)));
          //   }
          // }

          return !selectedDay.isBefore(today.subtract(const Duration(days: 1)));
        });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height * 0.4,
        child: CalendarDatePicker2(
          config: config,
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (dates) => handleDateChange(dates, type),
        ),
      ),
    );
  }

  Future<void> _openCalendarPicker(BuildContext context,
      {String type = 'start'}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _buildDefaultSingleDatePickerWithValue(context, type: type),
        );
      },
    );
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
    widget.habitsModel?.showHabitMemo = isSwitched ? 1 : 0;
  }

  void showBottomModalSheet(BuildContext context, List<String> unitsList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            // height: 200,
            padding:
                const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 5),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20,
                    ),
                    titleText(
                        text: 'Select Unit',
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey.shade300,
                        ))
                  ],
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.only(
                      top: 20, left: 5, right: 5, bottom: 5),
                  // color: Colors.yellow,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                        childAspectRatio: 3,
                      ),
                      itemCount: unitsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 20,
                          height: 20,
                          // color: AppColors.primaryBlue,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)
                              //  border: Border.all(width: 2, color: Colors.black),
                              ),
                          // child: customSmallButton(child: Center(child: Text("Build", style: TextStyle(color: Colors.grey,fontSize: 12),)),backgroundColor: AppColors.primaryBlue, width: 10,borderRadius: 20, height: 20)
                          child: GestureDetector(
                              onTap: () {
                                widget.habitsModel?.goalUnit = unitsList[index];
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Center(child: Text(unitsList[index]))),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showQuitDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            '👎 Quit Habit',
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Don't overdo it when trying to build a habit. If you do nothing, consider the habit done.",
            style: TextStyle(color: Colors.white),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            const Divider(
              thickness: 0.2,
              color: Colors.white,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleSubmitButton(bool dailyNotificationStatus) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() &&
        goalController.text.isNotEmpty &&
        habitNameController.text.isNotEmpty &&
        widget.habitsModel != null) {
      widget.habitsModel?.goal = goalController.text;
      widget.habitsModel?.habitName = habitNameController.text;
      widget.habitsModel?.habitDescription = descriptionController.text;
      Logger.log(message: "model value ===> ${widget.habitsModel?.toJson()}");
      saveHabit(widget.habitsModel!);
      if (widget.habitsModel != null)
        scheduleNotification(dailyNotificationStatus, widget.habitsModel!);
      habitNameController.clear();
      descriptionController.clear();
      FocusScope.of(context).unfocus();
      if (widget.screen == 'suggestion') {
        ref
            .read(suggestionProvider.notifier)
            .removeHabit(widget.habitsModel?.goalUnit ?? '');
        Navigator.pop(context, true);
      }
      if (widget.screen == 'home') {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> scheduleNotification(
      bool dailyNotificationStatus, HabitsModel habitsModel) async {
    if (dailyNotificationStatus) {
      List<int> pendingNotificationId = await getPendingNotifications(
          habitsModel,
          'title',
          'Habit Reminder - ${widget.habitsModel!.habitName}');
      await cancelAllPreviousNotifications(pendingNotificationId);
      // }

      /// TODO: enable notification
      if (widget.habitsModel?.habitEndDate == 0) {
        NotificationService().schedulePeriodicNotification(
          DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF,
          'Habit Reminder - ${widget.habitsModel!.habitName}',
          widget.habitsModel?.habitDescription ?? '',
          remindersTime,
          'Periodic Notification',
          'daily',
          24,
        );
      } else {
        NotificationService().scheduleCustomHabitNotifications(
            title: 'Habit Reminder - ${widget.habitsModel!.habitName}',
            body: widget.habitsModel?.habitDescription ?? '',
            remindertime: widget.habitsModel!.htId != null
                ? updatedRemindersTime
                : remindersTime,
            startDate: startedDate,
            endDate: endedDate!);
        // call only if habit has ended date
        handlingNotificationForEndingHabits(widget.habitsModel!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dailyNotificationStatus = ref.watch(dailyNotificationStatusProvider);
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside of the TextField
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvoked: (didPop) {
          //do your logic here:
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0.0,
            title: Text(
              widget.habitsModel?.habitName ?? 'Custom Habit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomSheet: GestureDetector(
            onTap: () => handleSubmitButton(dailyNotificationStatus),
            child: Container(
              // margin: const EdgeInsets.only(
              //   left: 30, right: 30
              // ),
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: themeColor,
              child: Center(
                  child: Text(
                "Complete",
                style: TextStyle(
                    color: habitTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(
                      text: "Name",
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: habitNameController,
                      autofocus: false,
                      // initialValue:
                      //     widget.habitsModel?.habitName ?? 'Custom Habit',
                      textFontSize: 14.0,
                      cursorHeight: 22,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      maxLength: 30,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Please enter a valid habit name";
                        }
                        return null;
                      },
                      onChange: (value) {
                        widget.habitsModel?.habitName = value;
                      },
                      color: Colors.grey,
                      fillColor: Colors.grey.shade300,
                      borderRadius: 10.0,
                      textAlign: TextAlign.start,
                      textColor: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    titleText(
                      text: "Description",
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      // hintText: widget.habitsModel?.habitDescription ??
                      //     "Habit description",
                      autofocus: false,
                      textFontSize: 14.0,
                      cursorHeight: 22,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return null;
                      },
                      color: Colors.grey,
                      fillColor: Colors.grey.shade300,
                      borderRadius: 10.0,
                      textAlign: TextAlign.start,
                      textColor: Colors.black,
                      onChange: (value) {
                        widget.habitsModel?.habitDescription = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Icon'),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            showEmojiPicker();
                            // widget.habitsModel?.habitIcon = 'add';
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: grey300,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 50,
                            height: 25,
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              '${widget.habitsModel?.habitIcon}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //  Container(
                        //   decoration: BoxDecoration(
                        //   color: Colors.grey.shade300,
                        //   borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   width: 50,
                        //   height: 25,
                        //   child: IconButton(onPressed: (){}, icon: Icon(Icons.add,color: themeColor,size: 20,), color: AppColors.primaryBlue,padding: EdgeInsets.all(0),)),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          color: Colors.grey,
                          height: 20,
                          width: 2,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        titleText(
                          text: "Change Color",
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              showColorPicker();
                              // colorPickerDialog();
                            },
                            child: customSmallButton(
                              backgroundColor: themeColor,
                            )),
                        //  Container(
                        //   decoration: BoxDecoration(
                        //   color: themeColor,
                        //   borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   width: 50,
                        //   height: 25,),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    titleText(text: 'Habit Type', fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 8,
                    ),
                    chipsList(
                        spacing: 20.0,
                        list: habitTypeList,
                        color: themeColor,
                        habitTextColor: habitTextColor,
                        type: widget.habitsModel?.habitType ?? 'Build',
                        labelPadding: const EdgeInsets.only(
                            top: 1, left: 10, right: 10, bottom: 1),
                        onTap: (value) {
                          widget.habitsModel?.habitType = value;
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    titleText(text: 'Tag', fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 8,
                    ),
                    chipsList(
                        list: tagsList, onTap: (value) {}, color: themeColor),
                    if (tagsList.isNotEmpty)
                      const SizedBox(
                        width: 10,
                      ),
                    // iconButtonWithBackground(
                    //     onPressed: () {
                    //       addTagsWidget();
                    //     },
                    //     icon: const Icon(
                    //       Icons.add,
                    //       color: Colors.grey,
                    //       size: 20,
                    //     ),
                    //     borderRadius: 10),
                    GestureDetector(
                      onTap: () => addTagsWidget(),
                      child: Chip(
                        labelPadding: const EdgeInsets.only(
                            top: 0, left: 14, right: 14, bottom: 0),
                        label: const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        backgroundColor: grey300,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    titleText(
                        text: 'Goal & Goal Period',
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: goalController,
                            // initialValue: widget.habitsModel?.goal ?? '1',
                            autofocus: false,
                            textFontSize: 14.0,
                            cursorHeight: 22,
                            maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == '0') {
                                return "Goal can't be zero";
                              } else if (value == '') {
                                return "Goal can't be empty";
                              }
                              return null;
                            },
                            onChange: (value) {
                              // widget.habitsModel?.goal = value;
                            },
                            color: Colors.grey,
                            fillColor: Colors.grey.shade300,
                            borderRadius: 10.0,
                            textAlign: TextAlign.center,
                            textColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        GestureDetector(
                            onTap: () {
                              // List<String> unitsList =
                              //     widget.habitsModel?.goalUnit.split(",") ?? [];

                              if (unitsList.length > 1 &&
                                  widget.habitsModel?.valueType == 'progress') {
                                showBottomModalSheet(context, unitsList);
                              }
                            },
                            child:
                                //                  Container(
                                //    width: 80.0,
                                // height: 45.0,
                                //   child: Chip(
                                //     label: Text(widget.habitsModel?.goalUnit ?? 'Count',),
                                //      shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //         // side: BorderSide(color: Colors.grey),
                                //       ),
                                //     backgroundColor: grey300,
                                //     labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                                //   ),
                                // ),
                                customSmallButton(
                              child: Center(
                                  child: Text(
                                widget.habitsModel?.goalUnit.split(",").first ??
                                    'Count',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              )),
                              backgroundColor: Colors.grey.shade300,
                              width: 60,
                              height: 40,
                            )),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text(
                          '/',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 3,
                        ),

                        // customSmallButton(
                        //   child: Center(
                        //       child: Text(
                        //     "Day",
                        //     style: TextStyle(color: Colors.white, fontSize: 12),
                        //   )),
                        //   backgroundColor: themeColor,
                        //   width: 50,
                        //   borderRadius: 20,
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Chip(label: Text(
                        //     "Week",
                        //     style: TextStyle(color: Colors.grey, fontSize: 12),
                        //   )),

                        //    SizedBox(
                        //   width: 10,
                        // ),
                        // customSmallButton(
                        //   child: Center(
                        //       child: Text(
                        //     "Week",
                        //     style: TextStyle(color: Colors.grey, fontSize: 12),
                        //   )),
                        //   backgroundColor: Colors.grey.shade300,
                        //   width: 60,
                        //   borderRadius: 20,
                        // ),

                        // SizedBox(
                        //   width: 10,
                        // ),
                        // customSmallButton(
                        //   child: Center(
                        //       child: Text(
                        //     "Month",
                        //     style: TextStyle(color: Colors.grey, fontSize: 12),
                        //   )),
                        //   backgroundColor: Colors.grey.shade300,
                        //   width: 60,
                        //   borderRadius: 20,
                        // ),
                        chipsList(
                            list: goalPeriodList,
                            color: themeColor,
                            type: widget.habitsModel?.goalPeriod ?? 'Day',
                            habitTextColor: habitTextColor,
                            spacing: 5.0,
                            labelPadding: const EdgeInsets.only(
                                top: 1, left: 2, right: 2, bottom: 1),
                            onTap: (value) {
                              widget.habitsModel?.goalPeriod = value;
                              setState(() {});
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   // color: Colors.black,
                    //   height: 35,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       titleText(text: 'Frequency', fontWeight: FontWeight.bold),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           widget.habitsModel?.everydayFrequency ?? 'Daily',
                    //           style: const TextStyle(color: Colors.black),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // //  SizedBox(height: 10,),
                    // const Text(
                    //   "Complete 1 count each day",
                    //   style: TextStyle(color: Colors.red, fontSize: 12),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // titleText(text: 'Time Range', fontWeight: FontWeight.bold),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // chipsList(
                    //     list: timeRangeList,
                    //     color: themeColor,
                    //     spacing: 10.0,
                    //     type: widget.habitsModel?.habitTimeRange ?? 'Anytime',
                    //     onTap: (value) {
                    //       widget.habitsModel?.habitTimeRange = value;
                    //       setState(() {});
                    //     }),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    titleText(text: 'Reminders', fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 8,
                    ),
                    chipsList(
                        list: reminderList,
                        color: themeColor,
                        spacing: 8.0,
                        labelPadding: const EdgeInsets.only(
                            top: 1, left: 8, right: 8, bottom: 1),
                        onTap: (value) {}),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () => _openTimePicker(context),
                      child: Chip(
                        labelPadding: const EdgeInsets.only(
                            top: 0, left: 14, right: 14, bottom: 0),
                        label: const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        backgroundColor: grey300,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     titleText(
                    //         text: 'Show memo after Check-in',
                    //         fontWeight: FontWeight.bold),
                    //     customSmallButton(
                    //       child: Center(
                    //           child: toggleSwitchButton(
                    //               color: themeColor,
                    //               isSwitched: isSwitched,
                    //               onChanged: (isSwitched) =>
                    //                   toggleSwitch(isSwitched))),
                    //       backgroundColor: Colors.white,
                    //       width: 70,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   // color: Colors.black,
                    //   height: 35,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       titleText(text: 'HabitBar Gesture', fontWeight: FontWeight.bold),
                    //       TextButton(
                    //         onPressed: () {
                    //           // widget.habitsModel?.habitGesture = 'Mark as done';
                    //         },
                    //         child: Text(
                    //           widget.habitsModel?.habitGesture ?? 'Mark as done',
                    //           style: const TextStyle(color: Colors.grey),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     titleText(text: 'Chart Type', fontWeight: FontWeight.bold),
                    //     iconButtonWithBackground(
                    //         onPressed: () {
                    //           widget.habitsModel?.chartType = 'graphic_eq';
                    //         },
                    //         icon: const Icon(
                    //           Icons.graphic_eq,
                    //           color: Colors.white,
                    //           size: 25,
                    //         ),
                    //         borderRadius: 20,
                    //         width: 70,
                    //         backgroundColor: themeColor),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    titleText(text: 'Habit Term', fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          'End',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customSmallButton(
                          child: Center(
                              child: GestureDetector(
                                  onTap: () => _openCalendarPicker(context),
                                  child: Text(
                                    Utils.formatDate(dateTime: startedDate),
                                    style: TextStyle(
                                        color: habitTextColor, fontSize: 12),
                                  ))),
                          backgroundColor: themeColor,
                          width: 100,
                          height: 30,
                        ),
                        Expanded(
                          child: Container(
                            // width: 110,
                            height: 2,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        customSmallButton(
                          child: Center(
                              child: GestureDetector(
                                  onTap: () =>
                                      _openCalendarPicker(context, type: 'end'),
                                  child: Text(
                                    widget.habitsModel?.habitEndDate == 0
                                        ? "No End Date"
                                        : Utils.formatDate(
                                            dateTime: endedDate!),
                                    style: TextStyle(
                                        color: habitTextColor, fontSize: 12),
                                  ))),
                          backgroundColor: themeColor,
                          width: 100,
                          height: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  addTagsWidget() {
    Future.delayed(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(FocusNode());
      // FocusScope.of(context).requestFocus(tagsFieldFocus);
    });
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 10),
                child: Text(
                  "Add Tag",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  focusNode: tagsFieldFocus,
                  controller: tagsController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Enter tags",
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              TextButton(
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
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (tagsController.text.isNotEmpty) {
                    tagsList.add(tagsController.text);
                    widget.habitsModel?.tags = tagsList.join(",");
                    setState(() {});
                  }
                  // int addValue = progressValue +
                  //     int.parse(tagsController.text);
                  // ref
                  //     .read(progressValueProvider
                  //     .notifier)
                  //     .updateProgressValue(addValue);
                  // saveHabitValue(addValue);
                  tagsController.clear();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }

  void showColorPicker() {
    List<Color> colorsArr = habitColorsArray;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              title: null,
              content: SizedBox(
                  height: 300,
                  width: 300,
                  child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(colorsArr.length, (int index) {
                        return SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                colorPickerDialog();
                              } else {
                                setState(() {
                                  themeColor = colorsArr[index];
                                  habitTextColor =
                                      Utils.getTextColorForBackground(
                                          themeColor);
                                  widget.habitsModel?.habitColor =
                                      widget.habitsModel?.habitColor =
                                          themeColor.value.toString();
                                });
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              }
                            },
                            child: index == 0
                                ? Image.asset(
                                    'assets/icons/color-wheel.png',
                                    fit: BoxFit.contain,
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    color: colorsArr[index],
                                    child: const SizedBox(
                                      child: null,
                                    ),
                                  ),
                          ),
                        );
                      }))));
        });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: themeColor,
      onColorChanged: (Color color) => setState(() {
        themeColor = color;
        widget.habitsModel?.habitColor =
            widget.habitsModel?.habitColor = themeColor.value.toString();
      }),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 180,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: false,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      actionButtons: const ColorPickerActionButtons(
        dialogActionButtons: false,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      backgroundColor: Colors.white,
      elevation: 0,
      constraints:
          const BoxConstraints(minHeight: 400, minWidth: 300, maxWidth: 320),
    );
  }

  /// Add model variables in onchange of form
  // Future<void> saveHabit(HabitsModel model) async {
  //   try {
  //     model.saveStatus = SaveStatusEnum.pending.name;
  //     HtDatabaseImpl databaseImpl = HtDatabaseImpl();
  //     await databaseImpl.insert(
  //         tableName: HtDatabaseImpl.habitTableName, data: model.toJson());
  //   } catch (e) {
  //     Logger.log(message: e.toString());
  //   }
  // }
}
