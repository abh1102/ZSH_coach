import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/logic/attendance_cubit/attendance_cubit.dart';
import 'package:zanadu_coach/feature/analytic/logic/frequency_cubit/frequency_cubit.dart';
import 'package:zanadu_coach/feature/analytic/logic/graph_cubit/graph_cubit.dart';

// ignore: must_be_immutable
class HomeScreenChartContainer extends StatefulWidget {
  final String firstText;
  final String secondText;
  final double interval;
  final VoidCallback? onpressed;
  const HomeScreenChartContainer({
    super.key,
    required this.firstText,
    required this.secondText,
    this.onpressed,
    required this.interval,
  });

  @override
  State<HomeScreenChartContainer> createState() =>
      _HomeScreenChartContainerState();
}

class _HomeScreenChartContainerState extends State<HomeScreenChartContainer> {
  late AttendanceCubit healthChartCubit;

  @override
  void initState() {
    super.initState();
    healthChartCubit = BlocProvider.of<AttendanceCubit>(context);
    healthChartCubit.fetchAttendanceAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (deviceWidth - 80.w) / 2,
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is AttendanceAttendanceLoadedState) {
          return Container(
            alignment: Alignment.center,
            width: deviceWidth - 80.w,
            decoration: BoxDecoration(
                color: const Color(0xffE7F9FA),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: AppColors.greyLight,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: simpleText(
                      widget.firstText,
                      fontSize: 15,
                      color: AppColors.textDark.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                height(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: simpleText(widget.secondText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight.withOpacity(0.8)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: GestureDetector(
                          onTap: widget.onpressed,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              "See Details",
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                height(20),
                SfCartesianChart(
                  primaryYAxis: NumericAxis(
                    maximum: 100,
                    interval: 20,
                  ),
                  primaryXAxis: CategoryAxis(
                      interval: 2,
                      majorTickLines:
                          const MajorTickLines(color: Colors.transparent),
                      majorGridLines: const MajorGridLines(
                          width: 1, color: Colors.transparent),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  series: <CartesianSeries<SalesData, String>>[
                    ColumnSeries<SalesData, String>(
                        dataSource: state.weekly,
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        pointColorMapper: (SalesData data, _) {
                          return AppColors.primaryGreen;
                        },
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false),
                        width: 0.3),
                  ],
                ),
              ],
            ),
          );
        } else if (state is AttendanceErrorState) {
          return simpleText(
            state.error,
            align: TextAlign.center,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class HomeScreenRatingChartContainer extends StatefulWidget {
  final String firstText;
  final String secondText;
  final double interval;
  final VoidCallback? onpressed;
  const HomeScreenRatingChartContainer({
    super.key,
    required this.firstText,
    required this.secondText,
    this.onpressed,
    required this.interval,
  });

  @override
  State<HomeScreenRatingChartContainer> createState() =>
      _HomeScreenRatingChartContainerState();
}

class _HomeScreenRatingChartContainerState
    extends State<HomeScreenRatingChartContainer> {
  late GraphCubit healthChartCubit;

  @override
  void initState() {
    super.initState();
    healthChartCubit = BlocProvider.of<GraphCubit>(context);
    healthChartCubit.fetchGraph();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphCubit, GraphState>(
      builder: (context, state) {
        if (state is GraphLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (deviceWidth - 80.w) / 2,
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is GraphLoadedState) {
          return Container(
            alignment: Alignment.center,
            width: deviceWidth - 80.w,
            decoration: BoxDecoration(
                color: const Color(0xffE7F9FA),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: AppColors.greyLight,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: simpleText(
                    widget.firstText,
                    color: AppColors.textDark.withOpacity(0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                height(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: simpleText(widget.secondText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight.withOpacity(0.8)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: GestureDetector(
                          onTap: widget.onpressed,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: simpleText(
                              "See Details",
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                height(20),
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryYAxis: NumericAxis(
                    maximum: 5,
                    interval: 1,
                    minimum: 0,
                  ),
                  primaryXAxis: CategoryAxis(
                    interval: 2,
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  series: <CartesianSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                        dataSource: state.weekly,
                        xValueMapper: (SalesData data, _) => data.month,
                        yValueMapper: (SalesData data, _) => data.sales,
                        name: 'Gold',
                        color: AppColors.megenta),
                  ],
                ),
              ],
            ),
          );
        } else if (state is GraphErrorState) {
          return simpleText(
            state.error,
            align: TextAlign.center,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class HomeScreenFreqChartContainer extends StatefulWidget {
  final VoidCallback? onpressed;
  final String firstText;
  final String secondText;

  const HomeScreenFreqChartContainer({
    super.key,
    required this.firstText,
    required this.secondText,
    this.onpressed,
  });

  @override
  State<HomeScreenFreqChartContainer> createState() =>
      _HomeScreenFreqChartContainerState();
}

class _HomeScreenFreqChartContainerState
    extends State<HomeScreenFreqChartContainer> {
  late FrequencyCubit attendanceCubit;

  @override
  void initState() {
    super.initState();
    attendanceCubit = BlocProvider.of<FrequencyCubit>(context);
    attendanceCubit.fetchFrequencyFrequency();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FrequencyCubit, FrequencyState>(
      builder: (context, state) {
        if (state is FrequencyLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (deviceWidth - 80.w) / 2,
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is FrequencyLoadedState) {
          return Container(
            alignment: Alignment.center,
            width: deviceWidth - 60.w,
            decoration: BoxDecoration(
                color: const Color(0xffE7F9FA),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: AppColors.greyLight,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: simpleText(
                    widget.firstText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark.withOpacity(0.8),
                  ),
                ),
                height(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: simpleText(
                          widget.secondText,
                          fontSize: 11,
                          color: AppColors.textLight.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: GestureDetector(
                          onTap: widget.onpressed,
                          child: simpleText(
                            "See Details",
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                height(20),
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryYAxis: NumericAxis(
                    maximum: 10,
                    interval: 2,
                    minimum: 0,
                  ),
                  primaryXAxis: CategoryAxis(
                      interval: 2,
                      majorTickLines: const MajorTickLines(
                        color: Colors.transparent,
                      ),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  series: <CartesianSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                        dataSource: state.weekly,
                        xValueMapper: (SalesData data, _) => data.month,
                        yValueMapper: (SalesData data, _) => data.sales,
                        name: 'Gold',
                        color: AppColors.megenta),
                    LineSeries<SalesData, String>(
                        dataSource: state.gweekly,
                        xValueMapper: (SalesData data, _) => data.month,
                        yValueMapper: (SalesData data, _) => data.sales,
                        name: 'Gold',
                        color: AppColors.primaryBlue),
                    LineSeries<SalesData, String>(
                        dataSource: state.oweekly,
                        xValueMapper: (SalesData data, _) => data.month,
                        yValueMapper: (SalesData data, _) => data.sales,
                        name: 'Gold',
                        color: AppColors.primaryGreen),
                  ],
                )
              ],
            ),
          );
        } else if (state is FrequencyErrorState) {
          return simpleText(
            state.error,
            align: TextAlign.center,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
