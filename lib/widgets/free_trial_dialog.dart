import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/widgets/white_border_white_text_button.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

void freeTrialDialog(BuildContext context) {
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

                height(15),
                Center(
                    child: simpleText("14-day’s free trial",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    "Your 14-Day free trial ends tomorrow you will be charged \$120/year. Do you wish continue or cancel your plan?",
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(64),
                const WhiteBgBlackTextButton(
                  text: "Continue",
                ),
                height(24),
                const WhiteBorderWhiteTextButton(
                  text: "Cancel",
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void upgradeDialog(BuildContext context) {
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

                height(15),
                Center(
                    child: simpleText("Upgrade Plan",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    "You are currently on the Basic plan please upgrade to Basic Plus or Premium plan to enable one on one sessions",
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(64),
                const WhiteBgBlackTextButton(
                  text: "Upgrade",
                ),
                height(24),
                const WhiteBorderWhiteTextButton(text: "Go back")
              ],
            ),
          ),
        ),
      );
    },
  );
}

void simpleDialog(
  BuildContext context,
  String heading,
  String text,
  String firstButton,
  String secondButton,
  VoidCallback? onpressed,
) {
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

                height(15),
                Center(
                    child: simpleText(heading,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    text,
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(64),
                GestureDetector(
                  onTap: onpressed,
                  child: WhiteBgBlackTextButton(
                    text: firstButton,
                  ),
                ),
                height(24),
                WhiteBorderWhiteTextButton(
                  text: secondButton,
                  onpressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void simpleDialogWithOneButton(
  BuildContext context,
  String heading,
  String text,
  String firstButton,
  VoidCallback? onpressed,
) {
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

                height(15),
                Center(
                    child: simpleText(heading,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                height(16),
                Center(
                  child: body1Text(
                    text,
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
                height(64),
                GestureDetector(
                  onTap: onpressed,
                  child: WhiteBgBlackTextButton(
                    text: firstButton,
                  ),
                ),
                height(24),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class SwitchRoleDialog extends StatefulWidget {
  final VoidCallback? onpressed;
  const SwitchRoleDialog({
    Key? key,
    this.onpressed,
  }) : super(key: key);

  @override
  _SwitchRoleDialogState createState() => _SwitchRoleDialogState();
}

class _SwitchRoleDialogState extends State<SwitchRoleDialog> {
  bool isOneCoach = true; // Initial role

  List<Health?> profiles = [];
  String primaryRole = "";
  String nonPrimaryRole = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchProfile();
  }

  void switchProfile() {
    if (myCoach?.profile?.areaOfSpecialization?.health?.id != null) {
      profiles.add((myCoach?.profile?.areaOfSpecialization?.health));
      if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty == true) {
        profiles.add((myCoach?.profile?.areaOfSpecialization?.special?[0]));
      }
    } else {
      if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty == true) {
        profiles.addAll(myCoach?.profile?.areaOfSpecialization?.special ?? []);
      }
    }

    if (profiles.length == 2) {
      setRoles();
      if (mounted) {
        setState(() {
          isOneCoach = false;
        });
      }
    } else {
      setRoles();
    }
  }

  void setRoles() {
    String primaryOfferingId = myCoach?.profile?.primaryOfferingId ?? "";

    if (profiles.length == 1) {
      if (mounted) {
        setState(() {
          primaryRole = profiles[0]?.name ?? "";
          print(primaryRole);
        });
      }
    } else {
      for (Health? profile in profiles) {
        if (profile?.id == primaryOfferingId) {
          if (mounted) {
            setState(() {
              primaryRole = profile?.name ?? "";
            });
          }
        } else {
          if (mounted) {
            setState(() {
              nonPrimaryRole = profile?.name ?? "";
            });
          }
          // Handle non-primary role if needed
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/Vector.svg", // Replace with your SVG file
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
              ),
              height(5),
              isOneCoach
                  ? Column(
                      children: [
                        simpleText(
                          "Active Role",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                        simpleText(
                          primaryRole,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                        height(16),
                        simpleText(
                          "You have Only One Role",
                          color: AppColors.white,
                          align: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            simpleText(
                              "Active Role",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                            ),
                            simpleText(
                              primaryRole,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                        height(16),
                        Center(
                          child: SvgPicture.asset(
                            "assets/icons/switch_white.svg",
                          ),
                        ),
                        height(16),
                        simpleText(
                          nonPrimaryRole,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyLight,
                        ),
                        height(32),
                        Center(
                          child: GestureDetector(
                            onTap: widget.onpressed,
                            child: const WhiteBgBlackTextButton(
                              text: "Switch Profile",
                            ),
                          ),
                        ),
                      ],
                    ),
              height(24),
            ],
          ),
        ),
      ),
    );
  }
}
