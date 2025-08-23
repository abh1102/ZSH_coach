import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/provider/session_provider.dart';
import 'package:zanadu_coach/feature/session/widgets/calendar_container.dart';
import 'package:zanadu_coach/feature/session/widgets/session_screen_button.dart';
import 'package:zanadu_coach/widgets/appbar_with_only_text.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  var provider =
      Provider.of<SessionProvider>(Routes.currentContext, listen: false);
  late CalendarCubit calendarCubit;

  @override
  void initState() {
    super.initState();
    print("hereree");
    calendarCubit = BlocProvider.of<CalendarCubit>(context);
    calendarCubit.getCalendarData(provider.visibleMonth);
    provider.isInitialized = true;
    print(provider.isInitialized);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SessionProvider>(context, listen: true);

    return BlocListener<CalendarCubit, CalendarState>(
        listener: (context, state) {
      if (state is CalendarUpadatedLoadedState) {
        print("hsssssssssssssssssssssss");
        BlocProvider.of<CalendarCubit>(context)
            .getCalendarData(provider.visibleMonth);
      }

      if (state is CalendarErrorState) {
        showSnackBar(state.error);
      }
    }, child: Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        return Scaffold(
          appBar: const AppBarWithOnlyText(
            textOne: "",
            textTwo: "Sessions",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 28.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 33.w,
                                  height: 33.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                                width(8),
                                Flexible(
                                  child: body1Text("Scheduled "),
                                )
                              ],
                            ),
                          ),
                          width(28),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 33.w,
                                  height: 33.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                width(8),
                                Flexible(child: body1Text("Unavailable"))
                              ],
                            ),
                          )
                        ],
                      ),
                      height(28),
                      BlocBuilder<CalendarCubit, CalendarState>(
                        builder: (context, state) {
                          if (state is CalendarLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          } else if (state is CalendarLoadedState) {
                            // Access the loaded plan from the state
                            print("llllllllllllllllllllllllllllll");
                            return Consumer<SessionProvider>(
                              builder: (context, sessionProvider, child) {
                                return CalendarContainer(
                                  calendarCubit: calendarCubit,
                                  sessionProvider: sessionProvider,
                                );
                              },
                            );
                          } else if (state is CalendarErrorState) {
                            return Text('Error: ${state.error}');
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      height(64),
                      SessionScreenButton(
                        text: "Orientation Sessions",
                        color: AppColors.megenta,
                        onpressed: () {
                          Routes.goTo(
                            Screens.orientation,
                          );
                        },
                      ),
                      height(16),
                      SessionScreenButton(
                        text: "Group Sessions",
                        color: AppColors.primaryBlue,
                        onpressed: () {
                          Routes.goTo(
                            Screens.groupSession,
                          );
                        },
                      ),
                      height(16),
                      SessionScreenButton(
                        text: "One on One Sessions",
                        color: AppColors.primaryGreen,
                        onpressed: () {
                          Routes.goTo(
                            Screens.oneOneSession,
                          );
                        },
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    ));
  }
}
