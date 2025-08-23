import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/services/notification_service.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/widgets/best_health_coach_widget.dart';
import 'package:zanadu_coach/feature/home/widgets/give_rating_dialog.dart';
import 'package:zanadu_coach/feature/home/widgets/home_screen_chart_container.dart';
import 'package:zanadu_coach/feature/home/widgets/home_upcoming_session_container.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/notification_cubit/notification_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/feedback_cubit/feedback_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/widgets/all_dialog.dart';
import 'package:zanadu_coach/widgets/cancel_session_dialog.dart';
import 'package:zanadu_coach/widgets/custom_app_bar.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/reschedule_session_dialog.dart';
import 'package:zanadu_coach/widgets/show_and_remove_circular_indicator.dart';
import '../logic/provider/home_bottom_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoginRepository loginRepository = LoginRepository();
  NotificationServices notificationServices = NotificationServices();
  late AllSessionCubit getAllSession;
  late FeedBackCubit feedBackCubit;
  // late NotificationCubit notificationCubit;
  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.forgroundMessage();
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) async {
      String? deviceId = await notificationServices.getId();
      await loginRepository.updateDeviceInfo(
          deviceId: deviceId ?? "",
          firebaseToken: value.toString(),
          type: "phone");

      print(value.toString());
      print(deviceId);
    });

    getAllSession = BlocProvider.of<AllSessionCubit>(context);

    getAllSession.fetchSessionByCoach();
    feedBackCubit = BlocProvider.of<FeedBackCubit>(context);
    feedBackCubit.getPrevFeedBack();

    // notificationCubit = BlocProvider.of<NotificationCubit>(context);
    // notificationCubit.getUnreadNotificationData();
  }

  @override
  void dispose() {
    super.dispose();
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    final tabIndexProvider = Provider.of<TabIndexProvider>(context);
    return MultiBlocListener(
        listeners: [
          BlocListener<FeedBackCubit, FeedBackState>(
              listener: (context, state) {
            if (state is FeedBackCreateLoadedState) {
              showGreenSnackBar(state.feedBacks);
            }
            if (state is GetFeedBackLoadedState) {
              if (state.feedBack != null) {
                givePrevRatingDialog(context, state.feedBack?.sId ?? "");
              }
            }
          }),
          BlocListener<NotificationCubit, NotificationState>(
              listener: (context, state) {
            if (state is UnreadNotificationLoadedState) {
              if (state.notifications.isNotEmpty) {
                showGreenSnackBar("New Notification");
              }
            }
          }),
          BlocListener<NotificationCubit, NotificationState>(
              listener: (context, state) {
            if (state is UnreadNotificationLoadedState) {
              if (state.notifications.isNotEmpty) {
                showGreenSnackBar("New Notification");
              }
            }
          }),
        ],
        child: Scaffold(
          appBar: CustomAppBar(onpressed: () {
            if (myCoach?.isApproved == true) {
              tabIndexProvider.setInitialTabIndex(3);
            } else {
              onlyTextWithCutIcon(context, "Your account is not approved yet");
            }
          }),
          body: SafeArea(
            child: myCoach?.isApproved ?? false
                ? BlocListener<AllSessionCubit, AllSessionState>(
                    listener: (context, state) {
                      if (state is AllSessionCancelState) {
                        hideLoadingDialog(context);
                        getAllSession.fetchSessionByCoach();
                        showGreenSnackBar(state.message);
                      }

                      if (state is AllSessionCancelLoadingState) {
                        showLoadingDialog(context);
                      }
                      if (state is AllSessionRescheduledState) {}
                      if (state is AllSessionErrorState) {
                        // Routes.goBack();
                        showSnackBar(state.error);
                      }
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(15),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  HomeScreenChartContainer(
                                    interval: 2,
                                    onpressed: () {
                                      tabIndexProvider.setInitialTabIndex(1);
                                    },
                                    firstText: "Users Attendance (In %)",
                                    secondText: "Recent Group Sessions",
                                  ),
                                  width(10),
                                  HomeScreenRatingChartContainer(
                                    interval: 2,
                                    onpressed: () {
                                      tabIndexProvider.setInitialTabIndex(1);
                                    },
                                    firstText: "My Ratings",
                                    secondText: "Recent Sessions",
                                  ),
                                  width(10),
                                  HomeScreenFreqChartContainer(
                                    onpressed: () {
                                      tabIndexProvider.setInitialTabIndex(1);
                                    },
                                    firstText: "Sessions Frequency",
                                    secondText: "Recent Sessions",
                                  )
                                ],
                              ),
                            ),
                            height(28),
                            const BestHealthCoachWidget(
                              text: "Upcoming Sessions",
                            ),
                            height(18),
                            BlocBuilder<AllSessionCubit, AllSessionState>(
                              builder: (context, state) {
                                if (state is AllSessionLoadingState) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                } else if (state is AllSessionLoadedState) {
                                  // Access the loaded plan from the state
                                  var sessions = state.allSessions;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ... (existing code)
                                      if (sessions.isEmpty ||
                                          sessions.every((session) =>
                                              session.isApproved == false))
                                        Center(
                                            child: simpleText(
                                                "There is no upcoming session")),
                                      // Iterate over sessions and display the appropriate widget
                                      for (var session in sessions)
                                        if (session.sessionType ==
                                                "ORIENTATION" &&
                                            session.isApproved == true)
                                          Column(
                                            children: [
                                              HomeOrientationContainer(
                                                offeringName:
                                                    session.offeringName ?? "",
                                                startNowOnpressed: () {
                                                  Routes.goTo(
                                                    Screens.groupVideo,
                                                    arguments: {
                                                      'channelId':
                                                          session.channelName,
                                                      'endtime':
                                                          session.endDate,
                                                      'sessionId': session.sId,
                                                      'chatroomId':
                                                          session.chatroomId
                                                    },
                                                  );
                                                },
                                                isPastSession:
                                                    getDifferenceBoolPastSession(
                                                        session.startDate ??
                                                            ""),
                                                availableSlot: (
                                                  session.noOfSlots! -
                                                      session.userId!.length,
                                                ).toString(),
                                                occupiedSlot: session
                                                        .userId?.length
                                                        .toString() ??
                                                    "",
                                                isStartNow: getDifferenceBool(
                                                  session.startDate ?? "",
                                                ),
                                                date: myformattedDate(
                                                  session.startDate ?? "",
                                                ),
                                                time: myformattedTime(
                                                  session.startDate ?? "",
                                                ),
                                                rescheduleOnpressed: () {
                                                  simpleDialog(
                                                    context,
                                                    "Are You Sure?",
                                                    "Want to Reschedule this Session",
                                                    "Yes",
                                                    "Cancel",
                                                    () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showRescheduleSessionDialog(
                                                        context,
                                                        () {
                                                          Routes.goTo(
                                                            Screens
                                                                .reschedulesession,
                                                            arguments: {
                                                              'sessionId':
                                                                  session.sId,
                                                              'title': session
                                                                      .title ??
                                                                  "",
                                                              'description':
                                                                  session
                                                                      .description,
                                                              'reason':
                                                                  rescheduleReason,
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
                                                      Navigator.of(context)
                                                          .pop();
                                                      showCancelSessionDialog(
                                                        context,
                                                        () {
                                                          Routes.goBack();
                                                          getAllSession.cancelSession(
                                                              sessionId:
                                                                  session.sId ??
                                                                      "",
                                                              reasonMessage:
                                                                  selectedLanguage);
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                firstText: session.title ?? "",
                                              ),
                                              height(26)
                                            ],
                                          )
                                        else if ((session.sessionType ==
                                                    "DISCOVERY" ||
                                                session.sessionType ==
                                                    "FOLLOW_UP") &&
                                            session.isApproved == true)
                                          Column(
                                            children: [
                                              HomeOneSessionContainer(
                                                offeringName:
                                                    session.offeringName ?? "",
                                                isPastSession:
                                                    getDifferenceBoolPastSession(
                                                        session.startDate ??
                                                            ""),
                                                startNowOnpressed: () {
                                                  Routes.goTo(
                                                    Screens.groupVideo,
                                                    arguments: {
                                                      'channelId':
                                                          session.channelName,
                                                      'endtime':
                                                          session.endDate,
                                                      'sessionId': session.sId,
                                                      'chatroomId':
                                                          session.chatroomId
                                                    },
                                                  );
                                                },
                                                imgurl: session.userInfo?.image,
                                                coachName: session
                                                        .userInfo?.fullName ??
                                                    "",
                                                date: myformattedDate(
                                                    session.startDate ?? ""),
                                                time: myformattedTime(
                                                    session.startDate ?? ""),
                                                rescheduleOnpressed: () {
                                                  simpleDialog(
                                                    context,
                                                    "Are You Sure?",
                                                    "Want to Reschedule this Session",
                                                    "Yes",
                                                    "Cancel",
                                                    () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showRescheduleSessionDialog(
                                                        context,
                                                        () {
                                                          Routes.goTo(
                                                            Screens
                                                                .reschedulesession,
                                                            arguments: {
                                                              'sessionId':
                                                                  session.sId,
                                                              'title': session
                                                                      .title ??
                                                                  "",
                                                              'description':
                                                                  session
                                                                      .description,
                                                              'reason':
                                                                  rescheduleReason
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
                                                    showCancelSessionDialog(
                                                        context, () {
                                                      Routes.goBack();
                                                      getAllSession
                                                          .cancelSession(
                                                        sessionId:
                                                            session.sId ?? "",
                                                        reasonMessage:
                                                            selectedLanguage,
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
                                        else if ((session.sessionType ==
                                                    "GROUP" ||
                                                session.sessionType ==
                                                    "YOGA") &&
                                            session.isApproved == true)
                                          Column(
                                            children: [
                                              HomeGroupSessionContainer(
                                                offeringName:
                                                    session.offeringName ?? "",
                                                startNowOnpressed: () {
                                                  Routes.goTo(
                                                    Screens.groupVideo,
                                                    arguments: {
                                                      'channelId':
                                                          session.channelName,
                                                      'endtime':
                                                          session.endDate,
                                                      'sessionId': session.sId,
                                                      'chatroomId':
                                                          session.chatroomId
                                                    },
                                                  );
                                                },
                                                isPastSession:
                                                    getDifferenceBoolPastSession(
                                                        session.startDate ??
                                                            ""),
                                                secondText:
                                                    session.sessionType ==
                                                            "GROUP"
                                                        ? "Group Session"
                                                        : "Yoga Session",
                                                availableSlot: (session
                                                            .noOfSlots! -
                                                        session.userId!.length)
                                                    .toString(),
                                                occupiedSlot: session
                                                        .userId?.length
                                                        .toString() ??
                                                    "",
                                                rescheduleOnpressed: () {
                                                  simpleDialog(
                                                      context,
                                                      "Are You Sure?",
                                                      "Want to Reschedule this Session",
                                                      "Yes",
                                                      "Cancel", () {
                                                    Navigator.of(context).pop();
                                                    showRescheduleSessionDialog(
                                                        context, () {
                                                      Routes.goTo(
                                                        Screens
                                                            .reschedulesession,
                                                        arguments: {
                                                          'sessionId':
                                                              session.sId,
                                                          'title':
                                                              session.title ??
                                                                  "",
                                                          'description': session
                                                              .description,
                                                          'reason':
                                                              rescheduleReason
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
                                                    showCancelSessionDialog(
                                                        context, () {
                                                      Routes.goBack();
                                                      getAllSession.cancelSession(
                                                          sessionId:
                                                              session.sId ?? "",
                                                          reasonMessage:
                                                              selectedLanguage);
                                                    });
                                                  });
                                                },
                                                firstText: session.title ?? "",
                                                isStartNow: getDifferenceBool(
                                                    session.startDate ?? ""),
                                                date: myformattedDate(
                                                    session.startDate ?? ""),
                                                time: myformattedTime(
                                                    session.startDate ?? ""),
                                              ),
                                              height(26)
                                            ],
                                          ),
                                    ],
                                  );
                                } else if (state is AllSessionErrorState) {
                                  return Text('Error: ${state.error}');
                                } else {
                                  return const Text('Something is wrong');
                                }
                              },
                            ),
                            height(28),
                          ],
                        ),
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        simpleText(
                          "Stay Tuned !",
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                        simpleText(
                            "Your Profile is being reviewed by the ZH Admin . You Will be notified once your profile is Approved  ",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            align: TextAlign.center),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
