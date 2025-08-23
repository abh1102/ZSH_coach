import 'package:intl/intl.dart';

String myformattedDate(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime startDate = DateTime.parse(date);
  DateTime localStartDate = startDate.toLocal();
  String formattedDate = DateFormat('MM-dd-yyyy').format(localStartDate);
  return formattedDate;
}

String convertUtcToLocalTime(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime);
    final localDateTime = utcDateTime.toLocal();
    return DateFormat.jm().format(localDateTime);
  }

String myformattedTime(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime startDate = DateTime.parse(date);
  DateTime localStartDate = startDate.toLocal();
  String formattedTime = DateFormat.jm().format(localStartDate);
  return formattedTime;
}

bool getDifferenceBool(String date) {
  if (date.isEmpty) {
    return false;
  }
  DateTime startDate = DateTime.parse(date);
  DateTime localStartDate = startDate.toLocal();
  Duration difference = localStartDate.difference(DateTime.now());

// Check if the difference is less than 30 minutes
  bool isStartNow = difference.inMinutes < 30;

  return isStartNow;
}

bool getDifferenceBoolPastSession(String date) {
  if (date.isEmpty) {
    return false;
  }
  DateTime startDate = DateTime.parse(date);
  DateTime localStartDate = startDate.toLocal();
  DateTime now = DateTime.now();

  // Check if the current time is 55 minutes or more after the specified date and time
  bool isStartNow = now.isAfter(localStartDate.add(Duration(minutes: 55)));

  return isStartNow;
}
