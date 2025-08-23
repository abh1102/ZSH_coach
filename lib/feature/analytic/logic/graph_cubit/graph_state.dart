part of 'graph_cubit.dart';

abstract class GraphState {}

class GraphInitialState extends GraphState {}

class GraphLoadingState extends GraphState {}

class GraphPayoutLoadingState extends GraphState {}

class GraphLoadedState extends GraphState {
  final CoachRatingModel chart;
  final List<SalesData> weekly;
  final List<SalesData> monthly;
  final List<SalesData> yearly;

  GraphLoadedState(this.chart, this.weekly, this.monthly, this.yearly);
}

class GraphPayoutLoadedState extends GraphState {
  final CoachPayoutModel chart;
  final List<SalesData> weekly;
  final List<SalesData> monthly;
  final List<SalesData> yearly;

  GraphPayoutLoadedState(this.chart, this.weekly, this.monthly, this.yearly);
}

class GraphErrorState extends GraphState {
  final String error;
  GraphErrorState(this.error);
}

class GraphPayoutErrorState extends GraphState {
  final String error;
  GraphPayoutErrorState(this.error);
}
