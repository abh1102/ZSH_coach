import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:info_popup/info_popup.dart';
import 'package:zanadu_coach/core/constants.dart';

class PrefixIconTextFieldWidget extends StatelessWidget {
  final String? initialValue;
  final String prefixIcon;
  final bool? hidePassword;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const PrefixIconTextFieldWidget(
      {super.key,
      required this.prefixIcon,
      this.initialValue,
      this.onChanged,
      this.controller,
      this.hidePassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: hidePassword ?? false,
        controller: controller,
        initialValue: initialValue,
        cursorColor: AppColors.primaryBlue,
        decoration: InputDecoration(
            border: InputBorder.none, // Remove the default border
            prefixIcon: Transform.scale(
              scale: 0.5, // Adjust the scale factor as needed
              child: SvgPicture.asset(
                prefixIcon,
              ),
            ),

            // Add your prefix icon here

            hintStyle: TextStyle(color: AppColors.greyLight)),
      ),
    );
  }
}

class SuffixIconTextFieldWidget extends StatelessWidget {
  final String suffixIcon;

  const SuffixIconTextFieldWidget({super.key, required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: TextField(
        cursorColor: AppColors.primaryBlue,
        decoration: InputDecoration(
            border: InputBorder.none, // Remove the default border
            suffixIcon: Transform.scale(
              scale: 0.5, // Adjust the scale factor as needed
              child: SvgPicture.asset(
                suffixIcon,
              ),
            ),

            // Add your prefix icon here

            hintStyle: TextStyle(color: AppColors.greyLight)),
      ),
    );
  }
}

class PrefixSuffixIconTextFieldWidget extends StatelessWidget {
  final String prefixIcon;
  final String suffixIcon;
  final bool? hidePassword;
  final void Function(String)? onchanged;
  final TextEditingController? controller;

  const PrefixSuffixIconTextFieldWidget(
      {super.key,
      required this.prefixIcon,
      required this.suffixIcon,
      this.controller,
      this.hidePassword,
      this.onchanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: TextField(
        onChanged: onchanged,
        obscureText: hidePassword ?? false,
        controller: controller,
        cursorColor: AppColors.primaryBlue,
        decoration: InputDecoration(
            suffixIcon: InfoPopupWidget(
              arrowTheme: const InfoPopupArrowTheme(
                color: Color(0xFF403E3E),
                arrowDirection: ArrowDirection.down,
              ),
              customContent: () => Padding(
                padding: EdgeInsets.only(right: 9.w),
                child: Container(
                  width: 256.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF403E3E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: simpleText(
                    "Must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. Minimum 8 characters.",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              child: Transform.scale(
                scale: 0.5, // Adjust the scale factor as needed
                child: SvgPicture.asset(
                  suffixIcon,
                ),
              ),
            ),
            border: InputBorder.none, // Remove the default border
            prefixIcon: Transform.scale(
              scale: 0.5, // Adjust the scale factor as needed
              child: SvgPicture.asset(
                prefixIcon,
              ),
            ),

            // Add your prefix icon here

            hintStyle: TextStyle(color: AppColors.greyLight)),
      ),
    );
  }
}

class NoIconTextFieldWidget extends StatelessWidget {
  final String? initial;
  final Color? color;
  final bool? enabled;
  final bool? phoneKeyboard;

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const NoIconTextFieldWidget({
    super.key,
    this.color,
    this.enabled,
    this.initial,
    this.controller,
    this.validator,
    this.phoneKeyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: TextFormField(
          inputFormatters: phoneKeyboard == true
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          keyboardType: phoneKeyboard == true ? TextInputType.number : null,
          controller: controller,
          initialValue: initial,
          enabled: enabled,
          cursorColor: AppColors.primaryBlue,
          decoration: InputDecoration(
            border: InputBorder.none, // Remove the default border

            // Add your prefix icon here

            hintStyle: TextStyle(color: AppColors.greyLight),
          ),
        ),
      ),
    );
  }
}

class NoIconTextFieldWidgetNumber extends StatelessWidget {
  final String? initial;
  final Color? color;
  final bool? enabled;

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const NoIconTextFieldWidgetNumber({
    super.key,
    this.color,
    this.enabled,
    this.initial,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use the provided width or take up all available space
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          controller: controller,
          initialValue: initial,
          enabled: enabled,
          cursorColor: AppColors.primaryBlue,
          decoration: InputDecoration(
            border: InputBorder.none, // Remove the default border

            // Add your prefix icon here

            hintStyle: TextStyle(color: AppColors.greyLight),
          ),
        ),
      ),
    );
  }
}

class CountryTextFieldWidget extends StatelessWidget {
  final TextEditingController? countrycodeController;
  final double? width;

  const CountryTextFieldWidget({
    super.key,
    this.width,
    this.countrycodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.greyLight, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: TextFormField(
          controller: countrycodeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: AppColors.primaryBlue,
          decoration: InputDecoration(
              hintText: "+880",
              border: InputBorder.none, // Remove the default border

              // Add your prefix icon here

              hintStyle: TextStyle(color: AppColors.greyLight)),
        ),
      ),
    );
  }
}
