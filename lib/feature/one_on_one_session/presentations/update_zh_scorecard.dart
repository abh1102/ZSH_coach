import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/one_on_one_session/widgets/profile_view_first_container.dart';
import 'package:zanadu_coach/feature/profile/widgets/progress_indicator_container.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'dart:math' as math;

import 'package:zanadu_coach/widgets/date_converter.dart';

class UpdateZHScoreCard extends StatefulWidget {
  final String data;
  final String name;
  final String userId;
  final String? imgUrl;
  const UpdateZHScoreCard(
      {super.key,
      required this.data,
      required this.name,
      required this.userId,
      this.imgUrl});

  @override
  State<UpdateZHScoreCard> createState() => _UpdateZHScoreCardState();
}

class _UpdateZHScoreCardState extends State<UpdateZHScoreCard> {
  late UserCubit userCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);

    userCubit.fetchGetHealth(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "ZH", secondText: "Health Score"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 28.h,
              horizontal: 28.w,
            ),
            child: Column(
              children: [
                ProfileViewFirstContainer(
                    imgUrl: widget.imgUrl,
                    date: myformattedDate(widget.data),
                    name: widget.name),
                height(28),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoadingState) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    } else if (state is GetUserHealthLoadedState) {
                      // Access the loaded plan from the state
                      var score = state.health.healthScore;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              simpleText(
                                "Overall Health Score",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomCircularProgressBar(
                                value: double.tryParse(state
                                            .health.currentScore?.finalScore
                                            ?.toStringAsFixed(1) ??
                                        "") ??
                                    0,
                              )
                            ],
                          ),
                          height(28),
                          ProgressIndicatorContainer(
                            text: 'Physical Health',
                            maxProgress: 10,
                            progress: score?.physicalHealth != null
                                ? score?.physicalHealth ?? 0.0
                                : 0.0,
                          ),
                          height(28),
                          ProgressIndicatorContainer(
                            text: 'Mental Health',
                            maxProgress: 10,
                            progress: score?.mentalHealth != null
                                ? score?.mentalHealth ?? 0
                                : 0,
                          ),
                          height(28),
                          ProgressIndicatorContainer(
                            text: 'Energy',
                            maxProgress: 10,
                            progress:
                                score?.energy != null ? score?.energy ?? 0 : 0,
                          ),
                          height(28),
                          ProgressIndicatorContainer(
                            text: 'Nutrition',
                            maxProgress: 10,
                            progress: score?.nutrition != null
                                ? score?.nutrition ?? 0
                                : 0,
                          ),
                          height(28),
                          ProgressIndicatorContainer(
                            text: 'General Health',
                            maxProgress: 10,
                            progress: score?.generalHealth != null
                                ? score?.generalHealth ?? 0
                                : 0,
                          ),
                        ],
                      );
                    } else if (state is UserErrorState) {
                      return Text('Error: ${state.error}');
                    } else {
                      return const Text('Something is wrong');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCircularProgressBar extends StatelessWidget {
  final double value;

  CustomCircularProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    double percentage = value / 10.0; // Convert the value to a percentage

    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: CircularProgressBarPainter(percentage: percentage),
        child: Center(
          child: Text(
            '$value/10',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth = 10.0;

  CircularProgressBarPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;

    final Paint completedPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint incompletePaint = Paint()
      ..color = AppColors.greyDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      completedPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + sweepAngle,
      2 * math.pi - sweepAngle,
      false,
      incompletePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
