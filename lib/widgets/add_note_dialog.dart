import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/whitebg_blacktext_button.dart';

class AddNoteDialog extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onpressed;

  const AddNoteDialog({
    super.key,
    this.onpressed, required this.controller,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
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
                    padding: EdgeInsets.all(8.0),
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
                "Add Note",
                textAlign: TextAlign.center,
                color: Colors.white,
              )),
              height(28),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child:  TextField(
                  controller: widget.controller,
                  maxLines: 4,
                  decoration:const InputDecoration(
                      hintText: "Type Here...",
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
}
