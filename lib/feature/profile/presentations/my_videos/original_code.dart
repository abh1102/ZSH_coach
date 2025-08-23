import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';


class MyVideosDetailScreen extends StatefulWidget {
  const MyVideosDetailScreen({super.key});

  @override
  State<MyVideosDetailScreen> createState() => _MyVideosDetailScreenState();
}

class _MyVideosDetailScreenState extends State<MyVideosDetailScreen> {
   late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://drive.google.com/uc?id=1XGQ3CmoXY_qiLoVnoEuMrq96ojRnwFki"));
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "Video", secondText: "Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 28.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
                height(16),
                simpleText(
                  "Yoga health coach (Full Video)",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                height(16),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: 15,
                    ),
                    width(8),
                    Flexible(
                      child: simpleText(
                        "213k",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    width(16),
                    Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 15,
                    ),
                    width(8),
                    Flexible(
                      child: simpleText(
                        "213k",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                height(16),
                simpleText(
                  "Description",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                height(8),
                simpleText(
                  "Anna is an extremely talented Naturopath and Health Coach who has over 20+ year of experience in coaching and guiding people towards an overall improvement in wellness and health. She holds the BNYS degree from SDM College of Naturopathy in India. She is also a talented chiropractor who helps people in extreme pain.",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
