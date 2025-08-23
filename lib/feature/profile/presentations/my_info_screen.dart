import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/contain_emoji.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  TextEditingController yearOfExperience = TextEditingController();

  TextEditingController designation = TextEditingController();

  TextEditingController bio = TextEditingController();

  @override
  void initState() {
    super.initState();

    yearOfExperience.text = myCoach?.profile?.experience ?? "";
    designation.text = myCoach?.profile?.designation ?? "";
    bio.text = myCoach?.profile?.bio ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoginCubit>(context, listen: true);
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is UserUpdatedState) {
            // Handle the updated user state
            // You can also add additional logic or UI updates here

            showGreenSnackBar("Your Account Successfully Updated");
          } else if (state is LoginErrorState) {
            // Handle error state
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "My", secondText: "Info"),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        simpleText(
                          "Years of Experience",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        height(8),
                        NoIconTextFieldWidget(
                          phoneKeyboard: true,
                          controller: yearOfExperience,
                        ),
                        height(20),
                        simpleText(
                          "Designation",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        height(8),
                        NoIconTextFieldWidget(
                          controller: designation,
                        ),
                        height(20),
                        simpleText(
                          "Bio",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        height(8),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.greyLight),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: bio,
                            maxLines: 4,
                            decoration: const InputDecoration(
                                // hintText: "Type Here...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        height(30),
                        GestureDetector(
                          onTap: () {
                            
                            if (containsEmoji(designation.text.trim()) ==
                                    true ||
                                containsEmoji(yearOfExperience.text.trim()) ==
                                    true) {
                              showSnackBar(
                                  "You can not use emoji in year of experience and designation");
                            } else {
                              context.read<LoginCubit>().updateUser(
                                  bio: bio.text,
                                  designation: designation.text,
                                  experience: yearOfExperience.text);
                            }
                          },
                          child: ColoredButton(
                            isLoading: cubit.state is LoginLoadingState,
                            text: "Update Info",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
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
