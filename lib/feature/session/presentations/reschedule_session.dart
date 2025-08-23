import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/groupsession/presentations/create_group_session.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/today_schedule_session_cubit/today_schedule_session_cubit.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/show_and_remove_circular_indicator.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';

class RescheduleSessionScreen extends StatefulWidget {
  final String sessionId;
  final String title;
  final String description;
  final String reason;
  const RescheduleSessionScreen({
    super.key,
    required this.sessionId,
    required this.title,
    required this.description,
    required this.reason,
  });

  @override
  State<RescheduleSessionScreen> createState() =>
      _RescheduleSessionScreenState();
}

class _RescheduleSessionScreenState extends State<RescheduleSessionScreen> {
  late AllSessionCubit sessionCubit;

  late TodayScheduleSessionCubit todayScheduleSessionCubit;

  @override
  void initState() {
   
    super.initState();

    sessionCubit = BlocProvider.of<AllSessionCubit>(context);
    todayScheduleSessionCubit =
        BlocProvider.of<TodayScheduleSessionCubit>(context);
  }

  String? selectedDateText;
  String? selectedTimeText;

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

  Future<void> _onRescheduleSession() async {
    // Check if the selectedDate and selectedTime are not null
    // ignore: unnecessary_null_comparison
    if (selectedDate != null && selectedTime != null) {
      // Combine date and time into a single DateTime object
      DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Convert to UTC format
      DateTime utcDateTime = selectedDateTime.toUtc();

      // Format the selectedDateTime into the required format

      final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final formattedDateTime = formatter.format(utcDateTime);

      // another way of converting the date and time into utc
      // String formattedDateTime =
      //     '${utcDateTime.toIso8601String().substring(0, 23)}Z';

      // Call the rescheduleSession function with the formatted date and time
      await sessionCubit.rescheduleSession(
        sessionId: widget.sessionId, // Replace with your session ID
        startDate: formattedDateTime,
        reasonMessage: widget.reason, // Replace with your reason message
      );

      // Navigate back after rescheduling
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      showSnackBar("Date and Time is mandatory");
      // Handle the case where either the date or time is null
      // You may want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllSessionCubit, AllSessionState>(
        listener: (context, state) {
          if (state is AllSessionRescheduledState) {
            hideLoadingDialog(context);
            showGreenSnackBar(state.message);
          }

          if (state is AllSessionRescheduleLoadingState) {
            showLoadingDialog(context);
          }

          if (state is AllSessionErrorState) {
            Routes.goBack();
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Reschedule", secondText: "Session"),
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
                      "Title",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                    height(8),
                    NoIconTextFieldWidget(
                      initial: widget.title,
                      enabled: false,
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
                        enabled: false,
                        initialValue: widget.description,
                        minLines: 1,
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
                                      initialTime: selectedTime,
                                    );
                                    if (picked != null) {
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
                                            behavior: SnackBarBehavior.floating,
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
                        _onRescheduleSession();
                      },
                      text: "Reschedule Session",
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
