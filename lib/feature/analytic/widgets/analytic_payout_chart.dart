import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/logic/graph_cubit/graph_cubit.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';

class AnalyticScreenPayOutChart extends StatefulWidget {
  const AnalyticScreenPayOutChart({super.key});

  @override
  State<AnalyticScreenPayOutChart> createState() =>
      _AnalyticScreenPayOutChartState();
}

class _AnalyticScreenPayOutChartState extends State<AnalyticScreenPayOutChart> {
  String revenuePeriod = "Monthly";

  late GraphCubit healthChartCubit;

  @override
  void initState() {
    super.initState();
    healthChartCubit = BlocProvider.of<GraphCubit>(context);
    healthChartCubit.fetchGraphPayout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphCubit, GraphState>(
      builder: (context, state) {
        if (state is GraphPayoutLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is GraphPayoutLoadedState) {
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
              border: Border.all(color: AppColors.greyLight),
            ),
            child: Column(
              children: [
                height(7),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DynamicPopupMenu(
                        selectedValue: revenuePeriod,
                        items: const ["Monthly", "Yearly"],
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
                    maximum: getMaximumValue(revenuePeriod),
                    interval: getIntervalValue(revenuePeriod),
                  ),
                  primaryXAxis: CategoryAxis(
                    interval: 2,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  series: <CartesianSeries<SalesData, String>>[
                    ColumnSeries<SalesData, String>(
                      dataSource: mySales,
                      xValueMapper: (SalesData sales, _) => sales.month,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                      pointColorMapper: (SalesData sales, _) {
                        return sales.index.isEven
                            ? AppColors.primaryBlue
                            : AppColors.primaryGreen;
                      },
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      width: 0.3,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is GraphPayoutErrorState) {
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
      case "Monthly":
        return 100;
      case "Yearly":
        return 100;
      default:
        return 100;
    }
  }

  double getIntervalValue(String period) {
    switch (period) {
      case "Monthly":
        return 20;
      case "Yearly":
        return 20;
      default:
        return 20;
    }
  }
}
