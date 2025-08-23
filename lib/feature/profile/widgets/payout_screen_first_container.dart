import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class PayOutScreenFirstContainer extends StatelessWidget {
  final String date;
  final String amount;
  const PayOutScreenFirstContainer({
    super.key, required this.date, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 32.w, top: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffE8FAF7),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/mobile-banking.png",
            width: 100.w,
            height: 100.h,
          ),
          //  SvgPicture.asset("assets/images/Group 1171275352.svg"),
          width(30.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                body2Text("Total Earned"),
                height(4),
                simpleText(
                  "(Since- $date)",
                  fontSize: 12,
                ),
                height(10),
                heading2Text("\$$amount")
              ],
            ),
          )
        ],
      ),
    );
  }
}
