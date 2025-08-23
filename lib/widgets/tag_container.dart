import 'package:flutter/material.dart';
import 'package:zanadu_coach/core/constants.dart';

class TagContainer extends StatelessWidget {
  final double padding;
  final double fontSize;
  const TagContainer({
    super.key,
    required this.firstLetter,
    required this.padding,
    required this.fontSize,
  });

  final String firstLetter;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppColors.primaryGreen,
            )),
        child: simpleText(
          firstLetter,
          fontSize: fontSize,
        ));
  }
}

String getFirstLetter(String letter) {
  return letter.isNotEmpty ? letter[0].toLowerCase() : '';
}
