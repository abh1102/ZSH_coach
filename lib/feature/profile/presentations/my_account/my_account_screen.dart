import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';

import '../../../../widgets/whitebg_blacktext_button.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String selectedLanguage = 'Lack of progress'; // Default selected language

  void showCancelMembershipReasonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CancelMembershipReasonDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWithBackButtonWOSilver(
            firstText: "My", secondText: "Account"),
        body: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
          if (state is LoginDeleteUserState) {
            // Route to splash screen when user is deleted
            showGreenSnackBar(state.message);
            Routes.goToReplacement(Screens.splash);
          }
          if (state is LoginErrorState) {
            // Route to splash screen when user is deleted
            showSnackBar(state.error);
          }
        }, builder: (context, state) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 28.w,
                vertical: 28.h,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/Group 1171275016.svg"),
                      width(4),
                      Expanded(
                        child: body2Text(
                          "Member Since ${myformattedDate(myCoach?.coachInfo?[0].createdAt ?? "")} ",
                          color: AppColors.textDark,
                        ),
                      )
                    ],
                  ),
                  height(50),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 21.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF25d366).withOpacity(0.24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        body2Text(
                          myCoach?.profile?.email ?? "",
                          color: AppColors.textDark,
                        ),
                        height(11),
                        body2Text(
                          "Password: *********",
                          color: AppColors.textLight,
                        ),
                        height(11),
                        body2Text(
                          "Phone: ${myCoach?.profile?.phone}",
                          color: AppColors.textLight,
                        ),
                        height(19),
                        const Divider(
                          color: Color(0xFFC4C4C4),
                        ),
                        MyAccountRow(
                          text: "Change Password",
                          onpressed: () {
                            Routes.goTo(Screens.changePassword);
                          },
                        ),
                        height(8),
                        const Divider(
                          color: Color(0xFFC4C4C4),
                        ),
                        MyAccountRow(
                          text: "Change Phone Number",
                          onpressed: () {
                            Routes.goTo(Screens.profileOneTimePasscode);
                          },
                        ),
                        //   height(8),
                        // const Divider(
                        //   color: Color(0xFFC4C4C4),
                        // ),
                        // MyAccountRow(
                        //   text: "Change Email",
                        //   onpressed: () {
                        //     Routes.goTo(Screens.changeEmail);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  height(102),
                  GestureDetector(
                    onTap: () {
                      simpleDialog(
                        context,
                        "Are You Sure?",
                        "Want to Delete Your Account",
                        "Yes",
                        "Go Back",
                        () {
                          Navigator.of(context).pop();
                          BlocProvider.of<LoginCubit>(context)
                              .deleteUser("deactive");
                        },
                      );
                    },
                    child: SimpleWhiteTextButtonWOHW(
                      isLoading: state is LoginLoadingState,
                      color: AppColors.secondaryRedColor,
                      verticalPadding: 14,
                      text: "Delete Account",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ));
        }));
  }
}

class MyAccountRow extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const MyAccountRow({
    super.key,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          body1Text(
            text,
            color: AppColors.textDark,
          ),
          SvgPicture.asset("assets/icons/Vector (2).svg")
        ],
      ),
    );
  }
}

class CancelMembershipReasonDialog extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const CancelMembershipReasonDialog({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CancelMembershipReasonDialogState createState() =>
      _CancelMembershipReasonDialogState();
}

class _CancelMembershipReasonDialogState
    extends State<CancelMembershipReasonDialog> {
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
          vertical: 24.h,
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
            height(24),
            Center(
                child: heading1Text(
              "Why do you want to Cancel your membership?",
              textAlign: TextAlign.center,
              color: Colors.white,
            )),
            height(28),
            _buildLanguageRow('Lack of progress'),
            _buildLanguageRow('Scheduling Conflict '),
            _buildLanguageRow('Changes in Goal'),
            _buildLanguageRow('Availability'),
            _buildLanguageRow('Others'),
            height(55),
            WhiteBgBlackTextButton(
              text: "Submit",
              onpressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow(String language) {
    return Row(
      children: [
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
        width(8),
        simpleText(
          language,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ],
    );
  }
}
