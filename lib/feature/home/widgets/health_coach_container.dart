import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/home/widgets/my_liked_widget.dart';
import 'package:zanadu_coach/feature/home/widgets/my_rating_row.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';

class HealthCoachContainer extends StatefulWidget {
  final String name;
  final String rating;
  final String likeCount;
  final String? imgUrl;
  final String session;
  const HealthCoachContainer({
    super.key,
    required this.name,
    required this.rating,
    required this.likeCount,
    required this.session,
    this.imgUrl,
  });

  @override
  State<HealthCoachContainer> createState() => _HealthCoachContainerState();
}

class _HealthCoachContainerState extends State<HealthCoachContainer> {
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
      width: 250.w,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CustomImageWidget(
              url: widget.imgUrl ?? defaultAvatar,
              myradius: 15,
              mywidth: double.infinity,
              myheight: 145.h,
            ),
          ),
          height(10),
          NewMyRatingRow(name: widget.name, rating: widget.rating),
          height(5),
          FittedBox(
              fit: BoxFit.scaleDown,
              child:
                  body2Text("Live Session ${widget.session} | Health Coach")),
          height(3),
          MyLikedByWidget(
            likeCount: widget.likeCount,
          )
        ],
      ),
    );
  }
}

class BigHealthCoachContainer extends StatelessWidget {
  const BigHealthCoachContainer({
    super.key,
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
      width: 220.w,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/icons/Rectangle 40.png",
              width: 352.w,
              height: 145.h,
              fit: BoxFit.cover,
            ),
          ),
          height(10),
          const MyRatingRow(),
          height(5),
          body2Text("Live Session 30 | Beginner"),
          height(3),
          MyLikedByWidget(
            likeCount: "30",
          )
        ],
      ),
    );
  }
}
