import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';


class IconTimeCalendarRow extends StatelessWidget {
  final String svg;
  final String text;
  const IconTimeCalendarRow({
    super.key,
    required this.svg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(svg),
        width(2),
        FittedBox(fit: BoxFit.scaleDown,
          child: simpleText(
            text,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textLight,
          ),
        )
      ],
    );
  }
}
