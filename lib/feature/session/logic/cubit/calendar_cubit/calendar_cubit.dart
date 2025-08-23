import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';
import 'package:zanadu_coach/feature/session/data/model/calendar_available_model.dart';
import 'package:zanadu_coach/feature/session/data/repository/all_session_repository.dart';
import 'package:zanadu_coach/feature/session/logic/provider/session_provider.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitialState());

  final AllSessionRepository _repository = AllSessionRepository();

  Future<void> getCalendarData([DateTime? date]) async {
    emit(CalendarLoadingState());
    try {
      var provider =
          Provider.of<SessionProvider>(Routes.currentContext, listen: false);

      List<CalendarAvailableModel> calendars =
          await _repository.getAvailableDates(date);
      for (var date in calendars) {
        final startTime = DateFormat('yyyy-MM-dd').parse(date.date!);

        // Check if the timeSlots list is not empty
        bool isAvailable = date.timeSlots != null && date.timeSlots!.isNotEmpty;

        final newAppointment = Appointment(
          startTime: startTime,
          endTime: startTime,
          color: isAvailable ? AppColors.primaryGreen : Colors.transparent,
          isAllDay: true,
        );

        provider.addAppointment(newAppointment, isAvailable: isAvailable);
      }

      // Update the data source after adding appointments
      provider.updateCalendarDataSource();
      emit(CalendarLoadedState(calendars));
    } catch (e) {
      emit(CalendarErrorState(e.toString()));
    }
  }

  Future<void> createCalendarDates({
    required String type,
    List<int>? days,
    required String startDate,
    required String endDate,
    required List<Map<String, dynamic>> timeSlots,
  }) async {
    emit(CalendarLoadingState());
    try {
      String message = await _repository.createCalendarDate(
        type: type,
        days: days,
        startDate: startDate,
        endDate: endDate,
        timeSlots: timeSlots,
      );

      emit(CalendarUpadatedLoadedState(message));
    } catch (e) {
      emit(CalendarErrorState(e.toString()));
    }
  }

  Future<void> getScheduleSession(String date) async {
    emit(CalendarScheduleLoadingState());
    try {
      List<Sessions> sessions = await _repository.getScheduleSessions(date);

      emit(CalendarScheduleSessionLoadedState(sessions));
    } catch (e) {
      emit(CalendarErrorState(e.toString()));
    }
  }

  // get calendar
}
