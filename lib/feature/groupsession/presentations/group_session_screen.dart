import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/groupsession/widgets/floating_colored_button.dart';
import 'package:zanadu_coach/feature/groupsession/widgets/group_session_container.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/cancel_session_dialog.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/reschedule_session_dialog.dart';

// ignore: must_be_immutable
class GroupSession extends StatefulWidget {
  GroupSession({super.key});

  @override
  State<GroupSession> createState() => _GroupSessionState();
}

class _GroupSessionState extends State<GroupSession> {
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
            text: "Create Group Session",
            size: 16,
            weight: FontWeight.w600,
            verticalPadding: 12,
            onpressed: () {
              Routes.goTo(Screens.createGroupSession);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Group", secondText: "Sessions"),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 75),
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

                      var groupSessions = state.groupSessions;

                      return groupSessions.isEmpty ||
                              groupSessions.every(
                                  (session) => session.isApproved == false)
                          ? Center(
                              child: simpleText(
                              "There is no Group Session Schedule",
                              align: TextAlign.center,
                            ))
                          : Column(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: groupSessions.length,
                                  itemBuilder: (context, index) {
                                    if (groupSessions[index].isApproved ==
                                        true) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: GroupSessionContainer(
                                          offeringName: groupSessions[index]
                                                  .offeringName ??
                                              "",
                                          startNowOnpressed: () {
                                            Routes.goTo(
                                              Screens.groupVideo,
                                              arguments: {
                                                'channelId':
                                                    groupSessions[index]
                                                        .channelName,
                                                'endtime': groupSessions[index]
                                                    .endDate,
                                                'sessionId':
                                                    groupSessions[index].sId,
                                                'chatroomId':
                                                    groupSessions[index]
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
                                                      Screens.reschedulesession,
                                                      arguments: {
                                                        'sessionId':
                                                            groupSessions[index]
                                                                .sId,
                                                        'title':
                                                            groupSessions[index]
                                                                    .title ??
                                                                "",
                                                        'description':
                                                            groupSessions[index]
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
                                              showCancelSessionDialog(context,
                                                  () {
                                                BlocProvider.of<
                                                            AllSessionCubit>(
                                                        context)
                                                    .cancelSession(
                                                  sessionId:
                                                      groupSessions[index]
                                                              .sId ??
                                                          "",
                                                  reasonMessage:
                                                      selectedLanguage,
                                                );
                                                Routes.goBack();
                                              });
                                            });
                                          },
                                          availableSlot:
                                              (groupSessions[index].noOfSlots! -
                                                      groupSessions[index]
                                                          .userId!
                                                          .length)
                                                  .toString(),
                                          occupiedSlot: groupSessions[index]
                                                  .userId
                                                  ?.length
                                                  .toString() ??
                                              "",
                                          date:
                                              groupSessions[index].startDate ??
                                                  "",
                                          firstText:
                                              groupSessions[index].title ?? "",
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
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
              ),
            ),
          )),
        ));
  }
}
