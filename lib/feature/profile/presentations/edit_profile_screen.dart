import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/provider/edit_profile_provider.dart';
import 'package:zanadu_coach/feature/profile/widgets/profile_avatar_camera_icon.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';
import 'package:zanadu_coach/feature/signup/widgets/select_date.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/format_date.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';
import 'package:zanadu_coach/widgets/valid_name.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> selectedHealthChallenges = [];
  String selectedGender = '';
  String selectHealthChallenges = '';
  String selectResidentState = '';
  String selectCountryState = '';
  bool isShowNameValidation = false;
  Key infoPopupCustomExampleKey = Key('info_popup_custom_example');
  String infoPopupCustomExampleText = 'This is a custom widget';

  final TextEditingController fullName = TextEditingController();

  final TextEditingController selectState = TextEditingController();

  final TextEditingController country = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fullName.text = myCoach?.profile?.fullName ?? "";

    selectState.text = myCoach?.profile?.state ?? "";
    country.text = myCoach?.profile?.country ?? "";
    selectedGender = myCoach?.profile?.gender ?? "";
    selectResidentState = myCoach?.profile?.state ?? "";
    selectCountryState = myCoach?.profile?.country ?? "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullName.dispose();
  }

  String getAreaOfSpecializationText() {
    final List<String> specializations = [];

    // Add health specialization
    if (myCoach?.profile?.areaOfSpecialization?.health?.id != null) {
      specializations
          .add(myCoach!.profile!.areaOfSpecialization!.health!.name!);
    }

    // Add specializations
    if (myCoach?.profile?.areaOfSpecialization?.special != null) {
      final specialities = myCoach!.profile!.areaOfSpecialization!.special!;
      for (final specialty in specialities) {
        specializations.add(specialty.name!);
      }
    }

    return specializations.join(', '); // Join the specializations with commas
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProfileProvider>(context);
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
              firstText: "Edit", secondText: "Profile"),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      height(35),
                      Center(
                        child: ProfileAvatarWithCameraIcon(
                          provider: provider,
                          imageUrl: "assets/images/Rectangle 47.png",
                          onPressed: () async {
                            Routes.goBack();
                            context.read<LoginCubit>().removeProfilePhoto();
                            provider.removeSelectedImage();
                          },
                        ),
                      ),
                      height(72),
                      simpleText(
                        "Name",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      PrefixIconTextFieldWidget(
                        controller: fullName,
                        prefixIcon: "assets/icons/user.svg",
                        onChanged: (value) {
                          if (!isValidName(value.trim())) {
                            setState(() {
                              isShowNameValidation = true;
                            });
                          } else {
                            setState(() {
                              isShowNameValidation = false;
                            });
                          }
                        },
                      ),
                      if (isShowNameValidation)
                        simpleText(
                          "You can not put only numbers or special character in name field",
                          color: AppColors.secondaryRedColor,
                          fontSize: 10,
                        ),
                      // Add additional text fields here
                      height(16),
                      simpleText(
                        "Email",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      NoIconTextFieldWidget(
                        color: Color(0xffEFEFEF),
                        enabled: false,
                        initial: myCoach?.profile?.email ?? "",
                      ),
                      height(16),

                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              simpleText(
                                "Date of Birth",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textLight,
                              ),
                              height(8),
                              SelectStartDateEditProfile(
                                provider: provider,
                              ),
                            ],
                          )),
                          width(5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                simpleText(
                                  "Select Gender",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textLight,
                                ),
                                height(8),
                                DynamicPopupMenu(
                                  selectedValue: selectedGender,
                                  items: const [
                                    'Male',
                                    'Female',
                                    'Trans',
                                    'Non Binary'
                                  ],
                                  onSelected: (String value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      height(16),

                      simpleText(
                        "Area of Specialization * ",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      NoIconTextFieldWidget(
                        color: const Color(0xffEFEFEF),
                        enabled: false,
                        initial: getAreaOfSpecializationText(),
                      ),
                      height(16),
                      simpleText(
                        "Resident State",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),

                      height(8),

                      NoIconTextFieldWidget(
                        controller: selectState,
                      ),
                      // DynamicPopupMenu(
                      //   selectedValue: selectResidentState.isEmpty
                      //       ? myCoach?.profile?.state ?? ""
                      //       : selectResidentState,
                      //   items: const [
                      //     'California',
                      //     'Texas',
                      //     'Florida',
                      //     'New York'
                      //   ],
                      //   onSelected: (String value) {
                      //     setState(() {
                      //       selectResidentState = value;
                      //     });
                      //   },
                      // ),
                      height(16),
                      simpleText(
                        "Resident Country",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      NoIconTextFieldWidget(
                        controller: country,
                      ),

                      height(64),
                      GestureDetector(
                        onTap: () {
                          if (isValidName(fullName.text.trim()) == true) {
                            context.read<LoginCubit>().updateUser(
                                country: country.text,
                                fullName: fullName.text
                                    .trim(), // Replace with your updated data
                                dob: provider.startDate == null
                                    ? myCoach?.profile?.dOB
                                    : formatDate(provider.startDate),
                                gender: selectedGender,
                                topHealthChallenges: selectedHealthChallenges,
                                state: selectState.text.trim(),
                                image: provider.selectedImage?.path);
                          } else {
                            showSnackBar(
                                "Name field can not have only numbers or special character");
                          }
                        },
                        child: ColoredButton(
                          isLoading:
                              BlocProvider.of<LoginCubit>(context, listen: true)
                                  .state is LoginLoadingState,
                          text: "Update",
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                      height(16),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}

void showLoadingIndicator(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    },
  );
}
