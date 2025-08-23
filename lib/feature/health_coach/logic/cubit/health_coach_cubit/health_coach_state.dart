part of 'health_coach_cubit.dart';

abstract class FiveHealthCoachState {}

class FiveHealthCoachInitialState extends FiveHealthCoachState {}

class FiveHealthCoachLoadingState extends FiveHealthCoachState {}

class FiveHealthCoachLoadedState extends FiveHealthCoachState {
  final List<AllHealthCoachesModel> healthCoach;
  FiveHealthCoachLoadedState(this.healthCoach);
}

class HealthCoachVideoUploadedState extends FiveHealthCoachState {
  final String message;
  HealthCoachVideoUploadedState(this.message);
}

class FiveHealthCoachErrorState extends FiveHealthCoachState {
  final String error;
  FiveHealthCoachErrorState(this.error);
}
