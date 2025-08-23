// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/feedback_cubit/feedback_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

class RatingDialog extends StatefulWidget {
  final String sessionId;
  const RatingDialog({super.key, required this.sessionId});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  bool isVisible = false;
  double rateOfExperience = 0;
  double coachRate = 0;
  double callQualityRate = 0;
  double easyToUseRate = 0;
  double privacySecurityRate = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 350.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF25D366),
              Color(0xFF03C0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 36.h,
            left: 18.w,
            right: 18.w,
            top: 18.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),

                height(15),
                Center(
                  child: simpleText(
                    "How are we doing? ",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                height(28),
                _buildRatingBar("Rate your experience", rateOfExperience),
                isVisible
                    ? Column(
                        children: [
                          height(12),
                          _buildRatingBar("Call Quality", callQualityRate),
                          height(12),
                          _buildRatingBar("Easy to Use", easyToUseRate),
                          height(12),
                          _buildRatingBar(
                              "Privacy and Security", privacySecurityRate),
                        ],
                      )
                    : const SizedBox(),
                height(35),

                height(64),
                WhiteBgBlackTextButton(
                  onpressed: () {
                    if (callQualityRate == 0 ||
                        easyToUseRate == 0 ||
                        privacySecurityRate == 0 ||
                        rateOfExperience == 0) {
                      // Show an error message or handle it as per your app logic
                      showSnackBar("Please fill all the value");
                    } else {
                      context.read<FeedBackCubit>().createFeedback(
                          sessionId: widget.sessionId,
                          rateOfExperience: rateOfExperience.toString(),
                          coachRate: coachRate.toString(),
                          callQualityRate: callQualityRate.toString(),
                          easyToUseRate: easyToUseRate.toString(),
                          privacySecurityRate: privacySecurityRate.toString());

                      Routes.goBack();
                    }
                  },
                  text: "Submit",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(String text, double rating) {
    return Column(
      children: [
        body1Text(
          text,
          color: Colors.white,
        ),
        height(7),
        RatingBar.builder(
          itemCount: 5,
          itemPadding: EdgeInsets.only(right: 4),
          initialRating: rating,
          minRating: 1,
          maxRating: 5,
          itemSize: 28.0,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.white,
          ),
          onRatingUpdate: (newRating) {
            // Update the corresponding variable based on the text
            switch (text) {
              case "Rate your experience":
                setState(() {
                  isVisible = true;
                  rateOfExperience = newRating;
                });
                break;
              case "Coach Rating":
                setState(() {
                  coachRate = newRating;
                });
                break;
              case "Call Quality":
                setState(() {
                  callQualityRate = newRating;
                });
                break;
              case "Easy to Use":
                setState(() {
                  easyToUseRate = newRating;
                });
                break;
              case "Privacy and Security":
                setState(() {
                  privacySecurityRate = newRating;
                });
                break;
            }
          },
        ),
      ],
    );
  }
}

class TodaySchedule extends StatefulWidget {
  final String date;
  const TodaySchedule({super.key, required this.date});

  @override
  State<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends State<TodaySchedule> {
  late AllSessionCubit allSessionCubit;
  String convertUtcToLocalTime(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime);
    final localDateTime = utcDateTime.toLocal();
    return DateFormat.Hm().format(localDateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    allSessionCubit = BlocProvider.of<AllSessionCubit>(context);

    allSessionCubit.getAvailableWeek(date: widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 350.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF25D366),
              Color(0xFF03C0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(
              bottom: 36.h,
              left: 18.w,
              right: 18.w,
              top: 18.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        simpleText(
                          "Todays Schedule",
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/Vector.svg", // Replace with your SVG file
                            width: 24.0,
                            height: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(15),
                  BlocBuilder<AllSessionCubit, AllSessionState>(
                    builder: (context, state) {
                      if (state is AllSessionWeeklyLoadingState) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Set color to white
                        ));
                      } else if (state is GetAvailableWeekState) {
                        // Display your dialog with the weekTimings data
                        return (state.weekTimings.isEmpty ||
                                state.weekTimings[0].timeSlots!.isEmpty)
                            ? Center(
                                child: simpleText(
                                  "No Schedule For Today",
                                  align: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var data =
                                      state.weekTimings[0].timeSlots?[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: TodayScheduleCard(
                                      sid: state.weekTimings[0].timeSlots?[index].sId ?? "",
                                      date: widget.date,
                                      endTime: convertUtcToLocalTime(
                                          data?.endTime ?? " "),
                                      startTime: convertUtcToLocalTime(
                                          data?.startTime ?? ""),
                                      isAvailable: data?.isAvailable ?? false,
                                    ),
                                  );
                                },
                                itemCount:
                                    state.weekTimings[0].timeSlots!.length,
                              );
                      } else if (state is AllSessionErrorState) {
                        return Text('Error: ${state.error}');
                      } else {
                        return Container(); // Handle other states if needed
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class TodayScheduleCard extends StatefulWidget {
  final String sid;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  const TodayScheduleCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.date,
    required this.sid,
  });

  @override
  State<TodayScheduleCard> createState() => _TodayScheduleCardState();
}

class _TodayScheduleCardState extends State<TodayScheduleCard> {
  String convertTo12HourFormat(String time) {
    final parsedTime = DateTime.parse("${widget.date} $time:00");
    return DateFormat.jm().format(parsedTime); // Format to 12-hour time
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 12.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          body1Text("Time Slot"),
          height(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: simpleText(
                          convertTo12HourFormat(widget.startTime),
                          color: Colors.black,
                        ),
                      )),
                      width(4),
                      SvgPicture.asset(
                        "assets/icons/clock.svg",
                        width: 20,
                        height: 20,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: simpleText(
                          convertTo12HourFormat(widget.endTime),
                          color: Colors.black,
                        ),
                      )),
                      width(4),
                      SvgPicture.asset(
                        "assets/icons/clock.svg",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: widget.isAvailable
                        ? AppColors.primaryGreen
                        : AppColors.secondaryRedColor,
                    borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                child: simpleText(
                  widget.isAvailable ? "Available" : "Unavailable",
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDeleteConfirmationDialog(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: simpleText(
            "Delete Time Slot",
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
          content: simpleText("Are you sure you want to delete this time slot?",
              fontSize: 18, fontWeight: FontWeight.w400),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: simpleText("Cancel"),
            ),
            TextButton(
              onPressed: () {
               // print(widget.sid);
                // Call the function to delete the time slot from the backend
               deleteTimeSlot(myCoach?.userId ?? "", widget.date, widget.sid);
                Navigator.of(context).pop();
              },
              child: simpleText("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deleteTimeSlot(String coachId, String date, String timeSlotId) async {
    await BlocProvider.of<AllSessionCubit>(context)
        .removeTimeSlot(coachId: coachId, date: date, timeSlotId: timeSlotId);
    // Call your AllSessionCubit function to delete the time slot here
    // Example: allSessionCubit.removeTimeSlot(coachId, widget.date, timeSlotId);
  }
}

class PreviousRatingDialog extends StatefulWidget {
  final String sessionId;
  const PreviousRatingDialog({super.key, required this.sessionId});

  @override
  _PreviousRatingDialogState createState() => _PreviousRatingDialogState();
}

class _PreviousRatingDialogState extends State<PreviousRatingDialog> {
  bool isVisible = false;
  double rateOfExperience = 0;
  double coachRate = 0;
  double callQualityRate = 0;
  double easyToUseRate = 0;
  double privacySecurityRate = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 350.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF25D366),
              Color(0xFF03C0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 36.h,
            left: 18.w,
            right: 18.w,
            top: 18.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),

                height(15),
                Center(
                  child: simpleText("How are we doing? ",
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      align: TextAlign.center),
                ),
                height(16),
                Center(
                  child: body1Text(
                    "Please rate feedback of your last session",
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(28),
                _buildRatingBar("Rate your experience", rateOfExperience),
                isVisible
                    ? Column(
                        children: [
                          height(12),
                          _buildRatingBar("Call Quality", callQualityRate),
                          height(12),
                          _buildRatingBar("Easy to Use", easyToUseRate),
                          height(12),
                          _buildRatingBar(
                              "Privacy and Security", privacySecurityRate),
                        ],
                      )
                    : const SizedBox(),
                height(35),

                height(64),
                WhiteBgBlackTextButton(
                  onpressed: () {
                    if (callQualityRate == 0 ||
                        easyToUseRate == 0 ||
                        privacySecurityRate == 0 ||
                        rateOfExperience == 0) {
                      // Show an error message or handle it as per your app logic
                      showSnackBar("Please fill all the value");
                    } else {
                      context.read<FeedBackCubit>().createFeedback(
                          sessionId: widget.sessionId,
                          rateOfExperience: rateOfExperience.toString(),
                          coachRate: coachRate.toString(),
                          callQualityRate: callQualityRate.toString(),
                          easyToUseRate: easyToUseRate.toString(),
                          privacySecurityRate: privacySecurityRate.toString());

                      Routes.goBack();
                    }
                  },
                  text: "Submit",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(String text, double rating) {
    return Column(
      children: [
        body1Text(
          text,
          color: Colors.white,
        ),
        height(7),
        RatingBar.builder(
          itemCount: 5,
          itemPadding: EdgeInsets.only(right: 4),
          initialRating: rating,
          minRating: 1,
          maxRating: 5,
          itemSize: 28.0,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.white,
          ),
          onRatingUpdate: (newRating) {
            // Update the corresponding variable based on the text
            switch (text) {
              case "Rate your experience":
                setState(() {
                  isVisible = true;
                  rateOfExperience = newRating;
                });
                break;
              case "Coach Rating":
                setState(() {
                  coachRate = newRating;
                });
                break;
              case "Call Quality":
                setState(() {
                  callQualityRate = newRating;
                });
                break;
              case "Easy to Use":
                setState(() {
                  easyToUseRate = newRating;
                });
                break;
              case "Privacy and Security":
                setState(() {
                  privacySecurityRate = newRating;
                });
                break;
            }
          },
        ),
      ],
    );
  }
}
