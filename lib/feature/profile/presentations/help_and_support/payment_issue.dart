import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/profile/presentations/help_and_support/repository/ZendeskService.dart';
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
  final TextEditingController descriptionController = TextEditingController();

  String? pickedFileName;
  String? pickedFilePath;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        pickedFileName = result.files.single.name;
        pickedFilePath = result.files.single.path;
      });
    }
  }

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
                heading2Text("Payment Issues", color: AppColors.textDark),
                height(21),

                // 🔶 Main Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: Insets.fixedGradient(opacity: 0.14),
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

                      // 🔶 Category
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

                      // 🔶 Description
                      body2Text("Description"),
                      height(8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Describe the issue...",
                          ),
                        ),
                      ),
                      height(16),

                      // 🔶 File Upload
                      body2Text("Upload"),
                      height(8),
                      Container(
                        width: 374.w,
                        height: 174.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.greyLight),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/🦆 icon _folder_.svg"),
                            height(8),
                            GestureDetector(
                              onTap: pickFile,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.h,
                                  horizontal: 22.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: Insets.fixedGradient(),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: body2Text(
                                  "Browse File",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            height(8),
                            body2Text(pickedFileName ?? "No file chosen")
                          ],
                        ),
                      ),
                      height(8),

                      body2Text(
                        "Supported Format  JPEG, JPG, PNG, PDF.",
                        color: AppColors.textLight,
                      ),
                      height(20),

                      // 🔶 Submit Button
                      ColoredButtonWithoutHW(
                        isLoading: false,
                        onpressed: () async {
                          final userName = "Lisa";
                          final userEmail = "lisa@gmail.com";

                          // VALIDATIONS
                          if (selectedGender.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select support category")),
                            );
                            return;
                          }

                          if (descriptionController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter a description")),
                            );
                            return;
                          }

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                          );

                          // 🔥 Upload file first (optional)
                          String? uploadToken;
                          if (pickedFilePath != null) {
                            uploadToken = await ZendeskService.uploadAttachment(
                                pickedFilePath!);
                          }

                          // 🔥 Create Ticket
                          final success = await ZendeskService.createTicket(
                            userName: userName,
                            userEmail: userEmail,
                            category: selectedGender,
                            description: descriptionController.text,
                            uploadToken: uploadToken,
                          );

                          Navigator.pop(context);

                          if (success) {
                            showSuccessDialog(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text("Failed to submit ticket. Try again.")),
                            );
                          }
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
        ),
      ),
    );
  }

  // SUCCESS DIALOG
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 70),
                const SizedBox(height: 20),
                const Text(
                  "Ticket Raised Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("OK", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
