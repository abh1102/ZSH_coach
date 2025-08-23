import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';

class ProfileViewFirstContainer extends StatefulWidget {
  final String? imgUrl;
  final String name;
  final String date;
  const ProfileViewFirstContainer({
    super.key,
    required this.name,
    required this.date,
    this.imgUrl,
  });

  @override
  State<ProfileViewFirstContainer> createState() =>
      _ProfileViewFirstContainerState();
}

class _ProfileViewFirstContainerState extends State<ProfileViewFirstContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 13.h,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryGreen,
              ),
              shape: BoxShape.circle,
            ),
            child: CircularCustomImageWidget(
              url: widget.imgUrl ?? defaultAvatar,
              myheight: 90,
              mywidth: 90,
            ),
          ),
          width(25.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading2Text(widget.name),
                height(10),
                Row(
                  children: [
                    Flexible(child: body2Text("Enrolled Since")),
                    width(4),
                    Flexible(
                      child: simpleText(
                        widget.date,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HealthCoachProfileViewContainer extends StatefulWidget {
  final String name;
  final String? imgUrl;
  const HealthCoachProfileViewContainer({
    super.key,
    required this.name,
    this.imgUrl,
  });

  @override
  State<HealthCoachProfileViewContainer> createState() =>
      _HealthCoachProfileViewContainerState();
}

class _HealthCoachProfileViewContainerState
    extends State<HealthCoachProfileViewContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE8FAF5),
          borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 13.h,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryBlue,
                )),
            child: CircularCustomImageWidget(
              url: widget.imgUrl ?? defaultAvatar,
              myheight: 48,
              mywidth: 48,
            ),
          ),
          width(25.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    widget.name,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
