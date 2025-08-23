import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/signup/widgets/dynamic_pop_menu.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';

class HelpSupportPaymentIssue extends StatefulWidget {
  const HelpSupportPaymentIssue({super.key});

  @override
  State<HelpSupportPaymentIssue> createState() =>
      _HelpSupportPaymentIssueState();
}

class _HelpSupportPaymentIssueState extends State<HelpSupportPaymentIssue> {
  String selectedGender = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
        firstText: "Help &",
        secondText: "Support",
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
              heading2Text(
                "Payment Issues",
                color: AppColors.textDark,
              ),
              height(21),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: Insets.fixedGradient(
                    opacity: 0.14,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 14.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    body1Text("Support Ticket / Dispute"),
                    height(37),
                    body2Text("Support Category"),
                    height(8),
                    DynamicPopupMenuWithBG(
                      color: Colors.white,
                      selectedValue: selectedGender,
                      items: const ['Men', 'Women'],
                      onSelected: (String value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    height(16),
                    body2Text("Description"),
                    height(8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    height(16),
                    body2Text("Upload"),
                    height(8),
                    Container(
                      width: 374.w,
                      height: 174.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.greyLight)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/icons/🦆 icon _folder_.svg"),
                          height(8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 22.w),
                            decoration: BoxDecoration(
                              gradient: Insets.fixedGradient(),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: body2Text(
                              "Browse File",
                              color: Colors.white,
                            ),
                          ),
                          height(8),
                          body2Text("No file chosen")
                        ],
                      ),
                    ),
                    height(8),
                    body2Text(
                      "Supported Format  JPEG, JPG, PNG, PDF.",
                      color: AppColors.textLight,
                    ),
                    height(20),
                     ColoredButtonWithoutHW(
                        isLoading: false,
                        onpressed: () async {
                          
                        },
                        text: "Upload",
                        size: 16,
                        weight: FontWeight.w600,
                        verticalPadding: 14,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
