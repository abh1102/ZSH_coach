import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SessionProvider extends ChangeNotifier {
  List<Appointment> appointments = <Appointment>[];
  List<Appointment> unavailableAppointments = <Appointment>[];
  DateTime visibleMonth = DateTime.now();
  bool isInitialized = false;

  // Define a data source and initialize it with the appointments
  CalendarDataSource dataSource = AppointmentDataSource(<Appointment>[]);
  UniqueKey dataSourceKey = UniqueKey(); // Add a UniqueKey

  void addAppointment(Appointment newAppointment, {bool isAvailable = true}) {
    // Remove any existing appointments with the same start and end times
    appointments.removeWhere((existingAppointment) =>
        existingAppointment.startTime == newAppointment.startTime &&
        existingAppointment.endTime == newAppointment.endTime);

    unavailableAppointments.removeWhere((existingAppointment) =>
        existingAppointment.startTime == newAppointment.startTime &&
        existingAppointment.endTime == newAppointment.endTime);

    if (!isAvailable) {
      // If it's an unavailable appointment, add it to the unavailableAppointments list
      unavailableAppointments.add(newAppointment);
    }
    // Add the new appointment
    appointments.add(newAppointment);

    // Update the data source
    dataSource.appointments = appointments.toList();
    updateCalendarDataSource();

    notifyListeners();
  }

  void removeAppointments(DateTime startDate, DateTime endDate) {
    appointments.removeWhere((appointment) =>
        appointment.startTime.isAfter(startDate) &&
        appointment.endTime.isBefore(endDate));

    notifyListeners();
    // Update the data source when removing appointments
    dataSource.appointments!.removeWhere((appointment) =>
        appointment.startTime.isAfter(startDate) &&
        appointment.endTime.isBefore(endDate));
    updateCalendarDataSource();
    notifyListeners();
  }

  void updateCalendarDataSource() {
    dataSourceKey = UniqueKey(); // Create a new UniqueKey
    notifyListeners();
  }

  void updateMoth(DateTime tim) {
    visibleMonth = tim;
    notifyListeners();
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
