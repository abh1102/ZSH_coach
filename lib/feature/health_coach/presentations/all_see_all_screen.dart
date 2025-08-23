import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/all_health_coach_model.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/get_video_cubit/get_video_cubit.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/see_all_screen.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/likes_converter.dart';

class AllBrowseSeeAllScreen extends StatefulWidget {
  final AllHealthCoachesModel healthCoach;
  const AllBrowseSeeAllScreen({super.key, required this.healthCoach});

  @override
  State<AllBrowseSeeAllScreen> createState() => _AllBrowseSeeAllScreenState();
}

class _AllBrowseSeeAllScreenState extends State<AllBrowseSeeAllScreen> {
  late GetVideoCubit getVideoCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getVideoCubit = BlocProvider.of<GetVideoCubit>(context);

    getVideoCubit.fetchCoachGetVideo(widget.healthCoach.userId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButtonWOSilver(
          firstText: "",
          secondText: widget.healthCoach.profile?.fullName ?? ""),
      body: SafeArea(
        child: BlocBuilder<GetVideoCubit, GetVideoState>(
          builder: (context, state) {
            if (state is GetVideoLoadingState) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is GetCoachVideoLoadedState) {
              // Access the loaded plan from the state
              if (state.approvedVideos.isEmpty) {
                return Center(
                  child: simpleText(
                    "There is no video uploaded.",
                    fontSize: 18,
                    align: TextAlign.center,
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 28.h,
                    horizontal: 28.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.approvedVideos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CoachVideoContainer(
                                likes: formatLikesCount(
                                    state.approvedVideos[index].likes?.length ??
                                        0),
                                imgUrl:
                                    state.approvedVideos[index].thumbnailImage,
                                onpressed: () {
                                  Routes.goTo(Screens.myVideosDetail,
                                      arguments: state.approvedVideos[index]);
                                },
                                description:
                                    state.approvedVideos[index].description ??
                                        "",
                                title: state.approvedVideos[index].title ?? "",
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
            } else if (state is GetVideoErrorState) {
              return Text('Error: ${state.error}');
            } else {
              return const Text('Something is wrong');
            }
          },
        ),
      ),
    );
  }
}
