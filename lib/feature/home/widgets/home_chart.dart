import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';


class OccupiedRow extends StatelessWidget {
  final BorderRadius radius;
  final String text;
  final String number;
  final Color color;
  const OccupiedRow({
    super.key,
    required this.text,
    required this.number,
    required this.color,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        body2Text(text),
        width(5),
        Container(
          alignment: Alignment.center,
          width: 39.w,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: radius,
          ),
          child: Center(
            child: simpleText(
              number,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        )
      ],
    );
  }
}