import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';

class NotificationContainer extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String date;
  final bool isSeen;
  const NotificationContainer({
    Key? key,
    required this.title,
    required this.time,
    required this.date,
    required this.isSeen, required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 75.w,
              height: 74.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: Insets.fixedGradient(),
              ),
              child: simpleText(
                "Zh",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            width(17),
            Expanded(
              // Wrap the text with Expanded
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  simpleText(
                    title,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                  height(8),
                  simpleText(
                    description,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                  height(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/calendar.svg"),
                          width(7),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: simpleText(
                                date,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          width(6),
                          SvgPicture.asset("assets/icons/clock.svg"),
                          width(7),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: simpleText(
                                time,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textLight,
                              ),
                            ),
                          )
                        ],
                      )),
                      width(40),
                      Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSeen ? Colors.transparent : Colors.green,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
