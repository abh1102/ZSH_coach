import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';



class SessionScreenButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onpressed;
  const SessionScreenButton({
    super.key,
    required this.text,
    required this.color,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: simpleText(
          text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}