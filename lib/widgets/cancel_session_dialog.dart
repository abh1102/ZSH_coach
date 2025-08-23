import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

class CancelSessionDialog extends StatefulWidget {
  final VoidCallback? onpressed;
  final String selectReason;
  final ValueChanged<String> onLanguageSelected;

  const CancelSessionDialog({
    super.key,
    required this.selectReason,
    required this.onLanguageSelected,
    this.onpressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CancelSessionDialogState createState() => _CancelSessionDialogState();
}

class _CancelSessionDialogState extends State<CancelSessionDialog> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectReason;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 29.w,
          vertical: 28.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF25D366), Color(0xFF03C0FF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/Vector.svg", // Replace with your SVG file
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ),
                ),
              Center(
                  child: heading1Text(
                "Why do you want to cancel?",
                textAlign: TextAlign.center,
                color: Colors.white,
              )),
              height(28),
              buildLanguageRow('Feeling Unwell'),
              buildLanguageRow('Scheduling Conflict '),
              buildLanguageRow('Traveling'),
              buildLanguageRow('On Vacation'),
              buildLanguageRow('Others'),
              height(18),
              if (selectedValue == 'Others')
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ),
              height(55),
              WhiteBgBlackTextButton(text: "Done", onpressed: widget.onpressed),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLanguageRow(String language) {
    return Row(
      children: [
        Radio(
          value: language,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onLanguageSelected(value as String);
          },
          activeColor: Colors.white,
        ),
        width(20),
        Expanded(
          child: simpleText(
            language,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
