import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/home_chart.dart';

class UpcomingSessionContainer extends StatelessWidget {
  const UpcomingSessionContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
        horizontal: 22.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                simpleText(
                  "Yoga Lesson ",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                height(8),
                simpleText(
                  "Group Session",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                height(8),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/calendar.svg"),
                    width(2),
                    simpleText(
                      "08-09-2023  10:00AM (EST) ",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
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
                number: "40 ",
                color: AppColors.primaryGreen,
                radius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              OccupiedRow(
                text: "Available",
                number: "10",
                color: AppColors.primaryBlue,
                radius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
              )
            ],
          )
        ],
      ),
    );
  }
}
