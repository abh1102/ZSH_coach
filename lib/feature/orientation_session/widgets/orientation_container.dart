import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/home_chart.dart';
import 'package:zanadu_coach/widgets/tag_container.dart';

class OrientationContainer extends StatefulWidget {
  final String firstText;
  final bool? isStartNow;
  final String occupiedSlot;
  final String availableSlot;
  final String offeringName;
  final String date;
  final VoidCallback? startNowOnpressed;
  final VoidCallback? cancelOnpressed;
  final VoidCallback? rescheduleOnpressed;
  const OrientationContainer(
      {super.key,
      required this.firstText,
      this.isStartNow,
      this.startNowOnpressed,
      this.cancelOnpressed,
      this.rescheduleOnpressed,
      required this.date,
      required this.occupiedSlot,
      required this.availableSlot,
      required this.offeringName});

  @override
  State<OrientationContainer> createState() => _OrientationContainerState();
}

class _OrientationContainerState extends State<OrientationContainer> {
  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(widget.date);

    // Convert to local time zone
    DateTime localStartDate = startDate.toLocal(); // Adjust to your time zone

    // Formatting date and time
    String formattedDate = DateFormat('MM-dd-yyyy').format(localStartDate);
    String formattedTime = DateFormat.jm().format(localStartDate);
    Duration difference = localStartDate.difference(DateTime.now());

    // Check if the difference is less than 30 minutes
    bool isStartNow = difference.inMinutes < 30;
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
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/calendar.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              formattedDate,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(8),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/clock.svg"),
                        width(7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              formattedTime,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
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
          Row(
            children: [
              Expanded(
                child: isStartNow
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
