import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/groupsession/widgets/floating_colored_button.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/get_video_cubit/get_video_cubit.dart';
import 'package:zanadu_coach/feature/profile/widgets/lock_icon.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';

class MyVideosScreen extends StatefulWidget {
  const MyVideosScreen({super.key});

  @override
  State<MyVideosScreen> createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  late GetVideoCubit getVideoCubit;

  @override
  void initState() {
    
    super.initState();
    getVideoCubit = BlocProvider.of<GetVideoCubit>(context);
    getVideoCubit.fetchGetVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingColoredButton(
          text: "Add New Video",
          size: 16,
          weight: FontWeight.w600,
          verticalPadding: 12,
          onpressed: () {
            Routes.goTo(Screens.addNewVideo);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: const AppBarWithBackButtonWOSilver(
            firstText: "My", secondText: "Videos"),
        body: SafeArea(
          child: BlocBuilder<GetVideoCubit, GetVideoState>(
            builder: (context, state) {
              if (state is GetVideoLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is GetVideoLoadedState) {
                // Access the loaded plan from the state
                if (state.approvedVideos.isEmpty &&
                    state.unApprovedVideos.isEmpty) {
                  return Center(
                    child: simpleText(
                      "There is no video uploaded click on add new video and upload your video",
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
                                child: GestureDetector(
                                  onTap: () {
                                    Routes.goTo(Screens.myVideosDetail,
                                        arguments: state.approvedVideos[index]);
                                  },
                                  child: LockIconWidget(
                                    firstText:
                                        "${state.approvedVideos[index].title}-  ",
                                    secondText: state.approvedVideos[index]
                                            .description ??
                                        "",
                                  ),
                                ),
                              );
                            }),
                        if (state.approvedVideos.isNotEmpty) height(28),
                        if (state.unApprovedVideos.isNotEmpty)
                          simpleText("Under Review",
                              fontSize: 20, fontWeight: FontWeight.w400),
                        height(26),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.unApprovedVideos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    Routes.goTo(Screens.myVideosDetail,
                                        arguments:
                                            state.unApprovedVideos[index]);
                                  },
                                  child: UnderReviewLockIconWidget(
                                    firstText:
                                        "${state.unApprovedVideos[index].title}-  ",
                                    secondText: state.unApprovedVideos[index]
                                            .description ??
                                        "",
                                  ),
                                ),
                              );
                            }),
                        height(64),
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
        ));
  }
}
