import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/data/model/signed_url_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/widgets/back_arrow_appbar.dart';

class SignUpScreenFirst extends StatefulWidget {
  const SignUpScreenFirst({super.key});

  @override
  State<SignUpScreenFirst> createState() => _SignUpScreenFirstState();
}

class _SignUpScreenFirstState extends State<SignUpScreenFirst> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool skipButton = false;
  bool controllersDisposed = false;

  String? url;

  LoginRepository repo = LoginRepository();
  Future<void> _fetchProfileTemplateUrl() async {
    try {
      // Call the getSignedUrl function from the LoginCubit
      SignedUrlModel model = await repo.getSignedUrlSignUp();

      if (mounted) {
        setState(() {
          url = model.signedUrl;
          _isLoading = false; // Set loading state to false
        });

        // Initialize VideoPlayerController and ChewieController only when url is available

        _controller = VideoPlayerController.networkUrl(Uri.parse(url ?? ""));
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: 16 / 9,
          autoPlay: true,
          fullScreenByDefault: false,
          
          looping: true,
          autoInitialize: true,
        );

        setState(() {
          skipButton = true;
        });
      }
    } catch (e) {
      showSnackBar(e.toString());
      print("Error fetching signed URL: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchProfileTemplateUrl();
    // Simulate the GIF completion after some time (you can replace this with your actual GIF completion logic).
    // Future.delayed(Duration(seconds: 43), () {
    //   if (_isMounted && !skipPressed) {
    //     setState(() {
    //       gifCompleted = true;
    //     });

    //     // Navigate to the new screen with a fade-in effect.
    //     Navigator.of(context).pushReplacement(
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation, secondaryAnimation) {
    //           return SignUpSecondScreen();
    //         },
    //         transitionsBuilder:
    //             (context, animation, secondaryAnimation, child) {
    //           const begin = 0.0;
    //           const end = 1.0;
    //           var tween = Tween(begin: begin, end: end);
    //           var opacityAnimation = animation.drive(tween);
    //           return FadeTransition(
    //             opacity: opacityAnimation,
    //             child: child,
    //           );
    //         },
    //         transitionDuration: Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    //_isLoading = true;

    if (_chewieController != null) {
      _chewieController?.pause();

      _chewieController?.dispose();
    }

    if (_controller != null) {
      _controller?.pause();
      _controller?.dispose();
    }

    controllersDisposed = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backArrowAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 28.w,
          vertical: 28.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(
                        controller: _chewieController!,
                      ),
                    ),
                  ),
            const Spacer(),
            if (skipButton)
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                      _chewieController?.dispose();
                      _chewieController = null;
                      _controller?.dispose();
                      _controller = null;
                    });
                    //await Future.delayed(Duration(seconds: 3));
                    Routes.goToReplacement(Screens.signupscreensecond);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: simpleText(
                      "Skip",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
