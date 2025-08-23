import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/data/model/sales_model.dart';

class HomeScreenRatingChart extends StatefulWidget {
  final double interval;
  const HomeScreenRatingChart({
    super.key,
    required this.interval,
  });

  @override
  State<HomeScreenRatingChart> createState() => _HomeScreenRatingChartState();
}

class _HomeScreenRatingChartState extends State<HomeScreenRatingChart> {
  List<String> generateDateStrings() {
    DateTime now = DateTime.now();
    List<String> dateStrings = [];

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String formattedDate = DateFormat('MM-dd').format(date);
      dateStrings.add(formattedDate);
    }

    return dateStrings;
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateStrings = generateDateStrings();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryYAxis: NumericAxis(
        maximum: 5,
        interval: 1,
        minimum: 0,
      ),
      primaryXAxis: CategoryAxis(
        interval: 2,
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      series: <CartesianSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
            dataSource: dateStrings
                .map((date) => SalesData(date, 0, dateStrings.indexOf(date)))
                .toList(),
            xValueMapper: (SalesData data, _) => data.month,
            yValueMapper: (SalesData data, _) => data.sales,
            name: 'Gold',
            color: AppColors.megenta),
      ],
    );
  }
}
