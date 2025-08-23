import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/widgets/home_upcoming_session_container.dart';
import 'package:zanadu_coach/feature/home/widgets/rating_session.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/cancel_session_dialog.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/reschedule_session_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  final String date;

  const ScheduleScreen({
    super.key,
    required this.date,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late CalendarCubit calendarCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    calendarCubit = BlocProvider.of<CalendarCubit>(context);
    calendarCubit.getScheduleSession(widget.date);
  }

  String selectedLanguage = 'Feeling Unwell';
  void showCancelSessionDialog(BuildContext context, VoidCallback onpressed) {
    showDialog(
      context: context,
      builder: (context) {
        return CancelSessionDialog(
          onpressed: onpressed,
          selectReason: selectedLanguage,
          onLanguageSelected: (value) {
            setState(() {
              selectedLanguage = value;
            });
          },
        );
      },
    );
  }

  String rescheduleReason = 'Feeling Unwell'; // Default selected language

  void showRescheduleSessionDialog(
      BuildContext context, VoidCallback onpressed) {
    showDialog(
      context: context,
      builder: (context) {
        return RescheduleSessionReason(
          onpressed: onpressed,
          selectReason: rescheduleReason,
          onLanguageSelected: (value) {
            setState(() {
              rescheduleReason = value;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScheduleAppBar(
        secondText: "Schedule",
        onpressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (context) => AllSessionCubit(),
                child: TodaySchedule(
                  date: widget.date,
                ),
              );
            },
          );
        },
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 28.h,
            horizontal: 28.w,
          ),
          child: BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, state) {
              if (state is CalendarScheduleLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is CalendarScheduleSessionLoadedState) {
                // Access the loaded plan from the state
                if (state.sessions.isEmpty) {
                  return Center(
                      child: simpleText(
                    "There is no session schedule today",
                    align: TextAlign.center,
                  ));
                }
                return Column(
                  children: [
                    for (var session in state.sessions)
                      if (session.sessionType == "ORIENTATION")
                        Column(
                          children: [
                            HomeOrientationContainer(
                              offeringName: session.offeringName ?? "",
                              startNowOnpressed: () {
                                Routes.goTo(
                                  Screens.groupVideo,
                                  arguments: {
                                    'channelId': session.channelName,
                                    'endtime': session.endDate,
                                    'sessionId': session.sId,
                                    'chatroomId': session.chatroomId
                                  },
                                );
                              },
                              isPastSession: getDifferenceBoolPastSession(
                                  session.startDate ?? ""),
                              rescheduleOnpressed: () {
                                simpleDialog(
                                  context,
                                  "Are You Sure?",
                                  "Want to Reschedule this Session",
                                  "Yes",
                                  "Cancel",
                                  () {
                                    Navigator.of(context).pop();
                                    showRescheduleSessionDialog(
                                      context,
                                      () {
                                        Routes.goTo(
                                          Screens.reschedulesession,
                                          arguments: {
                                            'sessionId': session.sId,
                                            'title': session.title ?? "",
                                            'description': session.description,
                                            'reason': rescheduleReason,
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              cancelOnpressed: () {
                                simpleDialog(
                                  context,
                                  "Are You Sure?",
                                  "Want to Cancel this Session",
                                  "Yes",
                                  "Cancel",
                                  () {
                                    Navigator.of(context).pop();
                                    showCancelSessionDialog(
                                      context,
                                      () {
                                        BlocProvider.of<AllSessionCubit>(
                                                context)
                                            .cancelSession(
                                                sessionId: session.sId ?? "",
                                                reasonMessage:
                                                    selectedLanguage);
                                      },
                                    );
                                  },
                                );
                              },
                              availableSlot:
                                  (session.noOfSlots! - session.userId!.length)
                                      .toString(),
                              occupiedSlot:
                                  session.userId?.length.toString() ?? "",
                              isStartNow:
                                  getDifferenceBool(session.startDate ?? ""),
                              date: myformattedDate(session.startDate ?? ""),
                              time: myformattedTime(session.startDate ?? ""),
                              firstText: session.title ?? "",
                            ),
                            height(26)
                          ],
                        )
                      else if (session.sessionType == "DISCOVERY" ||
                          session.sessionType == "FOLLOW_UP")
                        Column(
                          children: [
                            HomeOneSessionContainer(
                              offeringName: session.offeringName ?? "",
                              isPastSession: getDifferenceBoolPastSession(
                                  session.startDate ?? ""),
                              imgurl: session.userInfo?.image,
                              coachName: session.userInfo?.fullName ?? "",
                              date: myformattedDate(session.startDate ?? ""),
                              time: myformattedTime(session.startDate ?? ""),
                              startNowOnpressed: () {
                                Routes.goTo(
                                  Screens.oneOnOneVideo,
                                  arguments: {
                                    'channelId': session.channelName,
                                    'endtime': session.endDate,
                                    'sessionId': session.sId,
                                    'chatroomId': session.chatroomId
                                  },
                                );
                              },
                              rescheduleOnpressed: () {
                                simpleDialog(
                                  context,
                                  "Are You Sure?",
                                  "Want to Reschedule this Session",
                                  "Yes",
                                  "Cancel",
                                  () {
                                    Navigator.of(context).pop();
                                    showRescheduleSessionDialog(
                                      context,
                                      () {
                                        Routes.goTo(
                                          Screens.reschedulesession,
                                          arguments: {
                                            'sessionId': session.sId,
                                            'title': session.title ?? "",
                                            'description': session.description,
                                            'reason': rescheduleReason
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              cancelOnpressed: () {
                                simpleDialog(
                                    context,
                                    "Are You Sure?",
                                    "Want to Cancel this Session",
                                    "Yes",
                                    "Cancel", () {
                                  Navigator.of(context).pop();
                                  showCancelSessionDialog(context, () {
                                    BlocProvider.of<AllSessionCubit>(context)
                                        .cancelSession(
                                      sessionId: session.sId ?? "",
                                      reasonMessage: selectedLanguage,
                                    );
                                  });
                                });
                              },
                              firstText: session.title ?? "",
                              isStartNow: getDifferenceBool(
                                session.startDate ?? "",
                              ),
                            ),
                            height(26)
                          ],
                        )
                      else if (session.sessionType == "GROUP" ||
                          session.sessionType == "YOGA")
                        Column(
                          children: [
                            HomeGroupSessionContainer(
                              offeringName: session.offeringName ?? "",
                              startNowOnpressed: () {
                                Routes.goTo(
                                  Screens.groupVideo,
                                  arguments: {
                                    'channelId': session.channelName,
                                    'endtime': session.endDate,
                                    'sessionId': session.sId,
                                    'chatroomId': session.chatroomId
                                  },
                                );
                              },
                              isPastSession: getDifferenceBoolPastSession(
                                  session.startDate ?? ""),
                              secondText: session.sessionType == "GROUP"
                                  ? "Group Session"
                                  : "Yoga Session",
                              availableSlot:
                                  (session.noOfSlots! - session.userId!.length)
                                      .toString(),
                              occupiedSlot:
                                  session.userId?.length.toString() ?? "",
                              rescheduleOnpressed: () {
                                simpleDialog(
                                    context,
                                    "Are You Sure?",
                                    "Want to Reschedule this Session",
                                    "Yes",
                                    "Cancel", () {
                                  Navigator.of(context).pop();
                                  showRescheduleSessionDialog(context, () {
                                    Routes.goTo(
                                      Screens.reschedulesession,
                                      arguments: {
                                        'sessionId': session.sId,
                                        'title': session.title ?? "",
                                        'description': session.description,
                                        'reason': rescheduleReason
                                      },
                                    );
                                  });
                                });
                              },
                              cancelOnpressed: () {
                                simpleDialog(
                                    context,
                                    "Are You Sure?",
                                    "Want to Cancel this Session",
                                    "Yes",
                                    "Cancel", () {
                                  Navigator.of(context).pop();
                                  showCancelSessionDialog(context, () {
                                    BlocProvider.of<AllSessionCubit>(context)
                                        .cancelSession(
                                            sessionId: session.sId ?? "",
                                            reasonMessage: selectedLanguage);
                                  });
                                });
                              },
                              firstText: session.title ?? "",
                              isStartNow:
                                  getDifferenceBool(session.startDate ?? ""),
                              date: myformattedDate(session.startDate ?? ""),
                              time: myformattedTime(session.startDate ?? ""),
                            ),
                            height(26)
                          ],
                        ),
                  ],
                );
              } else if (state is CalendarErrorState) {
                return Text('Error: ${state.error}');
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      )),
    );
  }
}
