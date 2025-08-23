import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/logic/signup_cubit/signup_cubit.dart';
import 'package:zanadu_coach/feature/onetimepasscode/widgets/countdown_timer.dart';
import 'package:zanadu_coach/feature/onetimepasscode/widgets/pin_code_input_field.dart';
import 'package:zanadu_coach/feature/onetimepasscode/widgets/resent_button.dart';
import 'package:zanadu_coach/feature/signup/logic/provider/signup_provider.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/format_date.dart';

class OneTimePassword extends StatefulWidget {
  const OneTimePassword({super.key});

  @override
  State<OneTimePassword> createState() => _OneTimePasswordState();
}

class _OneTimePasswordState extends State<OneTimePassword> {
  TextEditingController codeSentController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";

  // Other existing code...

  Future<void> verifyPhone() async {
    final provider = Provider.of<SignUpProvider>(context, listen: false);
    await _auth.verifyPhoneNumber(
      phoneNumber:
          '+91 7987681268', // Replace with the user's phone number
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await _auth.signInWithCredential(credential);
        //showSnackBar("verification completed");
        // Handle verification completion if needed

// function to call for signup cubit when verificaiton has completed
        String? healthCoachId;
        List<String> selectedSpecialityCoachIds = [];

        for (var selectedTitle in provider.selectedHealthChallengesP) {
          // Check if the selected title is 'Health Coach'
          if (selectedTitle == 'Health') {
            var healthCoachOffering = provider.allOfferings.firstWhere(
              (offering) => offering.title == selectedTitle,
            );
            healthCoachId = healthCoachOffering.sId;
          } else {
            // Treat other titles as specialty coaches
            var specialityCoachOffering = provider.allOfferings.firstWhere(
              (offering) => offering.title == selectedTitle,
            );
            selectedSpecialityCoachIds.add(specialityCoachOffering.sId ?? "");
          }
        }

        // Call the signup function from the provider
        BlocProvider.of<SignUpCubit>(context).signUp(
          govrnmentIssuedId: provider.govermentFileP.toString(),
          certificate: provider.certificateFileP.toString(),
          country: provider.countryControllerP.text,
          areaOfSpecialization: provider.selectedHealthChallengesP,
          pdfFile:
              provider.filePathP.toString(), // replace with the actual filename
          email: provider.emailControllerP.text,
          password: provider.passwordControllerP.text,
          phoneNumber:
              "+${provider.countryCodeControllerP.text}-${provider.phoneNumberControllerP.text}",
          fullName: provider.fullNameControllerP.text,
          dob: formatDate(provider.startDate!),
          gender: provider.selectedGenderP,
          state:
              provider.stateControllerP.text, // replace with the actual state
          healthCoachId: healthCoachId,
          specialityCoachId: selectedSpecialityCoachIds,
        );

        provider.clearAllValues();
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar("Verification Failed: ${e.message}");
        // Handle verification failure
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });

        showGreenSnackBar("Code send to your mobile phone number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> submitCode(String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential);
      // Handle successful verification
      // You can add your logic here, for example, dispatching a SignUpCubit event
      // for successful verification.
    } catch (e) {
      showSnackBar(e.toString());

      // Handle verification error
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final provider = Provider.of<SignUpProvider>(context);
    return BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
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
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
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
                            Positioned(
                              left: 20.w,
                              child: const BackArrow(),
                            ),
                            Positioned(
                              top: 170.h,
                              left: 96.w,
                              child: Column(
                                children: [
                                  simpleText(
                                    "One Time Passcode",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  height(16),
                                ],
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
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 249.w,
                                  child: const Text(
                                    textAlign: TextAlign.center,
                                    "Please enter the 6 digit verification code sent to your mobile number",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              height(64),
                              Center(
                                child: CountdownTimerWidget(
                                  onTimerEnd: () {
                                    // Function to run when the timer is completed
                                    print('Timer Completed');
                                  },
                                ),
                              ),
                              height(30),
                              MyPinCodeInputField(
                                condSentController: codeSentController,
                              ),
                              height(64),
                              ResendButton(onTap: () {
                                // Add your logic here for resending the code
                                // ignore: avoid_print
                                print("Resend button tapped");
                                // You can call your resend code logic here
                              }),
                              height(28),
                              GestureDetector(
                                onTap: () {
                                  submitCode(
                                      codeSentController.text.toString());
                                },
                                child: const GreySubmitButton(
                                  colored: false,
                                  text: "Submit",
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "assets/images/Clip path group (1).png",
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
