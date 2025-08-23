import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class WhiteBgBlackTextButton extends StatelessWidget {
  final VoidCallback? onpressed;
  final String text;
  const WhiteBgBlackTextButton({
    super.key,
    required this.text,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 7.h,
          horizontal: 53.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: simpleText(
          text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class WhiteBgBlackTextButtonWOHW extends StatelessWidget {
  final VoidCallback? onpressed;
  final String text;
  final double size;
  final FontWeight weight;
  final double vertialPadding;
  const WhiteBgBlackTextButtonWOHW({
    super.key,
    required this.text,
    this.onpressed,
    required this.size,
    required this.weight,
    required this.vertialPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: vertialPadding.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: simpleText(
          text,
          fontSize: size,
          fontWeight: weight,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
