import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';

class ColoredButton extends StatelessWidget {
  final VoidCallback? onpressed;
  final String text;
  final double size;
  final FontWeight weight;
  final double? myHeight;
  final double? myWidth;
  final bool isLoading;
  const ColoredButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    this.myHeight,
    this.myWidth,
    this.onpressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        width: myWidth ?? double.infinity,
        height: myHeight ?? 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF03C0FF),
              Color(0xFF25D366),
            ],
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
            : simpleText(
                text,
                fontSize: size,
                fontWeight: weight,
                color: Colors.white, // Text color
              ),
      ),
    );
  }
}

class GreySubmitButton extends StatelessWidget {
  final bool colored;
  final String text;
  final double size;
  final FontWeight weight;
  final double? myHeight;
  final double? myWidth;
  const GreySubmitButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    this.myHeight,
    this.myWidth,
    required this.colored,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: myWidth ?? double.infinity,
      height: myHeight ?? 60.h,
      decoration: BoxDecoration(
        color: colored ? null : AppColors.greyLight,
        borderRadius: BorderRadius.circular(50),
        gradient: colored
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF03C0FF),
                  Color(0xFF25D366),
                ],
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            : null,
      ),
      child: simpleText(
        text,
        fontSize: size,
        fontWeight: weight,
        color: Colors.white, // Text color
      ),
    );
  }
}

class SimpleWhiteTextButton extends StatelessWidget {
  final double verticalPadding;
  final VoidCallback? onpressed;
  final String text;
  final double size;
  final FontWeight weight;
  final double? myHeight;
  final double? myWidth;

  const SimpleWhiteTextButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    this.myHeight,
    this.myWidth,
    this.onpressed,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
        alignment: Alignment.center,
        width: myWidth ?? double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textDark),
          borderRadius: BorderRadius.circular(50),
        ),
        child: simpleText(
          text,
          fontSize: size,
          fontWeight: weight,
          color: Colors.black, // Text color
        ),
      ),
    );
  }
}

class ColoredButtonWithoutHW extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double verticalPadding;
  final VoidCallback? onpressed;
  final bool isLoading;

  const ColoredButtonWithoutHW({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.verticalPadding,
    this.onpressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF03C0FF),
              Color(0xFF25D366),
            ],
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding.h,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : simpleText(
                  text,
                  fontSize: size,
                  fontWeight: weight,
                  color: Colors.white, // Text color
                ),
        ),
      ),
    );
  }
}

class SimpleWhiteTextButtonWOHW extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final bool isLoading;
  final double verticalPadding;

  const SimpleWhiteTextButtonWOHW({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.verticalPadding,
    this.color,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding.h,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? AppColors.textDark),
        borderRadius: BorderRadius.circular(50),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            )
          : simpleText(
              text,
              fontSize: size,
              fontWeight: weight,
              color: color ?? Colors.black, // Text color
            ),
    );
  }
}

class GreySubmitButtonWOHW extends StatelessWidget {
  final bool colored;
  final String text;
  final double size;
  final FontWeight weight;
  final double verticalPadding;

  const GreySubmitButtonWOHW({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.colored,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colored ? null : AppColors.greyLight,
        borderRadius: BorderRadius.circular(50),
        gradient: colored
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF03C0FF),
                  Color(0xFF25D366),
                ],
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            : null,
      ),
      child: simpleText(
        text,
        fontSize: size,
        fontWeight: weight,
        color: Colors.white, // Text color
      ),
    );
  }
}

class RejectedButton extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double verticalPadding;
  final VoidCallback? onpressed;

  const RejectedButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.verticalPadding,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.secondaryRedColor),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding.h,
          ),
          child: simpleText(
            text,
            fontSize: size,
            fontWeight: weight,
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}
