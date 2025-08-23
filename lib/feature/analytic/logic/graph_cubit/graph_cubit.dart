import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/feature/analytic/data/model/payout_model.dart';
import 'package:zanadu_coach/feature/analytic/data/model/rating_model.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/data/repository/analytic_repository.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit() : super(GraphInitialState());

  final AnalyticRepository _repository = AnalyticRepository();

  Future<void> fetchGraph() async {
    emit(GraphLoadingState());
    try {
      CoachRatingModel charts = await _repository.getCoachRatingChart();

      emit(GraphLoadedState(
        charts,
        charts.wEEKLY?.map((weeklyData) {
              return SalesData(
                formatDateInMmDd(weeklyData.createdAt.toString()),
                weeklyData.myRating ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.mONTHLY?.map((monthlyData) {
              return SalesData(
                monthlyData.createdAt.toString(),
                monthlyData.myRating ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.yEARLY?.map((yearlyData) {
              return SalesData(
                yearlyData.createdAt.toString(),
                yearlyData.myRating ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
      ));
    } catch (e) {
      emit(GraphErrorState(e.toString()));
    }
  }

  Future<void> fetchGraphPayout() async {
    emit(GraphPayoutLoadingState());
    try {
      CoachPayoutModel charts = await _repository.getCoachPayout();

      emit(GraphPayoutLoadedState(
        charts,
        charts.wEEKLY?.map((weeklyData) {
              return SalesData(
                formatDateInMmDd(weeklyData.createdAt.toString()),
                weeklyData.amount ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.mONTHLY?.map((monthlyData) {
              return SalesData(
                monthlyData.createdAt.toString(),
                monthlyData.amount ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
        charts.yEARLY?.map((yearlyData) {
              return SalesData(
                yearlyData.createdAt.toString(),
                yearlyData.amount ??
                    0, // No need to convert to double, num accommodates both
                0, // You can replace 0 with the actual index if needed
              );
            }).toList() ??
            [],
      ));
    } catch (e) {
      emit(GraphPayoutErrorState(e.toString()));
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
