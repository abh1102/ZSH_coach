import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/add_note_dialog.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';

class AppBarWithBackButtonWOSilver extends StatelessWidget
    implements PreferredSizeWidget {
  final String firstText;
  final String secondText;
  const AppBarWithBackButtonWOSilver({
    super.key,
    required this.firstText,
    required this.secondText,
  });
  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: const BackArrow(),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 10.h, bottom: 6.h),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                firstText,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width(5), // Use SizedBox instead of width
            Flexible(
              child: Text(
                secondText,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add the toggle_switch package

class AppBarWithBackButtonWithAction extends StatefulWidget
    implements PreferredSizeWidget {
  final String firstText;

  const AppBarWithBackButtonWithAction({
    Key? key,
    required this.firstText,
  });

  @override
  _AppBarWithBackButtonWithActionState createState() =>
      _AppBarWithBackButtonWithActionState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _AppBarWithBackButtonWithActionState
    extends State<AppBarWithBackButtonWithAction> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: const BackArrow(),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 10, bottom: 6),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.firstText,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          ],
        ),
      ),
      
    );
  }
}

class HealthCoachAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstText;
  final String secondText;
  final bool canGoBack;
  const HealthCoachAppBar({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.canGoBack,
  });
  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: canGoBack ? const BackArrow() : null,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 10.h, bottom: 6.h),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              firstText,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(width: 3), // Use SizedBox instead of width
            Text(
              secondText,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String secondText;
  final VoidCallback onpressed;
  const ScheduleAppBar({
    super.key,
    required this.secondText, required this.onpressed,
  });
  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: onpressed,
            icon: const Icon(Icons.calendar_today))
      ],
      automaticallyImplyLeading: false,
      leading: const BackArrow(),
      flexibleSpace: SafeArea(
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(
            top: 2.h,
          ),
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                secondText,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback? onpressed;
  final String firstText;

  const NotesAppBar({
    super.key,
    required this.firstText,
    required this.controller,
    this.onpressed,
  });

  @override
  _NotesAppBarState createState() => _NotesAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _NotesAppBarState extends State<NotesAppBar> {
  void showAddNote(BuildContext context, VoidCallback onpressed,
      TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AddNoteDialog(
          controller: controller,
          onpressed: onpressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackArrow(),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(top: 10, bottom: 6),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.firstText,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 9.w),
            child: GestureDetector(
                onTap: () {
                  showAddNote(
                      context,
                      widget.onpressed ??
                          () {
                            Navigator.pop(context);
                          },
                      widget.controller);
                },
                child: SvgPicture.asset("assets/icons/notes_appbar.svg"))),
      ],
    );
  }
}
