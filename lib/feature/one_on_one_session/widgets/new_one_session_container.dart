import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';
import 'package:zanadu_coach/widgets/tag_container.dart';

class NewOneSessionContainer extends StatefulWidget {
  final String firstText;
  final String? imgUrl;
  final bool? isStartNow;
  final String title;
  final String offeringName;
  final String date;

  final VoidCallback? startNowOnpressed;
  final VoidCallback? cancelOnpressed;
  final VoidCallback? rescheduleOnpressed;
  const NewOneSessionContainer({
    super.key,
    required this.firstText,
    this.isStartNow,
    this.startNowOnpressed,
    this.cancelOnpressed,
    this.rescheduleOnpressed,
    required this.date,
    required this.title,
    this.imgUrl,
    required this.offeringName,
  });

  @override
  State<NewOneSessionContainer> createState() => _NewOneSessionContainerState();
}

class _NewOneSessionContainerState extends State<NewOneSessionContainer> {
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
                      fontSize: 9,
                    ),
                    height(8),
                    simpleText(
                      widget.title,
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
                              myformattedDate(widget.date),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(8),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              myformattedTime(widget.date),
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
                        url: widget.imgUrl ?? defaultAvatar,
                        myheight: 70,
                        mywidth: 70,
                      ))
                ],
              )
            ],
          ),
          height(16),
          Row(
            children: [
              Expanded(
                child: getDifferenceBool(widget.date)
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

class NewOneSessionRequestedContainer extends StatefulWidget {
  final String firstText;
  final String? imgUrl;

  final String title;
  final String offeringName;
  final String date;

  const NewOneSessionRequestedContainer({
    super.key,
    required this.firstText,
    required this.date,
    required this.title,
    this.imgUrl,
    required this.offeringName,
  });

  @override
  State<NewOneSessionRequestedContainer> createState() =>
      _NewOneSessionRequestedContainerState();
}

class _NewOneSessionRequestedContainerState
    extends State<NewOneSessionRequestedContainer> {
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
                      fontSize: 9,
                    ),
                    height(8),
                    simpleText(
                      widget.title,
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
                              myformattedDate(widget.date),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(8),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              myformattedTime(widget.date),
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
                        url: widget.imgUrl ?? defaultAvatar,
                        myheight: 70,
                        mywidth: 70,
                      ))
                ],
              )
            ],
          ),
          height(16),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.greyDark),
              borderRadius: BorderRadius.circular(50),
            ),
            child: simpleText(
              "Requested",
              color: AppColors.secondaryRedColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class NewOneSessionRejectedContainer extends StatefulWidget {
  final String firstText;
  final String? imgUrl;

  final String title;
  final String offeringName;
  final String date;

  const NewOneSessionRejectedContainer({
    super.key,
    required this.firstText,
    required this.date,
    required this.title,
    this.imgUrl,
    required this.offeringName,
  });

  @override
  State<NewOneSessionRejectedContainer> createState() =>
      _NewOneSessionRejectedContainerState();
}

class _NewOneSessionRejectedContainerState
    extends State<NewOneSessionRejectedContainer> {
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
                      fontSize: 9,
                    ),
                    height(8),
                    simpleText(
                      widget.title,
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
                              myformattedDate(widget.date),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        width(8),
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              myformattedTime(widget.date),
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
                        url: widget.imgUrl ?? defaultAvatar,
                        myheight: 70,
                        mywidth: 70,
                      ))
                ],
              )
            ],
          ),
          height(16),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.greyDark),
              borderRadius: BorderRadius.circular(50),
            ),
            child: simpleText(
              "Rejected",
              color: AppColors.secondaryRedColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
