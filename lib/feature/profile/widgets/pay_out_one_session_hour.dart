import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';

class PayOutOneSessionHour extends StatelessWidget {
  final String svg;
  final String text;
  final String secondText;
  final Color color;
  const PayOutOneSessionHour({
    super.key,
    required this.svg,
    required this.text,
    required this.secondText, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffE8FAF7),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 14.w,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 11.h,
              horizontal: 11.w,
            ),
            child: ColorFiltered(
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                child: SvgPicture.asset(
                  svg,
                )),
          ),
          width(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(4),
                simpleText(
                  text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                height(3),
                simpleText(
                  secondText,
                  align: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
