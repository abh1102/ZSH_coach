import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/all_health_coach_model.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/see_all_screen.dart';
import 'package:zanadu_coach/feature/home/widgets/my_rating_row.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';
import 'package:zanadu_coach/widgets/likes_converter.dart';

class HealthCoachDetailScreen extends StatefulWidget {
  final AllHealthCoachesModel healthCoach;
  const HealthCoachDetailScreen({super.key, required this.healthCoach});

  @override
  State<HealthCoachDetailScreen> createState() =>
      _HealthCoachDetailScreenState();
}

class _HealthCoachDetailScreenState extends State<HealthCoachDetailScreen> {
  MyVideos? demoVideo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.healthCoach.coachInfo != null &&
        widget.healthCoach.coachInfo!.myVideos != null &&
        widget.healthCoach.coachInfo!.myVideos!.isNotEmpty) {
      // Check if there is at least one video with videotype 'DEMO'
      if (widget.healthCoach.coachInfo!.myVideos!
          .any((video) => video.videoType == 'DEMO')) {
        // Find the first demo video from the list
        demoVideo = widget.healthCoach.coachInfo!.myVideos!
            .firstWhere((video) => video.videoType == 'DEMO');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "Health", secondText: "Coach"),
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
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CustomImageWidget(
                  isContain: false,
                  url: widget.healthCoach.profile?.image ?? defaultAvatar,
                  myradius: 12,
                  mywidth: double.infinity,
                  myheight: 226.h,
                ),
              ),
              height(20),
              NewMyRatingRow(
                name: widget.healthCoach.profile?.fullName ?? "",
                rating: widget.healthCoach.coachInfo?.rating == null
                    ? "0"
                    : widget.healthCoach.coachInfo!.rating.toString(),
                fontSize: 18,
                weight: FontWeight.w700,
                starSize: 15,
              ),
              height(8),
              simpleText(
                "Experience: ${widget.healthCoach.profile?.experience == null ? "0" : widget.healthCoach.profile?.experience ?? ""} Years+",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              height(8),
              simpleText(
                widget.healthCoach.profile?.designation ?? "",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              height(16),
              body2Text("Description "),
              height(5),
              body2Text(
                widget.healthCoach.profile?.bio ?? "",
                color: AppColors.textLight,
              ),
              if (widget.healthCoach.coachInfo?.myVideos != null &&
                  widget.healthCoach.coachInfo!.myVideos!.isNotEmpty &&
                  demoVideo != null)
                height(15),
              if (widget.healthCoach.coachInfo?.myVideos != null &&
                  widget.healthCoach.coachInfo!.myVideos!.isNotEmpty &&
                  demoVideo != null)
                CoachVideoContainer(
                  likes: formatLikesCount(demoVideo?.likes?.length ?? 0),
                  imgUrl: demoVideo?.thumbnailImage,
                  onpressed: () {
                    Routes.goTo(Screens.keymyVideosDetail,
                        arguments: demoVideo);
                  },
                  description: demoVideo?.description ?? "",
                  title: demoVideo?.title ?? "",
                ),
              height(64),
              ColoredButtonWithoutHW(
                isLoading: false,
                onpressed: () {
                  Routes.goTo(Screens.allseeAll, arguments: widget.healthCoach);
                },
                verticalPadding: 16,
                text: "See All Videos",
                size: 16,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
