import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/analytic/logic/attendance_cubit/attendance_cubit.dart';
import 'package:zanadu_coach/feature/analytic/logic/frequency_cubit/frequency_cubit.dart';
import 'package:zanadu_coach/feature/analytic/logic/graph_cubit/graph_cubit.dart';
import 'package:zanadu_coach/feature/analytic/presentations/analytic_screen.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/health_coach_cubit/health_coach_cubit.dart';
import 'package:zanadu_coach/feature/home/logic/provider/home_bottom_provider.dart';
import 'package:zanadu_coach/feature/home/presentations/home_screen.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/notification_cubit/notification_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/payout_cubit/payout_cubit.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/pay_out_screen.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/feature/session/presentations/sessions_screen.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/feature/users/presentations/users_screen.dart';
import 'package:zanadu_coach/widgets/all_dialog.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeBottomBarState createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  //int _currentIndex = 1; // Index of the selected tab

  final List<Widget> _pages = [
    // Add your different pages here
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AllSessionCubit(),
        ),
        BlocProvider(create: (context) => NotificationCubit()),
        BlocProvider(
          create: (context) => GraphCubit(),
        ),
        BlocProvider(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => FrequencyCubit(),
        ),
      ],
      child: const HomeScreen(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FiveHealthCoachCubit(),
        ),
        BlocProvider(
          create: (context) => GraphCubit(),
        ),
        BlocProvider(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => FrequencyCubit(),
        ),
      ],
      child: const AnalyticScreen(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CalendarCubit(),
        ),
      ],
      child: const SessionScreen(),
    ),

    BlocProvider(
      create: (context) => UserCubit(),
      child: const UsersScreen(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GraphCubit(),
        ),
        BlocProvider(
          create: (context) => PayoutCubit(),
        ),
      ],
      child: const PayOutScreen(isAppBar: false),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tabIndexProvider = Provider.of<TabIndexProvider>(context);
    return Scaffold(
      body: _pages[tabIndexProvider.initialTabIndex], // Show the selected page
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -4),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        // padding: EdgeInsets.only(top: 5.h),
        child: BottomNavigationBar(
          unselectedItemColor: AppColors.textLight,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          selectedItemColor: AppColors.textDark,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          currentIndex: tabIndexProvider.initialTabIndex,
          onTap: (int index) {
            // Update the current index when a tab is tapped

            if (myCoach?.isApproved == true) {
              setState(() {
                tabIndexProvider.initialTabIndex = index;
              });
            } else {
              onlyTextWithCutIcon(context, "Your account is not approved yet");
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(tabIndexProvider.initialTabIndex == 0
                    ? "assets/icons/Home.svg"
                    : "assets/icons/Home (1).svg"),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(
                  tabIndexProvider.initialTabIndex == 1
                      ? "assets/icons/bar-chart-2 (3).svg"
                      : "assets/icons/bar-chart-2 (2).svg",
                  width: 23.w,
                  height: 23.h,
                ),
              ),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(tabIndexProvider.initialTabIndex == 2
                    ? "assets/icons/Video (4).svg"
                    : "assets/icons/Video (2).svg"),
              ),
              label: 'Sessions',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(tabIndexProvider.initialTabIndex == 3
                    ? "assets/icons/coach_1 1 (3).svg"
                    : "assets/icons/coach_1 1 (2).svg"),
              ),
              label: 'Users',
            ),
            //assets/icons/moeny.svg
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(tabIndexProvider.initialTabIndex == 4
                    ? "assets/icons/moeny (1).svg"
                    : "assets/icons/moeny.svg"),
              ),
              label: 'PayOut',
            ),
          ],
        ),
      ),
    );
  }
}
