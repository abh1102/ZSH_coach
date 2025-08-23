import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/lock_icon.dart';

class LockIconWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  const LockIconWidget({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: Insets.fixedGradient(
          opacity: 0.1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 21.w,
          vertical: 21.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: firstText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: secondText,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            width(10),
            const PlayIcon()
          ],
        ),
      ),
    );
  }
}

class UnderReviewLockIconWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  const UnderReviewLockIconWidget({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 21.w,
          vertical: 21.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: firstText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: secondText,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            width(10),
            SvgPicture.asset(
              "assets/icons/under_review.svg",
            )
          ],
        ),
      ),
    );
  }
}

class WithoutLockIconWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  const WithoutLockIconWidget({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: Insets.fixedGradient(
          opacity: 0.1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 21.w,
          vertical: 21.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: firstText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: secondText,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
