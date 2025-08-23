import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class BestHealthCoachWidget extends StatelessWidget {
  final String text;

  const BestHealthCoachWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: simpleText(
            text,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(right: 22.w,),
          child: simpleText(
            "Slots",
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        )
      ],
    );
  }
}



class AnalyticLastContainerText extends StatelessWidget {
  final String text;

  const AnalyticLastContainerText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: simpleText(
            text,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
       
      ],
    );
  }
}
