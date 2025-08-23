import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/logic/provider/home_bottom_provider.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/widgets/custom_switch.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String? selectedDateText;
  String? selectedEndDateText;
  bool isSwitched = true;
  bool isAvailable = true;
  String reminderType = "DAILY"; // Default to DAILY
  List<bool> weekdaysSelected = List.generate(7, (index) => false);

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  List<Map<String, TimeOfDay?>> timeSlots = [
    {
      'start': null,
      'end': null,
    }
  ];

  int convertWeekdayToNumber(bool selected, int index) {
    return selected ? index : -1; // Use -1 for unselected weekdays
  }

  String formatSelectedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$year-$month-$day';
  }

  DateTime sendingFormatSelectedTime(TimeOfDay time) {
    return DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        time.hour, time.minute);
  }

  String formatSelectedTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tabIndexProvider = Provider.of<TabIndexProvider>(context);
    final calendarCubit = BlocProvider.of<CalendarCubit>(context, listen: true);
    return BlocListener<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state is CalendarUpadatedLoadedState) {
            showGreenSnackBar(state.msg);
            Routes.closeAllAndGoTo(Screens.homeBottomBar);
            tabIndexProvider.setInitialTabIndex(2);
          }

          if (state is CalendarErrorState) {
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
            firstText: "Mark",
            secondText: "Availability",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.w,
                  vertical: 28.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          body1Text(
                            selectedDateText ?? "Start Date",
                            color: Colors.black,
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                                "assets/icons/calendar(1).svg"),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  selectedDateText = formatSelectedDate(picked);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    height(28),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          body1Text(
                            selectedEndDateText ?? "End Date",
                            color: Colors.black,
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                                "assets/icons/calendar(1).svg"),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(
                                  () {
                                    selectedDate = picked;
                                    selectedEndDateText =
                                        formatSelectedDate(picked);
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    height(28),
                    CustomSwitch(
                      firstText: "Available",
                      secondText: "Unavailable",
                      value: isAvailable,
                      onChanged: (value) {
                        // setState(() {
                        //   isAvailable = value;
                        // });
                      },
                    ),
                    height(30),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: "DAILY",
                              groupValue: reminderType,
                              onChanged: (value) {
                                setState(() {
                                  reminderType = value as String;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            simpleText("Daily", fontSize: 18),
                          ],
                        ),
                        width(40),
                        Row(
                          children: [
                            Radio(
                              value: "WEEKLY",
                              groupValue: reminderType,
                              onChanged: (value) {
                                setState(() {
                                  reminderType = value as String;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            simpleText("Weekly", fontSize: 18),
                          ],
                        ),
                      ],
                    ),
                    if (reminderType == "WEEKLY") ...[
                      const SizedBox(height: 16),
                      simpleText(
                        "Select weekdays:",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          7,
                          (index) {
                            final weekdayName = [
                              'Sunday',
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday'
                            ][index];

                            return Row(
                              children: [
                                Checkbox(
                                  value: weekdaysSelected[index],
                                  onChanged: (value) {
                                    setState(() {
                                      weekdaysSelected[index] = value!;
                                    });
                                  },
                                ),
                                simpleText(
                                  weekdayName,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        simpleText(
                          "Select Time Slot",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              timeSlots.add({
                                'start': null,
                                'end': null,
                              });
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (int i = 0; i < timeSlots.length; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 16.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: body1Text(
                                        timeSlots[i]['start'] != null
                                            ? timeSlots[i]['start']!
                                                .format(context)
                                            : "Start Time",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/icons/clock.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    onPressed: () async {
                                      final TimeOfDay? picked =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: timeSlots[i]['start'] ??
                                            TimeOfDay.now(),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          timeSlots[i]['start'] = picked;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 16.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: body1Text(
                                      timeSlots[i]['end'] != null
                                          ? "${timeSlots[i]['end']!.format(context)}"
                                          : "End Time",
                                      color: Colors.black,
                                    ),
                                  )),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/icons/clock.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    onPressed: () async {
                                      final TimeOfDay? picked =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: timeSlots[i]['end'] ??
                                            TimeOfDay.now(),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          timeSlots[i]['end'] = picked;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                timeSlots.removeAt(i);
                              });
                            },
                          ),
                        ],
                      ),
                      height(16),
                    ],
                    height(64),
                    ColoredButtonWithoutHW(
                      onpressed: () async {
                        if (selectedDateText == null ||
                            (reminderType == "DAILY" &&
                                selectedEndDateText == null) ||
                            timeSlots.any((slot) =>
                                slot['start'] == null || slot['end'] == null)) {
                          showSnackBar(
                              "Please fill in all the required fields");
                        } else {
                          bool isValid = true;

                          // Check time difference for each time slot
                          for (int i = 0; i < timeSlots.length; i++) {
                            if (timeSlots[i]['start'] != null &&
                                timeSlots[i]['end'] != null) {
                              DateTime startDateTime =
                                  sendingFormatSelectedTime(
                                      timeSlots[i]['start']!);
                              DateTime endDateTime = sendingFormatSelectedTime(
                                  timeSlots[i]['end']!);

                              // Check if the difference is less than 30 minutes
                              if (endDateTime
                                      .difference(startDateTime)
                                      .inMinutes <
                                  30) {
                                isValid = false;
                                break;
                              }
                            }
                          }

                          if (isValid) {
                            await context
                                .read<CalendarCubit>()
                                .createCalendarDates(
                                  type: reminderType,
                                  days: reminderType == "WEEKLY"
                                      ? List.generate(
                                              7,
                                              (index) => convertWeekdayToNumber(
                                                  weekdaysSelected[index],
                                                  index))
                                          .where((day) => day >= 0)
                                          .toList()
                                      : null,
                                  startDate: selectedDateText ?? "",
                                  endDate: (reminderType == "DAILY"
                                          ? selectedEndDateText
                                          : selectedDateText) ??
                                      "",
                                  timeSlots: timeSlots.map((slot) {
                                    DateTime startTimeUtc =
                                        sendingFormatSelectedTime(
                                                slot['start']!)
                                            .toUtc();
                                    DateTime endTimeUtc =
                                        sendingFormatSelectedTime(slot['end']!)
                                            .toUtc();

                                    return {
                                      "startTime":
                                          startTimeUtc.toIso8601String(),
                                      "endTime": endTimeUtc.toIso8601String(),
                                      "isAvailable":
                                          true, // Modify this based on your logic
                                    };
                                  }).toList(),
                                );
                          } else {
                            showSnackBar(
                                "Time difference should be more than 30 minutes");
                          }
                        }
                      },
                      text: "Done",
                      size: 16,
                      weight: FontWeight.w600,
                      verticalPadding: 12,
                      isLoading: calendarCubit.state is CalendarLoadingState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
