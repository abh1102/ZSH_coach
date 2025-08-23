import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

void welcomeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 36.h,
              left: 18.w,
              right: 18.w,
              top: 18.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/Group 1171275170.svg", // Replace with your SVG file
                  width: 194.w,
                  height: 192.h,
                ),
                height(15),
                Center(
                    child: simpleText("Congratulations",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    "Welcome to Zanadu Health. Gateway to your Wellness, Health & Happiness.",
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void planInformationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 36.h,
              left: 18.w,
              right: 18.w,
              top: 18.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),
                heading1Text("BASIC", color: Colors.white),
                height(10),
                simpleText(
                  "Perfect For Beginners",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                height(10),
                simpleText(
                  "120/year",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                height(3),
                body1Text(
                  "14-day free trial.",
                  color: Colors.white,
                ),
                height(26),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    horizontal: 53.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: simpleText(
                    "Start Trial",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                height(20),
                const Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                height(20),
                Center(
                  child: const CheckIconTextRow(
                    text: "Full Length lessons",
                  ),
                ),
                height(6),
                const CheckIconTextRow(
                  text: "FGroup Sessions",
                ),
                height(6),
                const CheckIconTextRow(
                  text: "Health Coach",
                ),
                height(6),
                const CheckIconTextRow(
                  text: "Speciality Coaches",
                ),
                height(6)
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CheckIconTextRow extends StatelessWidget {
  final String text;

  const CheckIconTextRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.2), // Adjust as needed
        1: FlexColumnWidth(0.8), // Adjust as needed
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/check_.svg",
                  width: 15.0, // Adjust the size as needed
                  height: 15.0,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 16.0), // Adjust the spacing as needed
                child: body1Text(
                  text,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void giveRatingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 36.h,
              left: 18.w,
              right: 18.w,
              top: 18.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),

                height(15),
                Center(
                    child: simpleText("How are we doing? ",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    "Love to get your feedback so that we can improve.",
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(28),
                body1Text(
                  "Rate your experience ",
                  color: Colors.white,
                ),
                height(7),
                RatingBar.builder(
                  itemCount: 4,
                  initialRating: 3.5, // Initial rating value
                  minRating: 1, // Minimum rating value
                  maxRating: 5, // Maximum rating value
                  itemSize: 15.0, // Size of each star
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.white, // Star color when filled
                  ),
                  onRatingUpdate: (rating) {
                    // Handle when the rating changes
                    // ignore: avoid_print
                    print("Rating: $rating");
                  },
                ),
                height(35),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tell Us What You Think",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ),
                height(64),
                const WhiteBgBlackTextButton(
                  text: "Submit",
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void discoveryFormDialog(BuildContext context, String svg, String title,
    String description, double mywidth, double myheight) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 36.h,
              left: 18.w,
              right: 18.w,
              top: 18.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    svg,
                    width: mywidth,
                    height: myheight,
                  ),
                ),
                height(15),
                Center(
                    child: simpleText(title,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    description,
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void oneTextDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          height: 430.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
              child: simpleText("Waiting for ZH Admin Approval ",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      );
    },
  );
}

void onlyTextWithCutIcon(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 350.w,
          // height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25D366),
                Color(0xFF03C0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button (SVG picture)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      "assets/icons/Vector.svg", // Replace with your SVG file
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
                height(16),
                Center(
                  child: simpleText(
                    text,
                    align: TextAlign.center,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
