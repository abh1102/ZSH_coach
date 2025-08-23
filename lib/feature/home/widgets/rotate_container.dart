import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/homescreen_first_widget.dart';

class RotateContainerTwo extends StatelessWidget {
  const RotateContainerTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formattedRating =
        (double.tryParse(myCoach?.coachInfo?[0].rating ?? "0.0"))
                ?.toStringAsFixed(1) ??
            "";
    return Container(
      alignment: Alignment.centerLeft,
      height: 100.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 14.w,
      ),
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/star_icon.svg"),
                width(10),
                simpleText(
                  "My Rating",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              simpleText(
                formattedRating,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              simpleText(
                "out of 5",
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textLight,
              )
            ],
          )
        ],
      ),
    );
  }
}

class RotateContainerOne extends StatelessWidget {
  const RotateContainerOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 100.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 14.w,
        ),
        decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(10)),
        child: const HomeScreenFirstWidget());
  }
}
