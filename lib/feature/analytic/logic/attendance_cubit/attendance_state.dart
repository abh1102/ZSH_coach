part of 'attendance_cubit.dart';

abstract class AttendanceState {}

class AttendanceInitialState extends AttendanceState {}

class AttendanceLoadingState extends AttendanceState {}

class AttendanceAttendanceLoadedState extends AttendanceState {
  final CoachAttendanceModel chart;
  final List<SalesData> weekly;
  final List<SalesData> monthly;
  final List<SalesData> yearly;

  AttendanceAttendanceLoadedState(
      this.chart, this.weekly, this.monthly, this.yearly);
}

class AttendanceErrorState extends AttendanceState {
  final String error;
  AttendanceErrorState(this.error);
}
