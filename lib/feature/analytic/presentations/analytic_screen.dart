import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/analytic/widgets/analytic_all_session_chart.dart';
import 'package:zanadu_coach/feature/analytic/widgets/analytic_frequency_chart.dart';
import 'package:zanadu_coach/feature/analytic/widgets/analytic_rating_chart.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/health_coach_cubit/health_coach_cubit.dart';
import 'package:zanadu_coach/feature/home/widgets/best_health_coach_widget.dart';
import 'package:zanadu_coach/feature/home/widgets/health_coach_container.dart';
import 'package:zanadu_coach/widgets/appbar_with_only_text.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithOnlyText(
        textOne: "",
        textTwo: "Analytics",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.w,
              vertical: 28.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnalyticScreenRatingsChart(),
                height(28),
                const AnalyticAllSessionChart(),
                height(28),
                const AnalyticScreenFrequencyChart(),
                height(28),
                const MyRatingValueRow(),
                height(17),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AnalyticLastContainerText(
                        text: "Top Rated Coaches of This Month ",
                      ),
                      height(16),
                      SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Horizontal scrolling
                        child: BlocBuilder<FiveHealthCoachCubit,
                            FiveHealthCoachState>(
                          builder: (context, state) {
                            if (state is FiveHealthCoachLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            } else if (state is FiveHealthCoachLoadedState) {
                              // Access the loaded plan from the state
                              if (state.healthCoach.isEmpty) {
                                return simpleText("text");
                              }
                              return Row(
                                children: List.generate(
                                    state.healthCoach
                                        .length, // Change this to the number of containers you want
                                    (index) {
                                  var data = state.healthCoach[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.w,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Routes.goTo(Screens.healthCoachDetail,
                                            arguments: data);
                                      },
                                      child: HealthCoachContainer(
                                        imgUrl: data.profile?.image,
                                        likeCount: data.coachInfo?.likes == null
                                            ? "0"
                                            : data.coachInfo?.likes
                                                    .toString() ??
                                                "0",
                                        name:
                                            data.profile?.fullName.toString() ??
                                                "",
                                        rating: data.coachInfo?.rating == null
                                            ? "0"
                                            : data.coachInfo?.rating
                                                    .toString() ??
                                                "0",
                                        session: data.countSessions.toString(),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            } else if (state is FiveHealthCoachErrorState) {
                              return Text('Error: ${state.error}');
                            } else {
                              return const Text('Something is wrong');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyRatingValueRow extends StatelessWidget {
  const MyRatingValueRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: body1Text(
            "My Rating",
            color: AppColors.textDark,
          ),
        ),
        width(6),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40.w,
              height: 20.h,
              padding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 5.w,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryGreen,
                ),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
            ),
            simpleText(
              (double.tryParse(myCoach?.coachInfo?[0].rating ?? "0.0"))
                      ?.toStringAsFixed(1) ??
                  "",
              fontSize: 10,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ],
        )
      ],
    );
  }
}
