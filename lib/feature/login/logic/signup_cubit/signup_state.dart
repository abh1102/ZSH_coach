part of 'signup_cubit.dart';

abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}


class OfferingLoadingState extends SignUpState {}


class SignUpLoadedState extends SignUpState {
  final String message;
  SignUpLoadedState(this.message);
}



class AllOfferingLoadedState extends SignUpState {
  final List<OfferingsModel> offering;
  AllOfferingLoadedState(this.offering);
}



class SignUpErrorState extends SignUpState {
  final String error;
  SignUpErrorState(this.error);
}



class OfferErrorState extends SignUpState {
  final String error;
  OfferErrorState(this.error);
}


