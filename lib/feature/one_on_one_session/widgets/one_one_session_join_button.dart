import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/widgets/all_button.dart';

// ignore: must_be_immutable
class OneOneSessionJoinButton extends StatelessWidget {
  bool joinNow;
  OneOneSessionJoinButton({
    super.key,
    required this.joinNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        joinNow ? () {} : Routes.goTo(Screens.scheduleFollowUp);
      },
      child: SizedBox(
        width: 131.w,
        child: joinNow
            ? const ColoredButtonWithoutHW(  isLoading: false,
                text: "Join Now",
                size: 14,
                weight: FontWeight.w600,
                verticalPadding: 7,
              )
            : const SimpleWhiteTextButton(
                text: "Re-Schedule",
                size: 14,
                weight: FontWeight.w600,
                verticalPadding: 7,
              ),
      ),
    );
  }
}
