import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/profile/widgets/progress_indicator_container.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';

class MyZhScoreCardScreen extends StatefulWidget {
  const MyZhScoreCardScreen({super.key});

  @override
  State<MyZhScoreCardScreen> createState() => _MyZhScoreCardScreenState();
}

class _MyZhScoreCardScreenState extends State<MyZhScoreCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "My Zh Score", secondText: "Card"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.w,
            vertical: 28.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  12,
                ),
                child: Image.asset(
                  "assets/images/image 4.png",
                  fit: BoxFit.cover,
                  width: 371.w,
                  height: 200.h,
                ),
              ),
              height(20),
              Row(
                children: [
                  simpleText(
                    "Anna Juliane",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF495057),
                  ),
                  width(10),
                  Expanded(
                    child: RatingBar.builder(
                      itemCount: 4,
                      initialRating: 3.5, // Initial rating value
                      minRating: 1, // Minimum rating value
                      maxRating: 5, // Maximum rating value
                      itemSize: 15.0, // Size of each star
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.black, // Star color when filled
                      ),
                      onRatingUpdate: (rating) {
                        // Handle when the rating changes
                        // ignore: avoid_print
                        print("Rating: $rating");
                      },
                    ),
                  ),
                ],
              ),
              height(13),
              body1Text(
                "5 Years Experience",
                color: AppColors.greyDark,
              ),
              height(30),
              const ProgressIndicatorContainer(
                text: 'Physical Health',
                maxProgress: 10,
                progress: 4,
              ),
              height(28),
              const ProgressIndicatorContainer(
                text: 'Mental Health',
                maxProgress: 10,
                progress: 8,
              ),
              height(28),
              const ProgressIndicatorContainer(
                text: 'MindFullnes',
                maxProgress: 10,
                progress: 7,
              ),
              height(28),
            ],
          ),
        ),
      )),
    );
  }
}
