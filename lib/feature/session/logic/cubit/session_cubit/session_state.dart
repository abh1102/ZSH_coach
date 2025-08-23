part of 'session_cubit.dart';

abstract class AllSessionState {}

class AllSessionInitialState extends AllSessionState {}

class AllSessionLoadingState extends AllSessionState {}

class AllSessionWeeklyLoadingState extends AllSessionState {}

class AllSessionCancelLoadingState extends AllSessionState {}

class AllSessionRescheduleLoadingState extends AllSessionState {}

class AllSessionLoadedState extends AllSessionState {
  final List<Sessions> groupSessions;
  final List<Sessions> orientations;
  final List<Sessions> oneToOneSessions;
  final List<Sessions> allSessions;

  AllSessionLoadedState(
    this.groupSessions,
    this.orientations,
    this.oneToOneSessions,
    this.allSessions,
  );
}

class AllSessionCreatedState extends AllSessionState {
  final String message;
  final String sessionType;

  AllSessionCreatedState({
    required this.message,
    required this.sessionType,
  });
}

class AcceptOneSessionLoadedState extends AllSessionState {
  final List<Sessions> acceptOneSessions;

  AcceptOneSessionLoadedState({required this.acceptOneSessions});
}

class GetAvailableWeekState extends AllSessionState {
  final List<WeeklyScheduleModel> weekTimings;

  GetAvailableWeekState({required this.weekTimings});
}

class AllSessionRescheduledState extends AllSessionState {
  final String message;

  AllSessionRescheduledState({required this.message});
}

class AllSessionCancelState extends AllSessionState {
  final String message;

  AllSessionCancelState({required this.message});
}

class AllSessionErrorState extends AllSessionState {
  final String error;
  AllSessionErrorState(this.error);
}


class AllSessionDeletingTimeSlotState extends AllSessionState {}
class AllSessionDeletedTimeSlotState extends AllSessionState {
  final String message;
  
  AllSessionDeletedTimeSlotState({required this.message});
}