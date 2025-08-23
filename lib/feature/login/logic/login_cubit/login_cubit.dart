import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/data/model/login_model.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/login/data/model/third_party_login_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/login/logic/service/auth_service.dart';
import 'package:zanadu_coach/feature/login/logic/service/preference_services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  final LoginRepository _repository = LoginRepository();

  Future<void> login(
      {required String email,
      required String password,
      required rememberMe}) async {
    emit(LoginLoadingState());
    try {
      LoginModel loginModel =
          await _repository.logIn(email: email, password: password);

      if (loginModel.role == "USER") {
        emit(LoginErrorState(
            "This is Coach App. Please Download User App to Login In"));

        return;
      }

      // Call the fetchUserInfo function to get user details
      CoachModel coachModel =
          await _repository.fetchUserInfo(token: loginModel.accessToken ?? '');

      await Preferences.saveAccessToken(loginModel.accessToken ?? "");

      if (rememberMe == true) {
        // If "Remember Me" is checked, store the access token
        await Preferences.saveUserDetails(
          email,
          password,
        );
      }

      // myuid = generateUnique9DigitNumber(loginModel.uid??123456789);
      myuid = loginModel.uid;

      print(loginModel.uid);
      List<OfferingsModel> allOffering = await _repository.fetchAllOffering();

      myOfferings = allOffering;
      //to locally store the user model
      myCoach = coachModel;
      if (myCoach?.profile?.areaOfSpecialization?.health?.id != null) {
        profiles.add((myCoach?.profile?.areaOfSpecialization?.health));
        if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
            true) {
          profiles.add((myCoach?.profile?.areaOfSpecialization?.special?[0]));
        }
      } else {
        if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
            true) {
          profiles
              .addAll(myCoach?.profile?.areaOfSpecialization?.special ?? []);
        }
      }
      emit(LoginLoadedState(coachModel));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> updateUser({
    String? fullName,
    String? dob,
    String? gender,
    List<String>? topHealthChallenges,
    String? state,
    String? image,
    String? experience,
    String? bio,
    String? designation,
    String? country,
  }) async {
    emit(LoginLoadingState());
    try {
      // Call the updateUser function from the repository
      await _repository.editProfile(
          fullName: fullName,
          dob: dob,
          gender: gender,
          topHealthChallenges: topHealthChallenges,
          state: state,
          image: image,
          bio: bio,
          designation: designation,
          experience: experience,
          country: country);

      // Update the locally stored user model

      CoachModel userModel =
          await _repository.fetchUserInfo(token: accessToken);

      myCoach = userModel;

      emit(UserUpdatedState(userModel));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  // remove profile photo

  Future<void> removeProfilePhoto() async {
    emit(LoginLoadingState());
    try {
      // Call the updateUser function from the repository
      await _repository.removeProfilePhoto();

      // Update the locally stored user model

      CoachModel userModel =
          await _repository.fetchUserInfo(token: accessToken);

      myCoach = userModel;

      emit(LoginLoadedState(userModel));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(LoginLoadingState());
    try {
      // Get the user token from preferences

      // Call the changePassword function from the repository
      String message = await _repository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      await Preferences.clear();
      // Update the locally stored user model

      emit(PasswordChangedState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LoginLoadingState());
    try {
      AuthServices authServices = AuthServices();
      await Preferences.clear();

      profiles = [];
      // Clear stored user details
      Routes.closeAllAndGoTo(Screens.splash);
      showGreenSnackBar("Logout Successfully");
      authServices.signOut();
      emit(LoginLogoutState());
      // ApiResponse logoutResponse = await _repository.logOut();

      // if (logoutResponse.status) {
      //   await Preferences.clear();
      //   // Clear stored user details
      //   Routes.closeAllAndGoTo(Screens.login, arguments: false);
      //   showSnackBar(logoutResponse.message.toString());
      //   emit(LoginLogoutState());
      // } else {
      //   emit(LoginErrorState(logoutResponse.message));
      // }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
  //

  // delete user

  Future<void> deleteUser(String status) async {
    emit(LoginLoadingState());
    try {
      final message = await _repository.deleteUser(status);
      await Preferences.clear();
      // Clear stored user details

      emit(LoginDeleteUserState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    emit(LoginLoadingState());
    try {
      String message = await _repository.forgotPassword(email: email);
      emit(ForgetPassEmailSentLoadState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> verifyForgotPasswordOTP({
    required String email,
    required int otp,
  }) async {
    emit(LoginLoadingState());
    try {
      String message = await _repository.verifyForgotPasswordOTP(
        email: email,
        otp: otp,
      );
      emit(ForgetPassOtpVerifyLoadState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> changeForgottenPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(LoginLoadingState());
    try {
      // Call the changeForgottenPassword function from the repository
      String message = await _repository.changeForgottenPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      emit(ForgetPasswordChangedState(message));
    } catch (e) {
      // Handle the error scenario or update the UI as needed
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> getChangePhoneOtp() async {
    emit(LoginLoadingState());
    try {
      // Call the repository function to get OTP for changing the phone number
      String message = await _repository.getChangePhoneOtp();

      // Emit a state indicating success or handle the OTP as needed
      // For example, you might want to navigate to the next screen with the OTP
      emit(ChangePhoneOtpSentLoadState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> verifyChangePhoneOtp({required int otp}) async {
    emit(LoginLoadingState());
    try {
      String message = await _repository.verifyChangePhoneOtp(otp: otp);

      // Check the response message and perform actions accordingly
      emit(ChangePhoneOtpVerifyLoadState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> changePhoneNumber({required String phone}) async {
    emit(LoginLoadingState());
    try {
      String message = await _repository.changePhoneNumber(phone: phone);
      CoachModel coachModel =
          await _repository.fetchUserInfo(token: accessToken);

      myCoach = coachModel;

      emit(ChangedPhoneChangedState(message));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  // thirdpartylogin

  Future<void> thirdPartyLogin(bool isGoogle) async {
    emit(ThirdPartyLoginLoadingState());
    try {
      AuthServices authServices = AuthServices();

      if (isGoogle == true) {
        UserCredential userCredential = await authServices.signInWithGoogle();

        ApiResponse apiResponse = await _repository
            .thirdPatryUserCheck(userCredential.user?.email ?? "");

        if (apiResponse.status == true) {
          LoginModel loginModel =
              LoginModel.fromJson(apiResponse.data as Map<String, dynamic>);

          CoachModel coachModel = await _repository.fetchUserInfo(
              token: loginModel.accessToken ?? '');

          await Preferences.saveAccessToken(loginModel.accessToken ?? "");

          await Preferences.saveGoogleAccessToken(
              userCredential.credential?.accessToken ?? "");

          // myuid = generateUnique9DigitNumber(loginModel.uid??123456789);
          myuid = loginModel.uid;

          List<OfferingsModel> allOffering =
              await _repository.fetchAllOffering();

          myOfferings = allOffering;
          //to locally store the user model
          myCoach = coachModel;
          if (myCoach?.profile?.areaOfSpecialization?.health?.id != null) {
            profiles.add((myCoach?.profile?.areaOfSpecialization?.health));
            if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
                true) {
              profiles
                  .add((myCoach?.profile?.areaOfSpecialization?.special?[0]));
            }
          } else {
            if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
                true) {
              profiles.addAll(
                  myCoach?.profile?.areaOfSpecialization?.special ?? []);
            }
          }
          emit(ThridPartyLoginLoadedState(coachModel));
        } else {
          ThirdPartyLoginModel loginModel = ThirdPartyLoginModel.fromJson(
              apiResponse.data as Map<String, dynamic>);

          if (loginModel.isFirstUser == true) {
            emit(ThridPartySignUpLoadedState(userCredential.user?.email ?? ""));
          } else {
            emit(ThridPartyEmailNotVerifiedLoadedState(
                apiResponse.message.toString()));
          }
        }
      } else {
        UserCredential userCredential = await authServices.signInWithApple();

        ApiResponse apiResponse = await _repository
            .thirdPatryUserCheck(userCredential.user?.email ?? "");

        if (apiResponse.status == true) {
          LoginModel loginModel =
              LoginModel.fromJson(apiResponse.data as Map<String, dynamic>);

          CoachModel coachModel = await _repository.fetchUserInfo(
              token: loginModel.accessToken ?? '');

          await Preferences.saveAccessToken(loginModel.accessToken ?? "");

          // myuid = generateUnique9DigitNumber(loginModel.uid??123456789);
          myuid = loginModel.uid;

          List<OfferingsModel> allOffering =
              await _repository.fetchAllOffering();

          myOfferings = allOffering;
          //to locally store the user model
          myCoach = coachModel;
          if (myCoach?.profile?.areaOfSpecialization?.health?.id != null) {
            profiles.add((myCoach?.profile?.areaOfSpecialization?.health));
            if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
                true) {
              profiles
                  .add((myCoach?.profile?.areaOfSpecialization?.special?[0]));
            }
          } else {
            if (myCoach?.profile?.areaOfSpecialization?.special?.isNotEmpty ==
                true) {
              profiles.addAll(
                  myCoach?.profile?.areaOfSpecialization?.special ?? []);
            }
          }
          emit(ThridPartyLoginLoadedState(coachModel));
        } else {
          ThirdPartyLoginModel loginModel = ThirdPartyLoginModel.fromJson(
              apiResponse.data as Map<String, dynamic>);

          if (loginModel.isFirstUser == true) {
            emit(ThridPartySignUpLoadedState(userCredential.user?.email ?? ""));
          } else {
            emit(ThridPartyEmailNotVerifiedLoadedState(
                apiResponse.message.toString()));
          }
        }
      }
    } catch (e) {
      emit(ThirdPartyErrorState(e.toString()));
    }
  }
}
