import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/feature/analytic/data/model/attendance_model.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/data/repository/analytic_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitialState());

  final AnalyticRepository _repository = AnalyticRepository();

  

  Future<void> fetchAttendanceAttendance() async {
    emit(AttendanceLoadingState());
    try {
      CoachAttendanceModel charts = await _repository.getCoachAttendanceChart();

      emit(AttendanceAttendanceLoadedState(
        charts,
        charts.wEEKLY?.map((weeklyData) {
              return SalesData(
                formatDateInMmDd(weeklyData.createdAt.toString()),
                weeklyData.attend ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.mONTHLY?.map((monthlyData) {
              return SalesData(
                monthlyData.createdAt.toString(),
                monthlyData.attend ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.yEARLY?.map((yearlyData) {
              return SalesData(
                yearlyData.createdAt.toString(),
                yearlyData.attend ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
      ));
    } catch (e) {
      emit(AttendanceErrorState(e.toString()));
    }
  }
}

String formatDateInMmDd(String? dateTimeString) {
  if (dateTimeString != null) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MM-dd').format(dateTime);
  }
  return "";
}
