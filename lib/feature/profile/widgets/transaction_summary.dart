import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class TransactionSummary extends StatelessWidget {
  final String date;
  final String amount;

  const TransactionSummary({
    super.key,
    required this.date, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.greyDark),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              body2Text("ZH Payment"),
              body2Text(
                "+\$$amount",
                color: AppColors.primaryGreen,
              )
            ],
          ),
          height(8),
          simpleText(
            date,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }
}
