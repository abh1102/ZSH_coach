
import 'package:intl/intl.dart';

 String formatDate(DateTime? date) {
    if (date != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      return formattedDate;
    }
    return 'Date';
  }


  String formatDateToDDMMYYY(String inputDate) {
    final parsedDate = DateTime.parse(inputDate);
    final formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    return formattedDate;
  }




  String formatDatefromyyyy(String dateStr) {
  // Parse the input date string
  final inputFormat = DateFormat('yyyy-MM-d');
  final DateTime dateTime = inputFormat.parse(dateStr);

  // Format the date in the desired format (dd/MM/yyyy)
  final outputFormat = DateFormat('dd-MM-yyyy');
  return outputFormat.format(dateTime);
}