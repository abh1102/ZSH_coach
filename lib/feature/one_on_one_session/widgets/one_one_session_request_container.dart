import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/tag_container.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

class OneOneSessionRequestContainer extends StatefulWidget {
  final String date;
  final String name;
  final String? imgUrl;
  final String offeringName;
  final VoidCallback? onpressed;
  final VoidCallback? accept;
  final VoidCallback? decline;
  final String time;
  const OneOneSessionRequestContainer({
    super.key,
    required this.date,
    required this.name,
    this.accept,
    this.decline,
    required this.time,
    this.onpressed,
    this.imgUrl,
    required this.offeringName,
  });

  @override
  State<OneOneSessionRequestContainer> createState() =>
      _OneOneSessionRequestContainerState();
}

class _OneOneSessionRequestContainerState
    extends State<OneOneSessionRequestContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onpressed,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
          vertical: 13.h,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              foregroundImage: NetworkImage(widget.imgUrl ?? defaultAvatar),
              backgroundImage: NetworkImage(defaultAvatar),
            ),
            width(25.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  body1Text(
                    widget.name,
                  ),
                  TagContainer(
                      firstLetter: widget.offeringName,
                      padding: 2,
                      fontSize: 9),
                  height(12),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/calendar.svg"),
                      width(7),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: simpleText(
                            widget.date,
                            fontSize: 12,
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
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                        ),
                      )
                    ],
                  ),
                  height(12),
                  Row(
                    children: [
                      Expanded(
                        child: ColoredButtonWithoutHW(
                          isLoading: false,
                          onpressed: widget.accept,
                          text: "Accept",
                          size: 13,
                          weight: FontWeight.w400,
                          verticalPadding: 6,
                        ),
                      ),
                      width(9),
                      Expanded(
                        child: WhiteBgBlackTextButtonWOHW(
                          onpressed: widget.decline,
                          text: "Decline",
                          size: 13,
                          weight: FontWeight.w400,
                          vertialPadding: 6,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
