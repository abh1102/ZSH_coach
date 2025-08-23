import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:zanadu_coach/feature/home/widgets/rotate_container.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onpressed;
  const CustomAppBar({super.key, this.onpressed});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(175.h);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (!_disposed) {
          setState(() {});
        }
      });

    // Start a timer to flip every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_disposed) {
        _flipCard();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true; // Set a flag to indicate disposal
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!_disposed && _controller.status != AnimationStatus.forward) {
      if (_isFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFront = !_isFront;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Routes.goTo(Screens.profile);
                    },
                    child: Container(
                        height: 49.h,
                        width: 49.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryGreen,
                          ),
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: CustomImageWidget(
                          url: myCoach?.profile?.image ?? defaultAvatar,
                          myradius: 12,
                          myheight: 49,
                          mywidth: 49,
                        )),
                  ), // First Icon Widget
                  width(16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onpressed,
                      child: Container(
                        height: 49.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryGreen),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            width(10.0),
                            SvgPicture.asset(
                              "assets/icons/search.svg",
                              width: 21.w,
                              height: 21.h,
                            ), // Search Icon
                            width(10.0),
                            Expanded(
                              child: TextField(
                                enabled: false,
                                style: GoogleFonts.poppins(
                                  color: AppColors.textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Search User",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  width(16),
                  GestureDetector(
                    onTap: () {
                      Routes.goTo(Screens.editProfileNotificationScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 11.h,
                      ),
                      height: 49.h,
                      width: 49.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryGreen,
                        ),
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/icon _notification_.svg",
                      ),
                    ),
                  ),
                ],
              ),
              height(15),
              if (myCoach?.isApproved == true)
                GestureDetector(
                  onTap: _flipCard,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9.w),
                      child: Transform(
                        transform:
                            Matrix4.rotationX(_animation.value * math.pi),
                        alignment: Alignment.center,
                        child: _isFront ? _buildFront() : _buildBack(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return const RotateContainerOne();
  }

  Widget _buildBack() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(math.pi),
      child: const RotateContainerTwo(),
    );
  }
}

class VideoCallingAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget callWidget;
  final VoidCallback? onpressed;
  const VideoCallingAppBar(
      {super.key, required this.callWidget, this.onpressed});

  @override
  State<VideoCallingAppBar> createState() => _VideoCallingAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}

class _VideoCallingAppBarState extends State<VideoCallingAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        elevation: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    "Video Call",
                    color: AppColors.textDark,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ), // First Icon Widget

              widget.callWidget,

              IconButton(
                onPressed: widget.onpressed,
                icon: Icon(
                  Icons.flip_camera_ios,
                  color: AppColors.textDark,
                  size: 20.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarWithBackButtonWOSilverCP extends StatelessWidget
    implements PreferredSizeWidget {
  final String firstText;
  final String secondText;

  const AppBarWithBackButtonWOSilverCP({
    Key? key,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackArrow(),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 10.h, bottom: 6.h, left: 72.w),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  firstText,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  secondText,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
