// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:zanadu_coach/core/constants.dart';
// import 'package:zanadu_coach/core/routes.dart';
// import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';
// import 'package:zanadu_coach/feature/session/logic/provider/session_provider.dart';

// class CalendarContainer extends StatefulWidget {
  
//   final SessionProvider sessionProvider;
//   const CalendarContainer({super.key, required this.sessionProvider, });

//   @override
//   State<CalendarContainer> createState() => _CalendarContainerState();
// }

// class _CalendarContainerState extends State<CalendarContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: AppColors.lightBlue,
//         border: Border.all(color: AppColors.textDark),
//       ),
//       child: SfCalendar(
//           monthCellBuilder: (BuildContext context, MonthCellDetails details) {
//             final SessionProvider sessionProvider =
//                 Provider.of<SessionProvider>(context);
//             final List<Appointment> appointments =
//                 details.appointments.cast<Appointment>().toList();
//             final isUnavailableDate = appointments.isNotEmpty &&
//                 appointments.any(
//                   (appointment) => sessionProvider.unavailableAppointments
//                       .contains(appointment),
//                 );

//             final isAvailableDate = appointments.isNotEmpty &&
//                 appointments.any(
//                   (appointment) =>
//                       sessionProvider.appointments.contains(appointment),
//                 );

//             final isAppointmentDate = appointments.isNotEmpty &&
//                 appointments.any(
//                   (appointment) =>
//                       sessionProvider.appointments.contains(appointment),
//                 );

//             return Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isUnavailableDate
//                         ? Colors.grey
//                         : isAvailableDate
//                             ? AppColors.primaryGreen
//                             : Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     details.date.day.toString(), // Display the day of the month
//                     style: TextStyle(
//                       color: isAppointmentDate
//                           ? Colors.white
//                           : Colors.black, // Customize the text color
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//           todayHighlightColor: Colors.transparent,
//           todayTextStyle: const TextStyle(color: Colors.black),
//           key: widget.sessionProvider.dataSourceKey,
//           view: CalendarView.month,
//           dataSource: widget.sessionProvider.dataSource,
//           selectionDecoration: const BoxDecoration(color: Colors.transparent),
//           monthViewSettings: const MonthViewSettings(
//             appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//             showAgenda: false, // Remove the grid view
//             navigationDirection: MonthNavigationDirection.horizontal,
//             appointmentDisplayCount: 4, // Adjust this value as needed
//           ),
//           cellBorderColor: Colors.transparent,
//           headerStyle: const CalendarHeaderStyle(
//             textAlign: TextAlign.center, // Center align month name
//           ),
//           showNavigationArrow: true,
//           onTap: (CalendarTapDetails details) {
//             if (details.targetElement == CalendarElement.calendarCell) {
//               final selectedDate = details.date;
//               final isAvailableDateSelected =
//                   widget.sessionProvider.appointments.any((appointment) {
//                 return appointment.startTime.year == selectedDate!.year &&
//                     appointment.startTime.month == selectedDate.month &&
//                     appointment.startTime.day == selectedDate.day;
//               });

//               final isUnavailableDateSelected = widget
//                   .sessionProvider.unavailableAppointments
//                   .any((appointment) {
//                 return appointment.startTime.year == selectedDate!.year &&
//                     appointment.startTime.month == selectedDate.month &&
//                     appointment.startTime.day == selectedDate.day;
//               });

//               if (isAvailableDateSelected && !isUnavailableDateSelected) {
//                 // Open a new dialog for available dates
//                // Routes.goTo(Screens.schedule,arguments: widget.sessions);
//                 //   oneTextDialog(context);
//               } else {
//                 // Show remainder dialog for all other dates
//                 widget.sessionProvider.showReminderDialog(context);
//               }
//             }
//           }),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:zanadu_coach/core/constants.dart';
// import 'package:zanadu_coach/feature/session/widgets/custom_switch.dart';

// class SessionProvider extends ChangeNotifier {


//   List<Appointment> appointments = <Appointment>[];
//   List<Appointment> unavailableAppointments = <Appointment>[];

//   // Define a data source and initialize it with the appointments
//   CalendarDataSource dataSource = AppointmentDataSource(<Appointment>[]);
//   UniqueKey dataSourceKey = UniqueKey(); // Add a UniqueKey

//   void addAppointment(Appointment newAppointment, {bool isAvailable = true}) {
//     // Remove any existing appointments with the same start and end times
//     appointments.removeWhere((existingAppointment) =>
//         existingAppointment.startTime == newAppointment.startTime &&
//         existingAppointment.endTime == newAppointment.endTime);

//     unavailableAppointments.removeWhere((existingAppointment) =>
//         existingAppointment.startTime == newAppointment.startTime &&
//         existingAppointment.endTime == newAppointment.endTime);

//     if (!isAvailable) {
//       // If it's an unavailable appointment, add it to the unavailableAppointments list
//       unavailableAppointments.add(newAppointment);
//     }
//     // Add the new appointment
//     appointments.add(newAppointment);

//     // Update the data source
//     dataSource.appointments = appointments.toList();
//     updateCalendarDataSource();

//     notifyListeners();
//   }

//   void removeAppointments(DateTime startDate, DateTime endDate) {
//     appointments.removeWhere((appointment) =>
//         appointment.startTime.isAfter(startDate) &&
//         appointment.endTime.isBefore(endDate));

//     notifyListeners();
//     // Update the data source when removing appointments
//     dataSource.appointments!.removeWhere((appointment) =>
//         appointment.startTime.isAfter(startDate) &&
//         appointment.endTime.isBefore(endDate));
//     updateCalendarDataSource();
//     notifyListeners();
//   }

//   void updateCalendarDataSource() {
//     dataSourceKey = UniqueKey(); // Create a new UniqueKey
//     notifyListeners();
//   }

//   String? selectedDateText;
//   String? selectedEndDateText;
//   DateTime? selectedStartDate;
//   DateTime? selectedEndDate;

//   bool isAvailable = false;

//   String formatSelectedDate(DateTime date) {
//     final day = date.day.toString().padLeft(2, '0');
//     final month = date.month.toString().padLeft(2, '0');
//     final year = date.year.toString();
//     return '$day-$month-$year';
//   }

//   void showReminderDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             DateTime selectedDate = DateTime.now();

//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(20.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15.0),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF25D366),
//                       Color(0xFF03C0FF),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: SvgPicture.asset(
//                             "assets/icons/Vector.svg",
//                             width: 24.0,
//                             height: 24.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                     height(24),
//                     Center(
//                       child: heading1Text(
//                         "Mark Availability",
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 64.h),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16.w,
//                         vertical: 10.h,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           body1Text(
//                             selectedDateText ?? "Start Date",
//                             color: Colors.black,
//                           ),
//                           IconButton(
//                             icon: SvgPicture.asset(
//                                 "assets/icons/calendar(1).svg"),
//                             onPressed: () async {
//                               final DateTime? picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: selectedDate,
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (picked != null) {
//                                 setState(() {
//                                   selectedStartDate = picked;
//                                   selectedDate = picked;
//                                   selectedDateText = formatSelectedDate(picked);
//                                 });
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     height(28),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16.w,
//                         vertical: 10.h,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           body1Text(
//                             selectedEndDateText ?? "End Date",
//                             color: Colors.black,
//                           ),
//                           IconButton(
//                             icon: SvgPicture.asset(
//                                 "assets/icons/calendar(1).svg"),
//                             onPressed: () async {
//                               final DateTime? picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: selectedDate,
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (picked != null) {
//                                 setState(
//                                   () {
//                                     selectedEndDate = picked;
//                                     selectedDate = picked;
//                                     selectedEndDateText =
//                                         formatSelectedDate(picked);
//                                   },
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     height(28),
//                     CustomSwitch(
//                         value: isAvailable,
//                         onChanged: (value) {
//                           setState(() {
//                             isAvailable = value;
//                           });
//                         }),
//                     height(64),
//                     GestureDetector(
//                       onTap: () {
//                         if (isAvailable &&
//                             selectedStartDate != null &&
//                             selectedEndDate != null) {
//                           // Mark available dates as green
//                           final newAppointment = Appointment(
//                             startTime: selectedStartDate!,
//                             endTime: selectedEndDate!,
//                             color: Colors.transparent,
//                             isAllDay: true,
//                           );
//                           addAppointment(newAppointment, isAvailable: true);
//                         } else if (!isAvailable &&
//                             selectedStartDate != null &&
//                             selectedEndDate != null) {
//                           // Mark unavailable dates as red
//                           final newAppointment = Appointment(
//                             startTime: selectedStartDate!,
//                             endTime: selectedEndDate!,
//                             color: Colors.transparent,
//                             isAllDay: true,
//                           );
//                           addAppointment(newAppointment, isAvailable: false);
//                         }

//                         // Clear the selected dates

//                         selectedDateText = null;
//                         selectedEndDateText = null;

//                         updateCalendarDataSource();
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(
//                             30,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 122.w,
//                           vertical: 8.h,
//                         ),
//                         alignment: Alignment.center,
//                         child: simpleText(
//                           "Done",
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     height(20),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class AppointmentDataSource extends CalendarDataSource {
//   AppointmentDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
