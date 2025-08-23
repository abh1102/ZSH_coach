import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/session/data/model/accept_one_session_model.dart';
import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';
import 'package:zanadu_coach/feature/session/data/model/weekly_schedule_model.dart';
import 'package:zanadu_coach/feature/session/data/repository/all_session_repository.dart';

part 'session_state.dart';

class AllSessionCubit extends Cubit<AllSessionState> {
  AllSessionCubit() : super(AllSessionInitialState());

  final AllSessionRepository _repository = AllSessionRepository();

  Future<void> fetchSessionByCoach() async {
    emit(AllSessionLoadingState());
    try {
      List<Sessions> groupSessions = [];
      List<Sessions> oneToOneSessions = [];
      List<Sessions> orientations = [];
      List<Sessions>? mySessions = [];

      AllSessionModel allSessions = await _repository.getSessionByCoach();

      mySessions = allSessions.sessions;

      groupSessions = allSessions.sessions!
          .where((session) =>
              session.sessionType == "GROUP" || session.sessionType == "YOGA")
          .toList();

      oneToOneSessions = allSessions.sessions!
          .where((session) =>
              session.sessionType == "DISCOVERY" ||
              session.sessionType == "FOLLOW_UP")
          .toList();

      orientations = allSessions.sessions!
          .where((session) => session.sessionType == "ORIENTATION")
          .toList();

      emit(AllSessionLoadedState(
        groupSessions,
        orientations,
        oneToOneSessions,
        mySessions ?? [],
      ));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  Future<void> createSession({
    required String sessionType,
    required String title,
    required String description,
    required String offeringId,
    required String startDate,
    required int noOfSlots,
    required String coachId,
  }) async {
    emit(AllSessionLoadingState());
    try {
      String message = await _repository.createSession(
        offeringId: offeringId,
        sessionType: sessionType,
        title: title,
        description: description,
        startDate: startDate,
        noOfSlots: noOfSlots,
        coachId: coachId,
      );

      emit(AllSessionCreatedState(message: message, sessionType: sessionType));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  // create one and one session

  Future<void> createOneOnOneSession({
    required String sessionType,
    required String title,
    required String description,
    required String startDate,
    required int noOfSlots,
    required String coachId,
    required String offeringId,
    required String userId,
  }) async {
    emit(AllSessionLoadingState());
    try {
      String message = await _repository.createOneOnOneSession(
        offeringId: offeringId,
        sessionType: sessionType,
        title: title,
        description: description,
        startDate: startDate,
        noOfSlots: noOfSlots,
        coachId: coachId,
        userId: userId,
      );

      emit(AllSessionCreatedState(message: message, sessionType: sessionType));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  Future<void> getAcceptSession() async {
    emit(AllSessionLoadingState());
    try {
      AcceptModel accept = await _repository.getOneSessionAccep();
      print("kkhjkh");
      emit(AcceptOneSessionLoadedState(
          acceptOneSessions: accept.sessions ?? []));
      print("khkjhkj");
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  Future<void> rescheduleSession({
    required String sessionId,
    required String startDate,
    required String reasonMessage,
  }) async {
    emit(AllSessionRescheduleLoadingState());
    try {
      String message = await _repository.rescheduleSession(
        sessionId,
        startDate,
        reasonMessage,
      );
      print("Reschedule Session Response: $message");
      emit(AllSessionRescheduledState(message: message));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  // function for cancel session

  Future<void> cancelSession({
    required String sessionId,
    required String reasonMessage,
  }) async {
    emit(AllSessionCancelLoadingState());
    try {
      String message = await _repository.cancelSession(
        sessionId,
        reasonMessage,
      );

      emit(AllSessionCancelState(message: message));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  // get available of the week
  Future<void> getAvailableWeek({
    required String date,
  }) async {
    emit(AllSessionWeeklyLoadingState());
    try {
      List<WeeklyScheduleModel> weekTimings =
          await _repository.getScheduleWeek(date);

      emit(GetAvailableWeekState(weekTimings: weekTimings));
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }

  // deleting time slot

  Future<void> removeTimeSlot({
    required String coachId,
    required String date,
    required String timeSlotId,
  }) async {
    emit(AllSessionDeletingTimeSlotState());
    try {
      await _repository.removeTimeSlot(
        coachId: coachId,
        date: date,
        timeSlotId: timeSlotId,
      );

      getAvailableWeek(date: date);
    } catch (e) {
      emit(AllSessionErrorState(e.toString()));
    }
  }
}