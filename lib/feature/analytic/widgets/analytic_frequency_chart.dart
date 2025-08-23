import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/logic/frequency_cubit/frequency_cubit.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';

class AnalyticScreenFrequencyChart extends StatefulWidget {
  const AnalyticScreenFrequencyChart({super.key});

  @override
  State<AnalyticScreenFrequencyChart> createState() =>
      _AnalyticScreenFrequencyChartState();
}

class _AnalyticScreenFrequencyChartState
    extends State<AnalyticScreenFrequencyChart> {
  String revenuePeriod = "Weekly";

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
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is FrequencyLoadedState) {
          List<SalesData> mySales;
          List<SalesData> gmySales;
          List<SalesData> omySales;

          if (revenuePeriod == "Weekly") {
            mySales = state.weekly;
            gmySales = state.gweekly;
            omySales = state.oweekly;
          } else if (revenuePeriod == "Monthly") {
            mySales = state.monthly;
            gmySales = state.gmonthly;
            omySales = state.omonthly;
          } else {
            mySales = state.yearly;
            gmySales = state.gyearly;
            omySales = state.oyearly;
          }

          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffE7F9FA),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.greyLight),
            ),
            child: Column(
              children: [
                height(10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: body1Text(
                          "Sessions Frequency",
                          color: AppColors.textDark,
                        ),
                      ),
                      DynamicPopupMenu(
                        selectedValue: revenuePeriod,
                        items: const ["Weekly", "Monthly", "Yearly"],
                        onSelected: (String value) {
                          setState(() {
                            revenuePeriod = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                height(10),
                SfCartesianChart(
                  primaryYAxis: NumericAxis(
                    majorTickLines: const MajorTickLines(
                      color: Colors.transparent,
                    ),
                    maximum: getMaximumValue(revenuePeriod),
                    interval: getIntervalValue(revenuePeriod),
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
                    ),
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  series: <CartesianSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      dataSource: mySales,
                      xValueMapper: (SalesData data, _) => data.month,
                      yValueMapper: (SalesData data, _) => data.sales,
                      name: 'Orientation',
                      color: AppColors.megenta,
                    ),
                    LineSeries<SalesData, String>(
                      dataSource: gmySales,
                      xValueMapper: (SalesData data, _) => data.month,
                      yValueMapper: (SalesData data, _) => data.sales,
                      name: 'Group',
                      color: AppColors.primaryBlue,
                    ),
                    LineSeries<SalesData, String>(
                      dataSource: omySales,
                      xValueMapper: (SalesData data, _) => data.month,
                      yValueMapper: (SalesData data, _) => data.sales,
                      name: 'One On One',
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
                height(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Row(
                    children: [
                      FrequencyColorCodeRow(
                        color: AppColors.megenta,
                        text: "Orientation",
                      ),
                      FrequencyColorCodeRow(
                        color: AppColors.primaryBlue,
                        text: "Group",
                      ),
                      FrequencyColorCodeRow(
                        color: AppColors.primaryGreen,
                        text: "One On One",
                      ),
                    ],
                  ),
                ),
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

  double getMaximumValue(String period) {
    switch (period) {
      case "Weekly":
        return 10;
      case "Monthly":
        return 100;
      case "Yearly":
        return 500;
      default:
        return 10;
    }
  }

  double getIntervalValue(String period) {
    switch (period) {
      case "Weekly":
        return 2;
      case "Monthly":
        return 20;
      case "Yearly":
        return 100;
      default:
        return 2;
    }
  }
}

class FrequencyColorCodeRow extends StatelessWidget {
  final Color color;
  final String text;
  const FrequencyColorCodeRow({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            color: color,
          ),
          width(7),
          Expanded(
              child: FittedBox(fit: BoxFit.scaleDown, child: simpleText(text))),
        ],
      ),
    );
  }
}
