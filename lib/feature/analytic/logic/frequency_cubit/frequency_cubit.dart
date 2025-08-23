import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/feature/analytic/data/model/frequency_model.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/data/repository/analytic_repository.dart';

part 'frequency_state.dart';

class FrequencyCubit extends Cubit<FrequencyState> {
  FrequencyCubit() : super(FrequencyInitialState());

  final AnalyticRepository _repository = AnalyticRepository();

  Future<void> fetchFrequencyFrequency() async {
    emit(FrequencyLoadingState());
    try {
      CoachFrequencyModel charts = await _repository.getCoachFrequency();

      var gw = charts.gROUP!.wEEKLY?.map((weeklyData) {
            return SalesData(
              formatDateInMmDd(weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      var gm = charts.gROUP!.mONTHLY?.map((weeklyData) {
            return SalesData(
              (weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      var gy = charts.gROUP!.yEARLY?.map((weeklyData) {
            return SalesData(
              (weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      var ow = charts.oNEONONE!.wEEKLY?.map((weeklyData) {
            return SalesData(
              formatDateInMmDd(weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      var om = charts.oNEONONE!.mONTHLY?.map((weeklyData) {
            return SalesData(
              (weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      var oy = charts.oNEONONE!.yEARLY?.map((weeklyData) {
            return SalesData(
              (weeklyData.createdAt.toString()),
              weeklyData.count ??
                  0, // No need to convert to double, num accommodates both
              0, // You can replace 0 with the actual index if needed
            );
          }).toList() ??
          [];

      emit(FrequencyLoadedState(
        charts,
        charts.oRIENTATION!.wEEKLY?.map((weeklyData) {
              return SalesData(
                formatDateInMmDd(weeklyData.createdAt.toString()),
                weeklyData.count ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.oRIENTATION!.mONTHLY?.map((monthlyData) {
              return SalesData(
                monthlyData.createdAt.toString(),
                monthlyData.count ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.oRIENTATION!.yEARLY?.map((yearlyData) {
              return SalesData(
                yearlyData.createdAt.toString(),
                yearlyData.count ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        gw,
        gm,
        gy,
        ow,
        om,
        oy,
      ));
    } catch (e) {
      emit(FrequencyErrorState(e.toString()));
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
