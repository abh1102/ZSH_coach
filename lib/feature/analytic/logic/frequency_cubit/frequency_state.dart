part of 'frequency_cubit.dart';

abstract class FrequencyState {}

class FrequencyInitialState extends FrequencyState {}

class FrequencyLoadingState extends FrequencyState {}

class FrequencyLoadedState extends FrequencyState {
  final CoachFrequencyModel chart;
  final List<SalesData> weekly;
  final List<SalesData> monthly;
  final List<SalesData> yearly;
  final List<SalesData> gweekly;
  final List<SalesData> gmonthly;
  final List<SalesData> gyearly;
  final List<SalesData> oweekly;
  final List<SalesData> omonthly;
  final List<SalesData> oyearly;

  FrequencyLoadedState(
      this.chart,
      this.weekly,
      this.monthly,
      this.yearly,
      this.gweekly,
      this.gmonthly,
      this.gyearly,
      this.oweekly,
      this.omonthly,
      this.oyearly);
}

class FrequencyErrorState extends FrequencyState {
  final String error;
  FrequencyErrorState(this.error);
}
