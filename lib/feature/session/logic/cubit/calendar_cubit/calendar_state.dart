part of 'calendar_cubit.dart';

abstract class CalendarState {}

class CalendarInitialState extends CalendarState {}

class CalendarLoadingState extends CalendarState {}
class CalendarScheduleLoadingState extends CalendarState {}

class CalendarLoadedState extends CalendarState {
  final List<CalendarAvailableModel> calendars;

  CalendarLoadedState(this.calendars);
}

class CalendarUpadatedLoadedState extends CalendarState {
  final String msg;

  CalendarUpadatedLoadedState(this.msg);
}

class CalendarScheduleSessionLoadedState extends CalendarState {
  final List<Sessions> sessions;

  CalendarScheduleSessionLoadedState(this.sessions);
}

class CalendarErrorState extends CalendarState {
  final String error;
  CalendarErrorState(this.error);
}
