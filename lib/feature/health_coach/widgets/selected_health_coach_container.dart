import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/my_liked_widget.dart';
import 'package:zanadu_coach/feature/home/widgets/my_rating_row.dart';

class SelectedHealthCoachContainer extends StatelessWidget {
  final VoidCallback? onpressed;
  const SelectedHealthCoachContainer({
    super.key, this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF25D366).withOpacity(0.2), // #25D366
            const Color(0xFF03C0FF).withOpacity(0.2), // #03C0FF
          ],
          stops: const [0.0507, 1.1795],
          transform: const GradientRotation(2.44), // 140 degrees in radians
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/Rectangle 40.png",
            width: double.infinity,
            height: 145.h,
            fit: BoxFit.cover,
          ),
          height(10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyRatingRow(),
                    height(5),
                    body2Text("5 Year of Experience"),
                    height(3),
                    MyLikedByWidget(likeCount: "20"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onpressed,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 11.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyDark,
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: simpleText("Change Coach",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
