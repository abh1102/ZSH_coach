import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';

// ignore: must_be_immutable
class SpecialityCoachContainer extends StatefulWidget {
  final String text1;
  final String? imgUrl;
  bool isChecked;
  final Function(bool isChecked) onChanged; // Added callback function

  SpecialityCoachContainer({
    Key? key,
    required this.text1,
    this.imgUrl,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SpecialityCoachContainer> createState() =>
      _SpecialityCoachContainerState();
}

class _SpecialityCoachContainerState extends State<SpecialityCoachContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF25D366).withOpacity(0.2),
                  const Color(0xFF03C0FF).withOpacity(0.2),
                ],
                stops: const [0.0507, 1.1795],
                transform: const GradientRotation(
                  2.44,
                ),
              ),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 14.w,
            ),
            child: Row(
              children: [
                CustomImageWidget(
                  url: widget.imgUrl ?? defaultAvatar,
                  myradius: 0,
                  mywidth: 40,
                  myheight: 40,
                ),
                width(10),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: simpleText(widget.text1,
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
        Checkbox(
          value: widget.isChecked,
          onChanged: (value) {
            setState(() {
              widget.isChecked = value!;
            });
            widget
                .onChanged(widget.isChecked); // Notify parent about the change
          },
        ),
      ],
    );
  }
}
