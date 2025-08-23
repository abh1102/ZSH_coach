part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class ThirdPartyLoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {
  final CoachModel coach;
  LoginLoadedState(this.coach);
}

class ThridPartyLoginLoadedState extends LoginState {
  final CoachModel coach;
  ThridPartyLoginLoadedState(this.coach);
}

class ThridPartySignUpLoadedState extends LoginState {
  final String message;
  ThridPartySignUpLoadedState(this.message);
}

class ThridPartyEmailNotVerifiedLoadedState extends LoginState {
  final String message;
  ThridPartyEmailNotVerifiedLoadedState(this.message);
}

class PasswordChangedState extends LoginState {
  final String message;
  PasswordChangedState(this.message);
}

class UserUpdatedState extends LoginState {
  final CoachModel coach;
  UserUpdatedState(this.coach);
}

class SignedUrlLoadedState extends LoginState {
  final String signedUrl;

  SignedUrlLoadedState(this.signedUrl);
}

class LoginDeleteUserState extends LoginState {
  final String message;

  LoginDeleteUserState(this.message);
}

class LoginLogoutState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

class ForgetPasswordChangedState extends LoginState {
  final String message;
  ForgetPasswordChangedState(this.message);
}

class ForgetPassEmailSentLoadState extends LoginState {
  final String message;
  ForgetPassEmailSentLoadState(this.message);
}

class ChangePhoneOtpSentLoadState extends LoginState {
  final String message;
  ChangePhoneOtpSentLoadState(this.message);
}

class ForgetPassOtpVerifyLoadState extends LoginState {
  final String message;
  ForgetPassOtpVerifyLoadState(this.message);
}

class ChangePhoneOtpVerifyLoadState extends LoginState {
  final String message;
  ChangePhoneOtpVerifyLoadState(this.message);
}

class ChangedPhoneChangedState extends LoginState {
  final String message;
  ChangedPhoneChangedState(this.message);
}

class SignedUrlErrorState extends LoginState {
  final String error;

  SignedUrlErrorState(this.error);
}

class ThirdPartyErrorState extends LoginState {
  final String error;

  ThirdPartyErrorState(this.error);
}
