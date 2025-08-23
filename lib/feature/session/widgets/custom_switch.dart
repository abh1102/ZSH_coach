import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';

class CustomSwitch extends StatefulWidget {
  final String firstText;
  final String secondText;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    final firstTextWidth = calculateTextWidth(widget.firstText);
    final secondTextWidth = calculateTextWidth(widget.secondText);
    final maxWidth =
        firstTextWidth > secondTextWidth ? firstTextWidth : secondTextWidth;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        alignment: Alignment.center,
        width: maxWidth + 60, // Adjust the padding
        height: 24.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: widget.value ? AppColors.primaryGreen : Colors.red,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: widget.value ? 1.0 : maxWidth + 35,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 27, right: 27),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    widget.value ? widget.firstText : widget.secondText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.width;
  }
}

class CustomSwitchVideo extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchVideo(
      {super.key, required this.value, required this.onChanged});

  @override
  // ignore: library_private_types_in_public_api
  _CustomSwitchVideoState createState() => _CustomSwitchVideoState();
}

class _CustomSwitchVideoState extends State<CustomSwitchVideo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        alignment: Alignment.center,
        width: 140, // Increase the width for more space
        height: 26, // Increase the height for more space
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyDark),
          borderRadius: BorderRadius.circular(
              40.0), // Match the border radius to half of the height
          color: widget.value ? AppColors.primaryGreen : AppColors.primaryBlue,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: widget.value ? 0.0 : 113.5, // Half of the container width
              child: Container(
                width: 24, // Half of the container width
                height: 28, // Match the height to the container
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyDark),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: simpleText(widget.value ? "Demo Video" : "Full Video",
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitchImageApple extends StatefulWidget {
  final String svg;
  final String firstText;
  final String secondText;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchImageApple({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.firstText,
    required this.secondText, required this.svg,
  }) : super(key: key);

  @override
  _CustomSwitchImageAppleState createState() => _CustomSwitchImageAppleState();
}

class _CustomSwitchImageAppleState extends State<CustomSwitchImageApple> {
  @override
  Widget build(BuildContext context) {
    final firstTextWidth = calculateTextWidth(widget.firstText);
    final secondTextWidth = calculateTextWidth(widget.secondText);
    final maxWidth =
        firstTextWidth > secondTextWidth ? firstTextWidth : secondTextWidth;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1),
        alignment: Alignment.center,
        width: maxWidth + 120, // Adjust the padding
        height: 46.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.value ? AppColors.primaryGreen : Colors.red,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: widget.value ? 1.0 : maxWidth + 75,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Icon(Icons.apple),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 27, right: 27),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    widget.value ? widget.firstText : widget.secondText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.width;
  }
}


class CustomSwitchImage extends StatefulWidget {
  final String svg;
  final String firstText;
  final String secondText;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchImage({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.firstText,
    required this.secondText, required this.svg,
  }) : super(key: key);

  @override
  _CustomSwitchImageState createState() => _CustomSwitchImageState();
}

class _CustomSwitchImageState extends State<CustomSwitchImage> {
  @override
  Widget build(BuildContext context) {
    final firstTextWidth = calculateTextWidth(widget.firstText);
    final secondTextWidth = calculateTextWidth(widget.secondText);
    final maxWidth =
        firstTextWidth > secondTextWidth ? firstTextWidth : secondTextWidth;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1),
        alignment: Alignment.center,
        width: maxWidth + 120, // Adjust the padding
        height: 46.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.value ? AppColors.primaryGreen : Colors.red,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: widget.value ? 1.0 : maxWidth + 75,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: SvgPicture.asset(widget.svg),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 27, right: 27),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    widget.value ? widget.firstText : widget.secondText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.width;
  }
}
