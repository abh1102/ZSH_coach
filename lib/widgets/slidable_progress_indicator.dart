import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class ScrolProgressIndicatorContainer extends StatefulWidget {
  final String text;
  final int progress;
  final int maxProgress;

  const ScrolProgressIndicatorContainer({
    Key? key,
    required this.progress,
    required this.maxProgress,
    required this.text,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScrolProgressIndicatorContainerState createState() => _ScrolProgressIndicatorContainerState();
}

class _ScrolProgressIndicatorContainerState extends State<ScrolProgressIndicatorContainer> {
  double currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    currentProgress = widget.progress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF25D366).withOpacity(0.2),
              Color(0xFF03C0FF).withOpacity(0.2),
            ],
          ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              body1Text(
                widget.text,
                color: AppColors.textDark,
              ),
              body1Text(
                '${currentProgress.toInt()}/${widget.maxProgress}',
                color: AppColors.textLight,
              ),
            ],
          ),
         const SizedBox(height: 15),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                // Calculate the new progress based on the drag position
                currentProgress += details.delta.dx / 10; // Adjust the divisor for sensitivity
                if (currentProgress < 0) {
                  currentProgress = 0;
                } else if (currentProgress > widget.maxProgress) {
                  currentProgress = widget.maxProgress.toDouble();
                }
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: LinearProgressIndicator(
                minHeight: 15,
                value: currentProgress / widget.maxProgress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
