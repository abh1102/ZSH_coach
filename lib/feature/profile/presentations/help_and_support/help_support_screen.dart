import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/profile/widgets/help_support_container.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/launch_url.dart';

import 'TicketHistoryScreen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}
void showPaymentSupportDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                "Payment Support",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              SizedBox(height: 22),

              // 🔹 Raise Ticket Button (Gradient like app buttons)
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: Insets.fixedGradient(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Routes.goTo(Screens.helpSupportPayment);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Raise Ticket",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // 🔹 Check Status Button (Outlined style)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Routes.goTo(Screens.ticketHistoryScreen);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      // color: AppColors.primary, // your accent color
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Check Status",
                    style: TextStyle(
                      color:  AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
                "How can we help you?",
                color: AppColors.textDark,
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  Routes.goTo(Screens.helpSupportAbout);
                },
                text: "About us",
                svg: "assets/icons/help-circle.svg",
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  myLaunchUrl("https://app.zanaduhealth.com/faq");
                },
                text: "FAQ",
                svg: "assets/icons/quiz.svg",
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  showPaymentSupportDialog(context);
                },
                text: "Payment issues",
                svg: "assets/icons/dollar-sign.svg",
              ),
              height(28),
              const HelpSupportContainer(
                text: "Technical Issues",
                svg: "assets/icons/settings.svg",
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  myLaunchUrl("https://app.zanaduhealth.com/contact-us");
                },
                text: "Contact",
                svg: "assets/icons/headphones.svg",
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  myLaunchUrl("https://app.zanaduhealth.com/terms-of-service");
                },
                text: "Terms of Agreement",
                svg: "assets/icons/file-text.svg",
              ),
              height(28),
              HelpSupportContainer(
                onpressed: () {
                  myLaunchUrl("https://app.zanaduhealth.com/privacy-policy");
                },
                text: "Privacy Policy",
                svg: "assets/icons/Vector (3).svg",
              )
            ],
          ),
        ),
      )),
    );
  }
}
