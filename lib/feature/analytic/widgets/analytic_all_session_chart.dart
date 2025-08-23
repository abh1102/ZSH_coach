import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';
import 'package:zanadu_coach/feature/analytic/logic/attendance_cubit/attendance_cubit.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';

class AnalyticAllSessionChart extends StatefulWidget {
  const AnalyticAllSessionChart({super.key});

  @override
  State<AnalyticAllSessionChart> createState() =>
      _AnalyticAllSessionChartState();
}

class _AnalyticAllSessionChartState extends State<AnalyticAllSessionChart> {
  String revenuePeriod = "Weekly";

  late AttendanceCubit attendanceCubit;

  @override
  void initState() {
    super.initState();
    attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    attendanceCubit.fetchAttendanceAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ((25 / 100) * deviceHeight) / 2,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is AttendanceAttendanceLoadedState) {
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
                height(9),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: body1Text(
                            "Users Attendance (In %)",
                            color: AppColors.textDark,
                          ),
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
                height(6),
                SfCartesianChart(
                  primaryYAxis: NumericAxis(
                      maximum: getMaximumValue(revenuePeriod),
                      interval: getIntervalValue(revenuePeriod)),
                  primaryXAxis: CategoryAxis(
                    interval: 2,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    majorGridLines: MajorGridLines(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                  ),
                  series: <CartesianSeries<SalesData, String>>[
                    ColumnSeries<SalesData, String>(
                      dataSource: mySales,
                      xValueMapper: (SalesData sales, _) => sales.month,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                      pointColorMapper: (SalesData data, _) {
                        return data.index.isEven
                            ? AppColors.primaryGreen
                            : AppColors.primaryBlue;
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

  double getMaximumValue(String period) {
    switch (period) {
      case "Weekly":
        return 100;
      case "Monthly":
        return 100;
      case "Yearly":
        return 100;
      default:
        return 10;
    }
  }

  double getIntervalValue(String period) {
    switch (period) {
      case "Weekly":
        return 20;
      case "Monthly":
        return 20;
      case "Yearly":
        return 20;
      default:
        return 2;
    }
  }
}
