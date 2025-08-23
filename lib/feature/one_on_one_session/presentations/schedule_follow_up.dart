import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/groupsession/presentations/create_group_session.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/logic/service/auth_service.dart';
import 'package:zanadu_coach/feature/login/logic/service/preference_services.dart';
import 'package:zanadu_coach/feature/session/data/repository/all_session_repository.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/today_schedule_session_cubit/today_schedule_session_cubit.dart';
import 'package:zanadu_coach/feature/session/widgets/custom_switch.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';

class ScheduleFollowUp extends StatefulWidget {
  final String userId;

  const ScheduleFollowUp({super.key, required this.userId});

  @override
  State<ScheduleFollowUp> createState() => _ScheduleFollowUpState();
}

class _ScheduleFollowUpState extends State<ScheduleFollowUp> {
  String? selectedDateText;
  String? selectedTimeText;
  String sessionType = "FOLLOW_UP";
  bool isSaveGoogleEvent = false;
  bool isSaveAppleEvent = false;

  String offeringType = profiles[0]?.name ?? "";
  String offeringId = profiles[0]?.id ?? "";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String formatSelectedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$month-$day-$year';
  }

  String formatSelectedDateYMD(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$year-$month-$day';
  }

  TextEditingController title = TextEditingController();

  TextEditingController description = TextEditingController();

  TextEditingController sl = TextEditingController();
  int slots = 0;

  late TodayScheduleSessionCubit todayScheduleSessionCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todayScheduleSessionCubit =
        BlocProvider.of<TodayScheduleSessionCubit>(context);
  }

  AllSessionRepository allSessionRepository = AllSessionRepository();

  void createEventInGoole(String googleToken, String summary,
      String description, String eventDate, int beforeTime) async {
    await allSessionRepository.createGoogleEventApi(
        googleToken: googleToken,
        summary: summary,
        description: description,
        eventDate: eventDate,
        beforeTime: beforeTime);
  }

  void addEventToCalendar(
      String title, DateTime selectedDate, Duration reminderDuration) {
    final DateTime eventTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final Event event = Event(
      title: title,
      description: description.text.trim(),
      location: 'Event Location', // Add a location if needed
      startDate: eventTime,
      endDate: eventTime.add(const Duration(hours: 1)),
      iosParams: IOSParams(
        reminder: reminderDuration,
      ),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllSessionCubit, AllSessionState>(
        listener: (context, state) async {
          if (state is AllSessionCreatedState) {
            // Show loading indicator
            if (isSaveGoogleEvent == true) {
              String? token = await Preferences.fetchGoogleAccessToken();

              createEventInGoole(
                  token ?? "",
                  title.text.trim(),
                  description.text.trim(),
                  formatDateTime(selectedDate, selectedTime),
                  10);
            }

            if (isSaveAppleEvent == true) {
              addEventToCalendar(
                  title.text.trim(), selectedDate, Duration(minutes: 10));
            }
            Navigator.of(context).pop(); // Close loading dialog
            Navigator.of(context).pop();

            showGreenSnackBar(
              state.message,
            );
          } else if (state is AllSessionLoadingState) {
            // Handle the new session created state
            // For example, close the loading dialog or navigate to another screen

            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            );
          } else if (state is AllSessionErrorState) {
            Navigator.of(context).pop();
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Schedule", secondText: "Session"),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 28.h,
                  horizontal: 28.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    simpleText(
                      "Offering Type",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                    height(8),
                    DynamicPopupMenu(
                      boundaryColor: AppColors.greyLight,
                      selectedValue: offeringType,
                      items:
                          profiles.map((health) => health?.name ?? "").toList(),
                      onSelected: (String value) {
                        setState(() {
                          offeringType = value;
                          Health? selectedOffering = profiles
                              .firstWhere((health) => health?.name == value);

                          offeringId = selectedOffering?.id ?? "";
                        });
                      },
                    ),
                    height(16),
                    simpleText(
                      "Session Type",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                    height(8),
                    DynamicPopupMenu(
                      boundaryColor: AppColors.greyLight,
                      selectedValue: sessionType,
                      items: const [
                        'FOLLOW_UP',
                        'DISCOVERY',
                      ],
                      onSelected: (String value) {
                        setState(() {
                          sessionType = value;
                        });
                      },
                    ),
                    height(16),
                    simpleText(
                      "Title",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                    height(8),
                    NoIconTextFieldWidget(
                      controller: title,
                    ),
                    height(16),
                    simpleText(
                      "Description",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                    height(8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.greyLight,
                          )),
                      child: TextFormField(
                        controller: description,
                        maxLines: 6,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    height(16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.greyLight,
                                )),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 5.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: simpleText(
                                    selectedDateText ?? "Date",
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/icons/calendar(1).svg"),
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        selectedDate = picked;
                                        selectedDateText =
                                            formatSelectedDate(picked);
                                      });
                                      todayScheduleSessionCubit
                                          .createTodayScheduleSession(
                                              date: formatSelectedDateYMD(
                                                  picked));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        width(13),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.greyLight,
                                )),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 5.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: simpleText(
                                    selectedTimeText ?? "Time",
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      SvgPicture.asset("assets/icons/time.svg"),
                                  onPressed: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (picked != null) {
                                      // Check if the selected time is in the past
                                      final DateTime selectedDateTime =
                                          DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        picked.hour,
                                        picked.minute,
                                      );
                                      if (selectedDateTime
                                          .isBefore(DateTime.now())) {
                                        // Show an error or handle the case where the time is in the past
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please select a future time."),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          selectedTime = picked;
                                          selectedTimeText =
                                              picked.format(context);
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(28),
                    CustomSwitchImage(
                        svg: "assets/icons/Google.svg",
                        value: isSaveGoogleEvent,
                        onChanged: (value) async {
                          if (!value) {
                            // If the switch is being turned off, immediately update the state
                            setState(() {
                              isSaveGoogleEvent = value;
                            });
                          } else {
                            // If the switch is being turned on, check for Google access token
                            String? token =
                                await Preferences.fetchGoogleAccessToken();

                            if (token != null) {
                              // If access token exists, update the state
                              setState(() {
                                isSaveGoogleEvent = value;
                              });
                            } else {
                              // If access token does not exist, prompt the user to sign in
                              UserCredential credential =
                                  await AuthServices().signInWithGoogle();
                              await Preferences.saveGoogleAccessToken(
                                  credential.credential?.accessToken ?? "");

                              // After successful sign-in, update the state
                              setState(() {
                                isSaveGoogleEvent = true;
                              });

                              print(credential.credential?.accessToken ?? "");
                            }
                          }
                        },
                        firstText: "Save Event To Google Calendar",
                        secondText: "Do Not Save Event"),
                    if (Platform.isIOS) height(28),
                    if (Platform.isIOS)
                      CustomSwitchImageApple(
                          svg: "assets/icons/Linkedin.svg",
                          value: isSaveAppleEvent,
                          onChanged: (value) {
                            setState(() {
                              isSaveAppleEvent = value;
                            });
                          },
                          firstText: "Save Event To Apple Calendar",
                          secondText: "Do Not Save Event"),
                    if (selectedDateText != null) height(40),
                    if (selectedDateText != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryBlue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            simpleText(
                              "Schedule of $selectedDateText",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            height(20),
                            BlocBuilder<TodayScheduleSessionCubit,
                                TodayScheduleSessionState>(
                              builder: (context, state) {
                                if (state is TodayScheduleSessionLoadingState) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                } else if (state
                                    is TodayScheduleSessionLoadedState) {
                                  // Access the loaded plan from the state
                                  var data = state.todaySchedule.sessions;
                                  if (data!.isEmpty) {
                                    return simpleText(
                                      "No Schedule for this date",
                                      align: TextAlign.center,
                                    );
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GetTodayScheduleCardSmall(
                                              sessionType:
                                                  data[index].sessionType ?? "",
                                              startTime: myformattedTime(
                                                  data[index].startDate ?? ""),
                                              sessionTime:
                                                  "${data[index].endDate} min"),
                                        );
                                      });
                                } else if (state
                                    is TodayScheduleSessionErrorState) {
                                  return Text('Error: ${state.error}');
                                } else {
                                  return const Text('Something is wrong');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    height(64),
                    ColoredButtonWithoutHW(
                      isLoading: false,
                      onpressed: () {
                        if (title.text.trim().isNotEmpty &&
                            description.text.trim().isNotEmpty &&
                            selectedDateText != null &&
                            selectedTimeText != null) {
                          final formattedDateTime =
                              formatDateTime(selectedDate, selectedTime);
                          // Trigger the create session function here
                          BlocProvider.of<AllSessionCubit>(context)
                              .createOneOnOneSession(
                                  offeringId: offeringId,
                                  sessionType: sessionType,
                                  title: title.text,
                                  description: description.text,
                                  coachId: myCoach?.userId ?? "",
                                  startDate: formattedDateTime,
                                  noOfSlots: 1,
                                  userId: widget.userId);
                        } else {
                          showSnackBar("Please fill all details");
                        }
                      },
                      text: "Confirm",
                      size: 16,
                      weight: FontWeight.w600,
                      verticalPadding: 14,
                    ),
                    height(16),
                    GestureDetector(
                      onTap: () {
                        Routes.goBack();
                      },
                      child: const SimpleWhiteTextButtonWOHW(
                        isLoading: false,
                        text: "Cancel",
                        size: 16,
                        weight: FontWeight.w600,
                        verticalPadding: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
