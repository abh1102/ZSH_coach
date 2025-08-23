import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/feature/login/logic/service/auth_service.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/divider_with_text.dart';
import 'package:zanadu_coach/widgets/launch_url.dart';
import 'package:zanadu_coach/widgets/logo_widget.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  final bool isBackButton;
  const LoginScreen({super.key, required this.isBackButton});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthServices authServices = AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberBool = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadedState) {
            Routes.closeAllAndGoTo(Screens.homeBottomBar);
          }
          if (state is ThridPartySignUpLoadedState) {
            Routes.goTo(Screens.thirdpartysignupscreensecond,
                arguments: state.message);
          }
          if (state is ThridPartyLoginLoadedState) {
            Routes.closeAllAndGoTo(Screens.homeBottomBar);
          }
          if (state is ThridPartyEmailNotVerifiedLoadedState) {
            showSnackBar(state.message);
          }
          if (state is LoginErrorState) {
            FocusScope.of(context).unfocus();
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor:
                                0.54, // Adjust this value to control the height
                            child: Image.asset(
                              "assets/images/Clip path group.png",
                            ),
                          ),
                        ),
                      ),
                      if (widget.isBackButton)
                        Positioned(
                          left: 20.w,
                          child: const BackArrow(),
                        ),
                      Positioned(
                        top: 170.h,
                        left: 122,
                        child: simpleText(
                          "Coach Login",
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        height(35),
                        simpleText(
                          "Email",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        height(8),
                        PrefixIconTextFieldWidget(
                          controller: emailController,
                          prefixIcon: "assets/icons/user.svg",
                        ),
                        // Add additional text fields here
                        height(16),
                        simpleText(
                          "Password",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        height(8),
                        PrefixIconTextFieldWidget(
                          hidePassword: true,
                          controller: passwordController,
                          prefixIcon: "assets/icons/Group (1).svg",
                        ),
                        // Add additional text fields here
                        height(13),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    side:
                                        BorderSide(color: AppColors.textLight),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5.0), // Adjust the radius as needed
                                      side: const BorderSide(
                                          color: Colors
                                              .black), // Optional: Add a border
                                    ),
                                    value: rememberBool,
                                    onChanged: (value) {
                                      setState(() {
                                        rememberBool = value as bool;
                                      });
                                    }),
                                simpleText(
                                  'Remember Me',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Routes.goTo(Screens.changePassEmail);
                              },
                              child: simpleText(
                                'Forget Password?',
                                color: Color(0xFF03C0FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),

                        height(64.h),
                        GestureDetector(
                          onTap: () {
                            if (emailController.text.trim().isEmpty ||
                                passwordController.text.trim().isEmpty) {
                              showSnackBar("Please fill all details");
                            } else {
                              if (validateEmail(emailController.text.trim()) ==
                                  false) {
                                showSnackBar("Please fill valid email");
                              } else {
                                BlocProvider.of<LoginCubit>(context).login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    rememberMe: rememberBool);
                              }
                            }
                          },
                          child: ColoredButton(
                            isLoading: BlocProvider.of<LoginCubit>(context,
                                        listen: true)
                                    .state is LoginLoadingState ||
                                BlocProvider.of<LoginCubit>(context,
                                        listen: true)
                                    .state is ThirdPartyLoginLoadingState,
                            text: "Login",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                        height(16),
                        const DividerWithText(
                          text: "Or Continue With",
                        ),
                        height(26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const LogoWidget(
                            //   text: "assets/icons/Facebook logo 2019.svg",
                            // ),
                            // width(24),
                            GestureDetector(
                              onTap: () async {
                                BlocProvider.of<LoginCubit>(context)
                                    .thirdPartyLogin(true);
                              },
                              child: const LogoWidget(
                                text: "assets/icons/Google.svg",
                              ),
                            ),
                            if (Platform.isIOS) width(24),
                            if (Platform.isIOS)
                              GestureDetector(
                                onTap: () async {
                                  BlocProvider.of<LoginCubit>(context)
                                      .thirdPartyLogin(false);
                                },
                                child: const AppleLogoWidget(
                                  text: "assets/icons/Linkedin.svg",
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height(40),
                  RichText(
                    text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Open the URL for Coach Agreement
                          myLaunchUrl(
                              "https://app.zanaduhealth.com/terms-of-service");
                        },
                      text: 'Terms of Service ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryBlue,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'and ',
                        ),
                        TextSpan(
                          text: 'Privacy Policy. ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Open the URL for Coach Agreement
                              myLaunchUrl(
                                  "https://app.zanaduhealth.com/privacy-policy");
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

bool? validateEmail(String value) {
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return false;
  }
  return true;
}
