import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/provider/session_provider.dart';

class CalendarContainer extends StatefulWidget {
  final SessionProvider sessionProvider;
  final CalendarCubit calendarCubit;
  const CalendarContainer({
    super.key,
    required this.sessionProvider,
    required this.calendarCubit,
  });

  @override
  State<CalendarContainer> createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  String? selectedDateText;
  String? selectedEndDateText;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isAvailable = false;

  String formatSelectedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBlue,
        border: Border.all(color: AppColors.textDark),
      ),
      child: SfCalendar(
          monthCellBuilder: (BuildContext context, MonthCellDetails details) {
            final SessionProvider sessionProvider =
                Provider.of<SessionProvider>(context);
            final List<Appointment> appointments =
                details.appointments.cast<Appointment>().toList();
            final isUnavailableDate = appointments.isNotEmpty &&
                appointments.any(
                  (appointment) => sessionProvider.unavailableAppointments
                      .contains(appointment),
                );

            final isAvailableDate = appointments.isNotEmpty &&
                appointments.any(
                  (appointment) =>
                      sessionProvider.appointments.contains(appointment),
                );

            final isAppointmentDate = appointments.isNotEmpty &&
                appointments.any(
                  (appointment) =>
                      sessionProvider.appointments.contains(appointment),
                );

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isUnavailableDate
                        ? Colors.grey
                        : isAvailableDate
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    details.date.day.toString(), // Display the day of the month
                    style: TextStyle(
                      color: isAppointmentDate
                          ? Colors.white
                          : Colors.black, // Customize the text color
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
          initialDisplayDate: widget.sessionProvider.visibleMonth,
          todayHighlightColor: Colors.transparent,
          // todayTextStyle:
          //     const TextStyle(color: Colors.black, fontSize: 15),
          key: widget.sessionProvider.dataSourceKey,
          onViewChanged: (ViewChangedDetails viewChangedDetails) {
            // Check if the view changed is due to user interaction (swiping)

            var myD = (viewChangedDetails.visibleDates.length / 2).floor();

            DateTime middleDate = viewChangedDetails.visibleDates[myD];

            if (widget.sessionProvider.visibleMonth.month != middleDate.month) {
              print("iiiiiiiiiiiiiiiiiiiiiiiiiiii");
              // Check if the API has already been called for the visible month
              widget.sessionProvider.visibleMonth = middleDate;

              // Hit the API only if it hasn't been called for this month
              widget.calendarCubit.getCalendarData(middleDate);
            }
          },
          view: CalendarView.month,
          dataSource: widget.sessionProvider.dataSource,
          selectionDecoration: const BoxDecoration(color: Colors.transparent),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: false, // Remove the grid view
            navigationDirection: MonthNavigationDirection.horizontal,
            appointmentDisplayCount: 4, // Adjust this value as needed
          ),
          cellBorderColor: Colors.transparent,
          headerStyle: const CalendarHeaderStyle(
            textStyle: TextStyle(fontSize: 16),
            textAlign: TextAlign.center, // Center align month name
          ),
          showNavigationArrow: true,
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.calendarCell) {
              final selectedDate = details.date;
              final isAvailableDateSelected =
                  widget.sessionProvider.appointments.any((appointment) {
                return appointment.startTime.year == selectedDate!.year &&
                    appointment.startTime.month == selectedDate.month &&
                    appointment.startTime.day == selectedDate.day;
              });

              final isUnavailableDateSelected = widget
                  .sessionProvider.unavailableAppointments
                  .any((appointment) {
                return appointment.startTime.year == selectedDate!.year &&
                    appointment.startTime.month == selectedDate.month &&
                    appointment.startTime.day == selectedDate.day;
              });

              if (isAvailableDateSelected && !isUnavailableDateSelected) {
                // Open a new dialog for available dates

                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate!);

                Routes.goTo(Screens.schedule, arguments: formattedDate);
                //   oneTextDialog(context);
              } else {
                Routes.goTo(Screens.reminderScreen);
                // Show remainder dialog for all other dates
                // showReminderDialog(context, widget.sessionProvider);
              }
            }
          }),
    );
  }
}

bool isCurrentMonth(DateTime date) {
  return DateTime.now().month == date.month && DateTime.now().year == date.year;
}
