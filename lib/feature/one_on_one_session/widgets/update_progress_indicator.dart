import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class UpdateProgressIndicatorContainer extends StatefulWidget {
  final String text;
  final int progress;
  final int maxProgress;

  const UpdateProgressIndicatorContainer({
    Key? key,
    required this.progress,
    required this.maxProgress,
    required this.text,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProgressIndicatorContainerState createState() =>
      _UpdateProgressIndicatorContainerState();
}

class _UpdateProgressIndicatorContainerState
    extends State<UpdateProgressIndicatorContainer> {
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
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbColor: AppColors.primaryGreen,
              activeTrackColor:
                  AppColors.primaryGreen, // Customize track color as needed
              inactiveTrackColor:
                  Colors.white, // Customize inactive track color as needed
              trackHeight:
                  10.0, // Set the desired track height (this makes the slider wider)
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius:
                    12.0, // Customize the thumb radius as needed
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: currentProgress,
              min: 0,
              max: widget.maxProgress.toDouble(),
              onChanged: (value) {
                setState(
                  () {
                    currentProgress = value;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
