import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/orientation_session/widgets/orientation_container.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';

import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/cancel_session_dialog.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/reschedule_session_dialog.dart';

class OrientationSession extends StatefulWidget {
  const OrientationSession({
    super.key,
  });

  @override
  State<OrientationSession> createState() => _OrientationSessionState();
}

class _OrientationSessionState extends State<OrientationSession> {
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
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Orientation", secondText: "Sessions"),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
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

                    var orientation = state.orientations;

                    return orientation.isEmpty ||
                            orientation
                                .every((session) => session.isApproved == false)
                        ? Center(
                            child: simpleText(
                            "There is no Orientation Session Schedule",
                            align: TextAlign.center,
                          ))
                        : Column(
                            children: [
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: orientation.length,
                                  itemBuilder: (context, index) {
                                    if (orientation[index].isApproved == true) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: OrientationContainer(
                                          offeringName:
                                              orientation[index].offeringName ??
                                                  "",
                                          startNowOnpressed: () {
                                            Routes.goTo(
                                              Screens.groupVideo,
                                              arguments: {
                                                'channelId': orientation[index]
                                                    .channelName,
                                                'endtime':
                                                    orientation[index].endDate,
                                                'sessionId':
                                                    orientation[index].sId,
                                                'chatroomId': orientation[index]
                                                    .chatroomId
                                              },
                                            );
                                          },
                                          isStartNow: getDifferenceBool(
                                              orientation[index].startDate ??
                                                  " "),
                                          availableSlot:
                                              (orientation[index].noOfSlots! -
                                                      orientation[index]
                                                          .userId!
                                                          .length)
                                                  .toString(),
                                          occupiedSlot: orientation[index]
                                                  .userId
                                                  ?.length
                                                  .toString() ??
                                              "",
                                          date: orientation[index].startDate ??
                                              "",
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
                                                            orientation[index]
                                                                .sId,
                                                        'title':
                                                            orientation[index]
                                                                    .title ??
                                                                "",
                                                        'description':
                                                            orientation[index]
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
                                                      orientation[index].sId ??
                                                          "",
                                                  reasonMessage:
                                                      selectedLanguage,
                                                );
                                                Routes.goBack();
                                              });
                                            });
                                          },
                                          firstText:
                                              orientation[index].title ?? "",
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
          )),
        ));
  }
}
