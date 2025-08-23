import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/see_all_screen.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/likes_converter.dart';

class GuBrowseSeeAllScreen extends StatefulWidget {
  final List<MyVideos> myVideos;
  const GuBrowseSeeAllScreen({super.key, required this.myVideos});

  @override
  State<GuBrowseSeeAllScreen> createState() => _GuBrowseSeeAllScreenState();
}

class _GuBrowseSeeAllScreenState extends State<GuBrowseSeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "Coach", secondText: "Profile"),
      body: SafeArea(
          child: widget.myVideos.isEmpty
              ? Center(
                  child: simpleText("There is no videos of coach"),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 28.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.myVideos.length,
                          itemBuilder: (context, index) {
                            var data = widget.myVideos[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: CoachVideoContainer(
                                likes: formatLikesCount(
                                    data.likes?.length ?? 0),
                                onpressed: () {
                                  Routes.goTo(Screens.myVideosDetail,
                                      arguments: data);
                                },
                                description: data.description ?? "",
                                title: data.title ?? "",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
