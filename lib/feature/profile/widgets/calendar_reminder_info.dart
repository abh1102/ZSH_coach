import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';

// ignore: must_be_immutable
class CalendarReminderInfo extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String lessonName;
  bool isSwitched;
  CalendarReminderInfo({
    super.key,
    required this.isSwitched,
    required this.title,
    required this.date,
    required this.time,
    required this.lessonName,
  });

  @override
  State<CalendarReminderInfo> createState() => _CalendarReminderInfoState();
}

class _CalendarReminderInfoState extends State<CalendarReminderInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        gradient: Insets.fixedGradient(
          opacity: 0.25,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                simpleText(
                  widget.title,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: Color(0xFF03C0FF),
                    trackColor: AppColors.greyDark,
                    value: widget.isSwitched,
                    onChanged: (value) {
                      setState(() {
                        widget.isSwitched = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            height(8),
            Row(
              children: [
                SvgPicture.asset("assets/icons/calendar.svg"),
                width(7),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: simpleText(
                      widget.date,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                width(7),
                SvgPicture.asset("assets/icons/clock.svg"),
                width(7),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: simpleText(
                      widget.time,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                  ),
                )
              ],
            ),
            height(8),
            body2Text(widget.lessonName)
          ],
        ),
      ),
    );
  }
}
