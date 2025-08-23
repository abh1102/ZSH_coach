import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/logic/graph_cubit/graph_cubit.dart';
import 'package:zanadu_coach/feature/analytic/presentations/analytic_screen.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';

class AnalyticScreenRatingsChart extends StatefulWidget {
  const AnalyticScreenRatingsChart({
    super.key,
  });

  @override
  State<AnalyticScreenRatingsChart> createState() =>
      _AnalyticScreenRatingsChartState();
}

class _AnalyticScreenRatingsChartState
    extends State<AnalyticScreenRatingsChart> {
  String revenuePeriod = "Weekly";

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
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is GraphLoadedState) {
          List<SalesData> mySales;

          if (revenuePeriod == "Weekly") {
            mySales = state.weekly;
          } else if (revenuePeriod == "Monthly") {
            mySales = state.monthly;
          } else {
            mySales = state.yearly;
          }

          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffE7F9FA),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.greyLight,
              ),
            ),
            child: Column(
              children: [
                height(8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(child: MyRatingValueRow()),
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
                height(12),
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryYAxis: NumericAxis(
                    maximum: 5,
                    interval: 1,
                  ),
                  primaryXAxis: CategoryAxis(
                    interval: 2,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  series: <CartesianSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      dataSource: mySales,
                      xValueMapper: (SalesData data, _) => data.month,
                      yValueMapper: (SalesData data, _) => data.sales,
                      name: 'Gold',
                      color: AppColors.primaryBlue,
                    ),
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
