import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';


class HomeScreenFirstWidget extends StatelessWidget {
  const HomeScreenFirstWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              simpleText(
                "Enjoy an Awesome",
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              height(3),
              simpleText(
                "Coaching Experience",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 11.w,
            vertical: 11.h,
          ),
          height: 49.h,
          width: 49.w,
         
          child: SvgPicture.asset(
            "assets/icons/Group (6).svg",
            fit: BoxFit.cover,
          ),
        ),
        
      ],
    );
  }
}
