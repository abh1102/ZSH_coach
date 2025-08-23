import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/groupsession/widgets/floating_colored_button.dart';
import 'package:zanadu_coach/feature/one_on_one_session/widgets/new_one_session_container.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/cancel_session_dialog.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/reschedule_session_dialog.dart';

class OneOneSessionScreen extends StatefulWidget {
  const OneOneSessionScreen({
    super.key,
  });

  @override
  State<OneOneSessionScreen> createState() => _OneOneSessionScreenState();
}

class _OneOneSessionScreenState extends State<OneOneSessionScreen> {
  late AllSessionCubit getAllSession;
  @override
  void initState() {
    super.initState();

    getAllSession = BlocProvider.of<AllSessionCubit>(context);

    getAllSession.fetchSessionByCoach();
    // Provider.of<SessionProvider>(context, listen: false)
    //     .loadDummyAvailabilityData();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllSessionCubit, AllSessionState>(
        listener: (context, state) {
          if (state is AllSessionCancelState) {
            BlocProvider.of<AllSessionCubit>(context).fetchSessionByCoach();
            showGreenSnackBar(state.message);
          }

          if (state is AllSessionErrorState) {
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          floatingActionButton: FloatingColoredButton(
            text: "View Session Requests",
            size: 16,
            weight: FontWeight.w600,
            verticalPadding: 12,
            onpressed: () {
              Routes.goTo(Screens.oneOneSessionRequest);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "One On One", secondText: "Sessions"),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 75.h),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 28.h,
                    horizontal: 28.w,
                  ),
                  child: BlocBuilder<AllSessionCubit, AllSessionState>(
                    builder: (context, state) {
                      if (state is AllSessionLoadingState) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (state is AllSessionCancelLoadingState) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (state is AllSessionLoadedState) {
                        // Access the loaded plan from the state

                        var oneOnOneSession = state.oneToOneSessions;

                        return oneOnOneSession.isEmpty ||
                                (oneOnOneSession.every((session) =>
                                    session.isApproved == false &&
                                    session.status != "COACH_REQUESTED"))
                            ? Center(
                                child: simpleText(
                                "There is no One to One Session Schedule",
                                align: TextAlign.center,
                              ))
                            : Column(
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: oneOnOneSession.length,
                                      itemBuilder: (context, index) {
                                        if (oneOnOneSession[index].isApproved ==
                                            true) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 16.h),
                                            child: NewOneSessionContainer(
                                              offeringName:
                                                  oneOnOneSession[index]
                                                          .offeringName ??
                                                      "",
                                              imgUrl: oneOnOneSession[index]
                                                  .userInfo
                                                  ?.image,
                                              title: oneOnOneSession[index]
                                                      .userInfo
                                                      ?.fullName ??
                                                  "",
                                              startNowOnpressed: () {
                                                Routes.goTo(
                                                  Screens.groupVideo,
                                                  arguments: {
                                                    'channelId':
                                                        oneOnOneSession[index]
                                                            .channelName,
                                                    'endtime':
                                                        oneOnOneSession[index]
                                                            .endDate,
                                                    'sessionId':
                                                        oneOnOneSession[index]
                                                            .sId,
                                                    'chatroomId':
                                                        oneOnOneSession[index]
                                                            .chatroomId,
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
                                                          Screens
                                                              .reschedulesession,
                                                          arguments: {
                                                            'sessionId':
                                                                oneOnOneSession[
                                                                        index]
                                                                    .sId,
                                                            'title':
                                                                oneOnOneSession[
                                                                            index]
                                                                        .title ??
                                                                    "",
                                                            'description':
                                                                oneOnOneSession[
                                                                        index]
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
                                                    BlocProvider.of<
                                                                AllSessionCubit>(
                                                            context)
                                                        .cancelSession(
                                                      sessionId:
                                                          oneOnOneSession[index]
                                                                  .sId ??
                                                              "",
                                                      reasonMessage:
                                                          selectedLanguage,
                                                    );

                                                    Routes.goBack();
                                                  });
                                                });
                                              },
                                              date: oneOnOneSession[index]
                                                      .startDate ??
                                                  " ",
                                              firstText: oneOnOneSession[index]
                                                      .title ??
                                                  "",
                                            ),
                                          );
                                        } else if (oneOnOneSession[index]
                                                .status ==
                                            "COACH_REQUESTED") {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 16.h),
                                            child:
                                                NewOneSessionRequestedContainer(
                                              date: oneOnOneSession[index]
                                                      .startDate ??
                                                  " ",
                                              firstText: oneOnOneSession[index]
                                                      .title ??
                                                  "",
                                              offeringName:
                                                  oneOnOneSession[index]
                                                          .offeringName ??
                                                      "",
                                              imgUrl: oneOnOneSession[index]
                                                  .userInfo
                                                  ?.image,
                                              title: oneOnOneSession[index]
                                                      .userInfo
                                                      ?.fullName ??
                                                  "",
                                            ),
                                          );
                                        } else if (oneOnOneSession[index]
                                                .status ==
                                            "REJECTED") {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 16.h),
                                            child:
                                                NewOneSessionRejectedContainer(
                                              date: oneOnOneSession[index]
                                                      .startDate ??
                                                  " ",
                                              firstText: oneOnOneSession[index]
                                                      .title ??
                                                  "",
                                              offeringName:
                                                  oneOnOneSession[index]
                                                          .offeringName ??
                                                      "",
                                              imgUrl: oneOnOneSession[index]
                                                  .userInfo
                                                  ?.image,
                                              title: oneOnOneSession[index]
                                                      .userInfo
                                                      ?.fullName ??
                                                  "",
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                ],
                              );
                      } else if (state is AllSessionErrorState) {
                        return Text('Error: ${state.error}');
                      } else {
                        return const Text('Something is wrong');
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
