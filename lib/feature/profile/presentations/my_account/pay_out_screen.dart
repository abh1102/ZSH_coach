import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/widgets/analytic_payout_chart.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/payout_cubit/payout_cubit.dart';
import 'package:zanadu_coach/feature/profile/widgets/pay_out_one_session_hour.dart';
import 'package:zanadu_coach/feature/profile/widgets/payout_screen_first_container.dart';
import 'package:zanadu_coach/feature/profile/widgets/transaction_summary.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';

class PayOutScreen extends StatefulWidget {
  final bool isAppBar;
  const PayOutScreen({super.key, required this.isAppBar});

  @override
  State<PayOutScreen> createState() => _PayOutScreenState();
}

class _PayOutScreenState extends State<PayOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isAppBar
            ? const AppBarWithBackButtonWOSilver(
                firstText: "Pay", secondText: "Outs")
            : AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pay",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                    width(3),
                    Text(
                      "Out",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 28.h,
                horizontal: 28.w,
              ),
              child: BlocBuilder<PayoutCubit, PayoutState>(
                builder: (context, state) {
                  if (state is PayoutLoadingState) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (state is PayoutLoadedState) {
                    // Access the loaded plan from the state

                    var orientationHour =
                        state.coachSessionHours.totalOrientationSessionsHour ??
                            0;
                    var groupHour =
                        state.coachSessionHours.totalGroupSessionsHour ?? 0;

                    var oneSessionHour =
                        state.coachSessionHours.totalOneToOneSessionsHour ?? 0;

                    var totalAmount = state.payoutTransactions.fold<double>(
                        0,
                        (previousValue, transaction) =>
                            previousValue + (transaction.amount ?? 0));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PayOutScreenFirstContainer(
                          date: myformattedDate(
                              myCoach?.coachInfo?[0].createdAt ?? ""),
                          amount: totalAmount.toString(),
                        ),
                        height(25),
                        simpleText(
                          "Total Hours",
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        height(10),
                        PayOutOneSessionHour(
                          color: AppColors.megenta,
                          svg: "assets/icons/orientation_payout.svg",
                          text: "${orientationHour.toStringAsFixed(2)} Hours",
                          secondText: "Total Orientation Sessions Hours",
                        ),
                        height(12),
                        PayOutOneSessionHour(
                          color: AppColors.primaryBlue,
                          svg: "assets/icons/users.svg",
                          text: "${groupHour.toStringAsFixed(2)} Hours",
                          secondText: "Total Group Sessions Hours",
                        ),
                        height(12),
                        PayOutOneSessionHour(
                          color: AppColors.primaryGreen,
                          svg: "assets/icons/user.svg",
                          text: "${oneSessionHour.toStringAsFixed(2)} Hours",
                          secondText: "Total One On One Sessions Hours",
                        ),
                        height(28),
                        simpleText(
                          "PayOut Chart  \$",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        height(10),
                        const AnalyticScreenPayOutChart(),
                        height(20),
                        simpleText(
                          "Recent Transactions",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        height(16),
                        if (state.payoutTransactions.isEmpty)
                          Center(
                            child: simpleText("No Transactions Yet",
                                align: TextAlign.center),
                          ),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            var transaction = state.payoutTransactions[index];

                            return TransactionSummary(
                                amount: transaction.amount.toString(),
                                date: myformattedDate(
                                    transaction.createdAt ?? " "));
                          },
                          itemCount: state.payoutTransactions.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        )
                      ],
                    );
                  } else if (state is PayoutErrorState) {
                    return Text('Error: ${state.error}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ));
  }
}
