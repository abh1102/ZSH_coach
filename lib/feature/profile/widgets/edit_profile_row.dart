import 'package:flutter/material.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/profile/widgets/profile_avatar_camera_icon.dart';
import 'package:zanadu_coach/widgets/all_button.dart';

class EditProfileRow extends StatelessWidget {
  final String? url;
  const EditProfileRow({
    super.key, this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         ProfileAvatarWithCameraIconProfile(url: url),
        width(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: simpleText(
                  myCoach?.profile?.fullName??"",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              height(2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: simpleText(
                  myCoach?.profile?.email??"",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDark,
                ),
              ),
              height(8),
              GestureDetector(
                onTap: () {
                  Routes.goTo(Screens.editProfileScreen);
                },
                child: const ColoredButtonWithoutHW(
                  isLoading: false,
                  verticalPadding: 12,
                  text: "Edit Profile",
                  size: 16,
                  weight: FontWeight.w600,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
