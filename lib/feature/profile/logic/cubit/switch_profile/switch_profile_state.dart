part of 'switch_profile_cubit.dart';

abstract class SwitchProfileState {}

class SwitchProfileInitialState extends SwitchProfileState {}

class SwitchProfileLoadingState extends SwitchProfileState {}

class SwitchProfileLoadedState extends SwitchProfileState {
  final String message;

  SwitchProfileLoadedState(this.message);
}

// Add this to SwitchProfile_state.dart

class SwitchProfileErrorState extends SwitchProfileState {
  final String error;
  SwitchProfileErrorState(this.error);
}
