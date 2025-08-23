import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/data/model/signed_url_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/feature/login/logic/signup_cubit/signup_cubit.dart';
import 'package:zanadu_coach/feature/signup/logic/provider/signup_provider.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';
import 'package:zanadu_coach/feature/signup/widgets/select_date.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';
import 'package:zanadu_coach/widgets/contain_emoji.dart';
import 'package:zanadu_coach/widgets/format_date.dart';
import 'package:zanadu_coach/widgets/launch_url.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';
import 'package:zanadu_coach/widgets/valid_name.dart';
import 'package:zanadu_coach/widgets/validate_email.dart';
import 'package:zanadu_coach/widgets/validate_password.dart';

class SignUpSecondScreen extends StatefulWidget {
  const SignUpSecondScreen({super.key});

  @override
  State<SignUpSecondScreen> createState() => _SignUpSecondScreenState();
}

class _SignUpSecondScreenState extends State<SignUpSecondScreen> {
  String infoPopupCustomExampleText = 'This is a custom widget';
  bool isWeakPassword = false;
  String? profileTemplateUrl;
  bool isShowNameValidation = false;

  @override
  void initState() {
    super.initState();
    // Call the getSignedUrl function to obtain the signed URL for the profile template
    _fetchProfileTemplateUrl();
  }

  LoginRepository repo = LoginRepository();
  Future<void> _fetchProfileTemplateUrl() async {
    try {
      // Call the getSignedUrl function from the LoginCubit
      SignedUrlModel model = await repo.getSignedUrlDocument();

      setState(() {
        profileTemplateUrl = model.signedUrl;
      });
    } catch (e) {
      showSnackBar(e.toString());
      print("Error fetching signed URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);
    return BlocListener<SignUpCubit, SignUpState>(listener: (context, state) {
      if (state is SignUpLoadedState) {
        showGreenSnackBar(state.message);
        showGreenSnackBar(
            "Check your mail to verify your email address so that you can continue",
            duration: const Duration(seconds: 7));
        Routes.closeAllAndGoTo(Screens.login, arguments: false);
      }

      if (state is SignUpErrorState) {
        FocusScope.of(context).unfocus();
        Routes.closeAllAndGoTo(Screens.splash);
        showSnackBar(state.error);
      }

      if (state is OfferErrorState) {
        FocusScope.of(context).unfocus();
        showSnackBar(state.error);
      }
    }, child: Scaffold(
      body: SafeArea(
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            if (state is OfferingLoadingState) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is SignUpLoadingState) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is AllOfferingLoadedState) {
              // Access the loaded plan from the state
              provider.allOfferings = state.offering;
              return SingleChildScrollView(
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
                        Positioned(
                          left: 20.w,
                          child: const BackArrow(),
                        ),
                        Positioned(
                          top: 140,
                          left: MediaQuery.of(context).size.width * 0.288,
                          child: simpleText(
                            "Coach Sign Up",
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
                          simpleText(
                            "Name *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          PrefixIconTextFieldWidget(
                            controller: provider.fullNameControllerP,
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
                            )
                          // Add additional text fields here
                          ,
                          height(16),
                          simpleText(
                            "Email *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          NoIconTextFieldWidget(
                            controller: provider.emailControllerP,
                          ),
                          height(16),
                          simpleText(
                            "Enter Password *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          PrefixSuffixIconTextFieldWidget(
                            hidePassword: true,
                            controller: provider.passwordControllerP,
                            onchanged: (password) {
                              setState(() {
                                isWeakPassword =
                                    !checkPasswordStrength(password);
                              });
                            },
                            prefixIcon: "assets/icons/Group (1).svg",
                            suffixIcon: "assets/icons/info.svg",
                          ),
                          if (isWeakPassword)
                            simpleText(
                              "Must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. Minimum 8 characters.",
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryRedColor,
                            ),
                          height(16),
                          simpleText(
                            "Mobile Phone No. *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          Row(
                            children: [
                              CountryTextFieldWidget(
                                countrycodeController:
                                    provider.countryCodeControllerP,
                                width: 70.w,
                              ),
                              width(10),
                              Expanded(
                                  child: NoIconTextFieldWidgetNumber(
                                controller: provider.phoneNumberControllerP,
                              ))
                            ],
                          ),
                          height(16),

                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  simpleText(
                                    "Date of Birth *",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textLight,
                                  ),
                                  height(8),
                                  SelectStartDate(provider: provider),
                                ],
                              )),
                              width(7),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    simpleText(
                                      "Select Gender *",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textLight,
                                    ),
                                    height(8),
                                    DynamicPopupMenu(
                                      selectedValue: provider.selectedGenderP,
                                      items: const [
                                        'Male',
                                        'Female',
                                        'Trans',
                                        'Non Binary'
                                      ],
                                      onSelected: (String value) {
                                        provider.updateGender(value);
                                        // setState(() {
                                        //   selectedGender = value;
                                        // });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          height(16),
                          simpleText(
                            "Area of Specialization (Upto 2) *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          DynamicPopupMenuEditScreen(
                            selectedValues: provider.selectedHealthChallengesP,
                            items: provider.allOfferings
                                .map((offering) => offering.title!)
                                .toList(),
                            onSelected: (List<String> values) {
                              provider.updateselectedHealthChallengesP(values);
                              // setState(() {
                              //   //  print(values.toString());
                              //   selectedHealthChallenges = values;
                              //   // print(selectedHealthChallenges.toString());
                              // });
                            },
                          ),

                          height(16),
                          simpleText(
                            "Resident Country *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),

                          height(8),
                          NoIconTextFieldWidget(
                            controller: provider.countryControllerP,
                          ),

                          height(16),
                          simpleText(
                            "Resident State *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),

                          height(8),
                          NoIconTextFieldWidget(
                            controller: provider.stateControllerP,
                          ),
                          // DynamicPopupMenu(
                          //   selectedValue: selectResidentState,
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
                            "Upload Government Issued ID *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          Container(
                            width: 374.w,
                            height: 174.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: AppColors.greyLight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                provider.govermentFileP == null
                                    ? SvgPicture.asset(
                                        "assets/icons/🦆 icon _folder_.svg")
                                    : simpleText("File Selected"),
                                height(8),
                                GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );

                                    if (result != null) {
                                      setState(() {
                                        provider.govermentFileP =
                                            result.files.single.path!;
                                      });

                                      showGreenSnackBar(
                                          "Your file is selected");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 22.w),
                                    decoration: BoxDecoration(
                                      gradient: Insets.fixedGradient(),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: body2Text(
                                      "Browse File",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height(16),
                          simpleText(
                            "Upload Certificates *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          Container(
                            width: 374.w,
                            height: 174.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: AppColors.greyLight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                provider.certificateFileP == null
                                    ? SvgPicture.asset(
                                        "assets/icons/🦆 icon _folder_.svg")
                                    : simpleText("File Selected"),
                                height(8),
                                GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );

                                    if (result != null) {
                                      // Handle the selected file

                                      setState(() {
                                        provider.certificateFileP =
                                            result.files.single.path!;
                                      });
                                      showGreenSnackBar(
                                          "Your file is selected");
                                      // You can use filePath for further processing
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 22.w),
                                    decoration: BoxDecoration(
                                      gradient: Insets.fixedGradient(),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: body2Text(
                                      "Browse File",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height(16),
                          simpleText(
                            "Upload Profile *",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                          ),
                          height(8),
                          Container(
                            width: 374.w,
                            height: 174.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: AppColors.greyLight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                provider.filePathP == null
                                    ? SvgPicture.asset(
                                        "assets/icons/🦆 icon _folder_.svg")
                                    : simpleText("File Selected"),
                                height(8),
                                GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );

                                    if (result != null) {
                                      // Handle the selected file

                                      setState(() {
                                        provider.filePathP =
                                            result.files.single.path!;
                                      });

                                      showGreenSnackBar(
                                          "Your file is selected");
                                      // You can use filePath for further processing
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 22.w),
                                    decoration: BoxDecoration(
                                      gradient: Insets.fixedGradient(),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: body2Text(
                                      "Browse File",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height(8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                myLaunchUrl(profileTemplateUrl ?? "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 12.w,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.greyDark),
                                child: simpleText(
                                  "Download Profile Template",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          height(64.h),
                          Center(
                            child: RichText(
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
                          ),
                          height(12),
                          body2Text(
                            "By clicking on submit, I have read and am agreeing to the Terms of service , Coaches Agreement and Privacy Policy.",
                            align: TextAlign.center,
                          ),
                          height(18),
                          ColoredButton(
                            isLoading: state is LoginLoadingState,
                            onpressed: () async {
                              if (isValidName(provider
                                          .fullNameControllerP.text
                                          .trim()) ==
                                      true &&
                                  containsEmoji(
                                          provider
                                              .fullNameControllerP.text
                                              .trim()) ==
                                      false &&
                                  containsEmoji(
                                          provider
                                              .passwordControllerP.text
                                              .trim()) ==
                                      false &&
                                  provider.emailControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider
                                      .passwordControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider
                                      .stateControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider
                                      .countryControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider
                                      .phoneNumberControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider
                                      .countryCodeControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  isWeakPassword == false &&
                                  provider
                                      .fullNameControllerP.text
                                      .trim()
                                      .isNotEmpty &&
                                  provider.startDate != null &&
                                  provider.filePathP != null &&
                                  provider.govermentFileP != null &&
                                  provider.certificateFileP != null &&
                                  provider.selectedGenderP != 'Select Gender' &&
                                  provider
                                      .selectedHealthChallengesP.isNotEmpty &&
                                  validateEmail(provider.emailControllerP.text
                                          .trim()) ==
                                      true) {
                                String? healthCoachId;
                                List<String> selectedSpecialityCoachIds = [];

                                for (var selectedTitle
                                    in provider.selectedHealthChallengesP) {
                                  // Check if the selected title is 'Health Coach'
                                  if (selectedTitle == 'Health') {
                                    var healthCoachOffering =
                                        provider.allOfferings.firstWhere(
                                      (offering) =>
                                          offering.title == selectedTitle,
                                    );
                                    healthCoachId = healthCoachOffering.sId;
                                  } else {
                                    // Treat other titles as specialty coaches
                                    var specialityCoachOffering =
                                        provider.allOfferings.firstWhere(
                                      (offering) =>
                                          offering.title == selectedTitle,
                                    );
                                    selectedSpecialityCoachIds
                                        .add(specialityCoachOffering.sId ?? "");
                                  }
                                }

                                // Call the signup function from the provider
                                BlocProvider.of<SignUpCubit>(context).signUp(
                                  govrnmentIssuedId:
                                      provider.govermentFileP.toString(),
                                  certificate:
                                      provider.certificateFileP.toString(),
                                  country: provider.countryControllerP.text,
                                  areaOfSpecialization:
                                      provider.selectedHealthChallengesP,
                                  pdfFile: provider.filePathP
                                      .toString(), // replace with the actual filename
                                  email: provider.emailControllerP.text,
                                  password: provider.passwordControllerP.text,
                                  phoneNumber:
                                      "+${provider.countryCodeControllerP.text}-${provider.phoneNumberControllerP.text}",
                                  fullName: provider.fullNameControllerP.text,
                                  dob: formatDate(provider.startDate!),
                                  gender: provider.selectedGenderP,
                                  state: provider.stateControllerP
                                      .text, // replace with the actual state
                                  healthCoachId: healthCoachId,
                                  specialityCoachId: selectedSpecialityCoachIds,
                                );

                                provider.clearAllValues();
                                //Routes.goTo(Screens.oneTimePassword);

                                //provider.selectedHealthChallengesP = [];
                              } else if (isWeakPassword) {
                                showSnackBar("Weak Password");
                              } else {
                                // Show a message or alert the user that all fields are required
                                // You can use a snackbar or any other method to inform the user
                                if (validateEmail(provider.emailControllerP.text
                                        .trim()) ==
                                    false) {
                                  showSnackBar("Please fill valid email");
                                } else {
                                  showSnackBar(
                                      "Please fill in all required fields.");
                                }
                              }
                            },
                            text: "Submit",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    height(50),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    ));
  }
}
