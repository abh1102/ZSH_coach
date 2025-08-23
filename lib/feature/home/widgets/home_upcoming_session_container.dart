import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/home_chart.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';
import 'package:zanadu_coach/widgets/tag_container.dart';

class HomeOneSessionContainer extends StatefulWidget {
  final String? imgurl;
  final String firstText;
  final String coachName;
  final String offeringName;
  final String date;
  final String time;
  final bool isStartNow;
  final bool isPastSession;
  final VoidCallback? startNowOnpressed;
  final VoidCallback? cancelOnpressed;
  final VoidCallback? rescheduleOnpressed;
  const HomeOneSessionContainer(
      {super.key,
      required this.firstText,
      required this.isStartNow,
      this.startNowOnpressed,
      this.cancelOnpressed,
      this.rescheduleOnpressed,
      required this.coachName,
      required this.date,
      required this.time,
      this.imgurl,
      required this.isPastSession,
      required this.offeringName});

  @override
  State<HomeOneSessionContainer> createState() =>
      _HomeOneSessionContainerState();
}

class _HomeOneSessionContainerState extends State<HomeOneSessionContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
        horizontal: 22.w,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    simpleText(
                      widget.firstText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    TagContainer(
                        firstLetter: widget.offeringName,
                        padding: 2,
                        fontSize: 9),
                    height(8),
                    simpleText(
                      widget.coachName,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    height(8),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/calendar.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.date,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(7),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.time,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryGreen,
                          )),
                      child: CircularCustomImageWidget(
                        url: widget.imgurl ?? defaultAvatar,
                        myheight: 70,
                        mywidth: 70,
                      ))
                ],
              )
            ],
          ),
          height(16),
          widget.isPastSession
              ? Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.greyDark),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: simpleText(
                    "Completed",
                    color: AppColors.greyDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: widget.isStartNow
                          ? GestureDetector(
                              onTap: widget.startNowOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.primaryBlue,
                                ),
                                child: simpleText(
                                  "Start Now",
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.rescheduleOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.greyDark),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: simpleText(
                                  "Re-Schedule",
                                  color: AppColors.greyDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                    width(23),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.cancelOnpressed,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.greyDark),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: simpleText(
                            "Cancel",
                            color: AppColors.greyDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

////
///

class HomeOrientationContainer extends StatefulWidget {
  final String firstText;
  final bool isPastSession;
  final String offeringName;
  final String date;
  final String time;
  final bool isStartNow;
  final String availableSlot;
  final String occupiedSlot;
  final VoidCallback? startNowOnpressed;
  final VoidCallback? cancelOnpressed;
  final VoidCallback? rescheduleOnpressed;
  const HomeOrientationContainer(
      {super.key,
      required this.firstText,
      required this.isStartNow,
      this.startNowOnpressed,
      this.cancelOnpressed,
      this.rescheduleOnpressed,
      required this.date,
      required this.time,
      required this.availableSlot,
      required this.occupiedSlot,
      required this.isPastSession,
      required this.offeringName});

  @override
  State<HomeOrientationContainer> createState() =>
      _HomeOrientationContainerState();
}

class _HomeOrientationContainerState extends State<HomeOrientationContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
        horizontal: 22.w,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    simpleText(
                      widget.firstText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    TagContainer(
                      firstLetter: widget.offeringName,
                      padding: 2,
                      fontSize: 9,
                    ),
                    height(8),
                    simpleText(
                      "Orientation Session",
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    height(8),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/calendar.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.date,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(7),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.time,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OccupiedRow(
                    text: "Occupied ",
                    number: widget.occupiedSlot,
                    color: AppColors.primaryGreen,
                    radius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                  ),
                  OccupiedRow(
                    text: "Available",
                    number: widget.availableSlot,
                    color: AppColors.primaryBlue,
                    radius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                  )
                ],
              )
            ],
          ),
          height(16),
          widget.isPastSession
              ? Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.greyDark),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: simpleText(
                    "Completed",
                    color: AppColors.greyDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: widget.isStartNow
                          ? GestureDetector(
                              onTap: widget.startNowOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.megenta,
                                ),
                                child: simpleText(
                                  "Start Now",
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.rescheduleOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.greyDark),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: simpleText(
                                  "Re-Schedule",
                                  color: AppColors.greyDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                    width(23),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.cancelOnpressed,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.greyDark),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: simpleText(
                            "Cancel",
                            color: AppColors.greyDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

///////////////////////////////////////////

class HomeGroupSessionContainer extends StatefulWidget {
  final String firstText;
  final String date;
  final String offeringName;
  final String secondText;
  final String time;
  final bool isStartNow;
  final bool isPastSession;
  final String availableSlot;
  final String occupiedSlot;
  final VoidCallback? startNowOnpressed;
  final VoidCallback? cancelOnpressed;
  final VoidCallback? rescheduleOnpressed;
  const HomeGroupSessionContainer(
      {super.key,
      required this.firstText,
      required this.isStartNow,
      this.startNowOnpressed,
      this.cancelOnpressed,
      this.rescheduleOnpressed,
      required this.availableSlot,
      required this.occupiedSlot,
      required this.date,
      required this.time,
      required this.secondText,
      required this.isPastSession,
      required this.offeringName});

  @override
  State<HomeGroupSessionContainer> createState() =>
      _HomeGroupSessionContainerState();
}

class _HomeGroupSessionContainerState extends State<HomeGroupSessionContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
        horizontal: 22.w,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    simpleText(
                      widget.firstText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    TagContainer(
                        firstLetter: widget.offeringName,
                        padding: 2,
                        fontSize: 9),
                    height(8),
                    simpleText(
                      widget.secondText,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    height(8),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/calendar.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.date,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(7),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              widget.time,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OccupiedRow(
                    text: "Occupied ",
                    number: widget.occupiedSlot,
                    color: AppColors.primaryGreen,
                    radius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                  ),
                  OccupiedRow(
                    text: "Available",
                    number: widget.availableSlot,
                    color: AppColors.primaryBlue,
                    radius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                  )
                ],
              )
            ],
          ),
          height(16),
          widget.isPastSession
              ? Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.greyDark),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: simpleText(
                    "Completed",
                    color: AppColors.greyDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: widget.isStartNow
                          ? GestureDetector(
                              onTap: widget.startNowOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.primaryBlue,
                                ),
                                child: simpleText(
                                  "Start Now",
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.rescheduleOnpressed,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.greyDark),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: simpleText(
                                  "Re-Schedule",
                                  color: AppColors.greyDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                    width(23),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.cancelOnpressed,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.greyDark),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: simpleText(
                            "Cancel",
                            color: AppColors.greyDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
