import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/switch_profile/switch_profile_cubit.dart';
import 'package:zanadu_coach/feature/profile/widgets/edit_profile_row.dart';
import 'package:zanadu_coach/feature/profile/widgets/icon_text_row.dart';
import 'package:zanadu_coach/widgets/all_dialog.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'English'; // Default selected language

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LanguageDialog(
          selectedLanguage: selectedLanguage,
          onLanguageSelected: (value) {
            setState(() {
              selectedLanguage = value;
            });
          },
        );
      },
    );
  }

  void switchRoleDialog(BuildContext context, VoidCallback? onpressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SwitchRoleDialog(
          onpressed: onpressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwitchProfileCubit, SwitchProfileState>(
        listener: (context, state) {
          if (state is SwitchProfileLoadedState) {
            Routes.goBack();
            showGreenSnackBar(state.message);
          }
          if (state is SwitchProfileLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            );
          }
          if (state is SwitchProfileErrorState) {
            Routes.goBack();
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "My", secondText: "Profile"),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 28.w,
                vertical: 28.h,
              ),
              child: Column(
                children: [
                  EditProfileRow(url: myCoach?.profile?.image),
                  height(28),
                  const Divider(
                    height: 2,
                    color: Color(
                      0xffD9D9D9,
                    ),
                  ),
                  height(28),
                  IconWithTextRow(
                    onpressed: () {
                      if (myCoach?.isApproved == true) {
                        Routes.goTo(Screens.myAccount);
                      } else {
                        onlyTextWithCutIcon(
                            context, "Your account is not approved yet");
                      }
                    },
                    svg:
                        "assets/icons/admin_panel_settings_FILL0_wght500_GRAD0_opsz24.svg",
                    text: "My Account",
                  ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      Routes.goTo(Screens.myInfo);
                    },
                    svg: "assets/icons/user_dark.svg",
                    text: "My Info",
                  ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      Routes.goTo(Screens.editProfileNotificationScreen);
                    },
                    svg: "assets/icons/Group (10).svg",
                    text: "Notification",
                  ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      Routes.goTo(Screens.calenderReminder);
                    },
                    svg: "assets/icons/Group (11).svg",
                    text: "Calendar Reminder",
                  ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      if (myCoach?.isApproved == true) {
                        Routes.goTo(Screens.myVideos);
                      } else {
                        onlyTextWithCutIcon(
                            context, "Your account is not approved yet");
                      }
                    },
                    svg: "assets/icons/Group 1171275084.svg",
                    text: "My Videos",
                  ),
                  // height(16),
                  // IconWithTextRow(
                  //   onpressed: () {
                  //     if (myCoach?.isApproved == true) {
                  //       switchRoleDialog(
                  //         context,
                  //         () async {
                  //           Routes.goBack();
                  //           await BlocProvider.of<SwitchProfileCubit>(context)
                  //               .getSwitchProfileData();
                  //         },
                  //       );
                  //     } else {
                  //       onlyTextWithCutIcon(
                  //           context, "Your account is not approved yet");
                  //     }
                  //   },
                  //   svg: "assets/icons/switch.svg",
                  //   text: "Switch Role",
                  // ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      showLanguageDialog(context);
                    },
                    svg: "assets/icons/Group (13).svg",
                    text: "Language",
                  ),
                  height(16),
                  IconWithTextRow(
                    onpressed: () {
                      Routes.goTo(Screens.helpSupport);
                    },
                    svg: "assets/icons/Group (14).svg",
                    text: "Help And Support",
                  ),
                  height(16),
                  GestureDetector(
                    onTap: () {
                      simpleDialog(
                        context,
                        "Confirm",
                        "Are you sure you want to logout from this device?",
                        "Logout",
                        "Go Back",
                        () async {
                          await BlocProvider.of<LoginCubit>(context).logout();
                        },
                      );
                    },
                    child: const IconWithTextRow(
                      svg: "assets/icons/Group (15).svg",
                      text: "Logout",
                    ),
                  ),
                  height(16),
                ],
              ),
            ),
          )),
        ));
  }
}

class LanguageDialog extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const LanguageDialog({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 29.w,
          vertical: 64.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF25D366), Color(0xFF03C0FF)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: heading1Text(
              "Language",
              color: Colors.white,
            )),
            height(28),
            buildLanguageRow('English'),
            // buildLanguageRow('French'),
            // buildLanguageRow('Italian'),
            // buildLanguageRow('Spanish'),
            height(55),
            WhiteBgBlackTextButton(
              text: "Done",
              onpressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageRow(String language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        simpleText(
          language,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        Radio(
          value: language,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onLanguageSelected(value as String);
          },
          activeColor: Colors.white,
        ),
      ],
    );
  }
}
