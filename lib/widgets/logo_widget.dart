import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';

class LogoWidget extends StatelessWidget {
  final String text;
  const LogoWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.textLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(text),
      ),
    );
  }
}

class AppleLogoWidget extends StatelessWidget {
  final String text;
  const AppleLogoWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 60.w,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.textLight,
        ),
      ),
      child: const Icon(
        Icons.apple,
        size: 43,
      ),
    );
  }
}
