import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/one_on_one_session/widgets/profile_view_first_container.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';

class OneSessionProfileView extends StatefulWidget {
  final String userId;
  const OneSessionProfileView({super.key, required this.userId});

  @override
  State<OneSessionProfileView> createState() => _OneSessionProfileViewState();
}

class _OneSessionProfileViewState extends State<OneSessionProfileView> {
  late UserCubit userCubit;

  @override
  void initState() {
    super.initState();

    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUserDetail(id: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "User", secondText: "Profile"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 28.h,
            horizontal: 28.w,
          ),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is UserInfoState) {
                // Access the loaded plan from the state

                var data = state.user;

                List<SessionList> sessionList = data.sessionList ?? [];

                int groupSessionCount = 0;
                int oneOnOneSessionCount = 0;

                // Count the number of group sessions and one-on-one sessions
                groupSessionCount = sessionList
                    .where((session) =>
                        session.sessionType == "GROUP" ||
                        session.sessionType == "YOGA")
                    .length;
                oneOnOneSessionCount = sessionList
                    .where((session) =>
                        session.sessionType == "FOLLOW_UP" ||
                        session.sessionType == "DISCOVERY")
                    .length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileViewFirstContainer(
                        imgUrl: data.userInfo?.image,
                        date: myformattedDate(data.createdAt ?? " "),
                        name: data.userInfo?.fullName ?? ""),
                    height(28),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(Screens.oneOneSessionDiscovery,
                            arguments: data.userId);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText(
                              "Health Intake Form",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    height(20),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(Screens.oneOneSessionSpecialDiscovery,
                            arguments: {
                              'userId': widget.userId,
                              'category': 'ENERGY_SPECIAL'
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText(
                              "Energy Intake Form",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    height(20),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(Screens.oneOneSessionSpecialDiscovery,
                            arguments: {
                              'userId': widget.userId,
                              'category': 'MINDSET_SPECIAL'
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText(
                              "Mindest Intake Form",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    height(20),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(Screens.oneOneSessionSpecialDiscovery,
                            arguments: {
                              'userId': widget.userId,
                              'category': 'NUTRITION_SPECIAL'
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText(
                              "Nutrition Intake Form",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    height(20),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(
                          Screens.updateZHScoreCard,
                          arguments: {
                            'date': data.createdAt,
                            'name': data.userInfo?.fullName ?? "",
                            'userId': data.userId,
                            'imgUrl': data.userInfo?.image ?? ""
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText("ZH Health Score",
                                fontSize: 18, fontWeight: FontWeight.w700),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    if (isHealthCoach(
                            myCoach?.profile?.primaryOfferingId ?? "") ==
                        true)
                      height(20),
                    if (isHealthCoach(
                            myCoach?.profile?.primaryOfferingId ?? "") ==
                        true)
                      GestureDetector(
                        onTap: () {
                          Routes.goTo(Screens.recommendedOffering,
                              arguments: widget.userId);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 14.h, horizontal: 17.w),
                          decoration: BoxDecoration(
                              gradient: Insets.fixedGradient(opacity: 0.16),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              simpleText(
                                "Selected Offerings",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              SvgPicture.asset("assets/icons/Vector (5).svg")
                            ],
                          ),
                        ),
                      ),
                    height(20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 17.w),
                      decoration: BoxDecoration(
                          gradient: Insets.fixedGradient(opacity: 0.16),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileViewSessionTakenRow(
                            isBold: false,
                            first: "Sessions Taken",
                            second: (data.sessionList?.length ?? 0).toString(),
                          ),
                          height(10),
                          ProfileViewSessionTakenRow(
                            isBold: true,
                            first: "Group Sessions",
                            second: groupSessionCount.toString(),
                          ),
                          height(10),
                          ProfileViewSessionTakenRow(
                            isBold: true,
                            first: "One on One Sessions",
                            second: oneOnOneSessionCount.toString(),
                          ),
                          height(10),
                        ],
                      ),
                    ),
                    height(20),
                    GestureDetector(
                      onTap: () {
                        Routes.goTo(Screens.notes, arguments: data.userId);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 17.w),
                        decoration: BoxDecoration(
                            gradient: Insets.fixedGradient(opacity: 0.16),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            simpleText("Notes",
                                fontSize: 18, fontWeight: FontWeight.w700),
                            SvgPicture.asset("assets/icons/Vector (5).svg")
                          ],
                        ),
                      ),
                    ),
                    if (data.coachType == 'HEALTH')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height(20),
                          simpleText(
                            "Assigned Health Coach",
                            fontWeight: FontWeight.w600,
                          ),
                          height(16),
                          GestureDetector(
                            onTap: () {
                              Routes.goTo(
                                Screens.guHealthDetailCoachScreen,
                                arguments: {
                                  'coachInfo': data.coachInfo,
                                  'coachProfile': data.coachProfile,
                                },
                              );
                            },
                            child: HealthCoachProfileViewContainer(
                                imgUrl: data.coachProfile?.image,
                                name: data.coachProfile?.fullName ?? ''),
                          ),
                        ],
                      ),
                    height(64),
                    ColoredButtonWithoutHW(
                      isLoading: false,
                      onpressed: () {
                        Routes.goTo(Screens.scheduleFollowUp,
                            arguments: data.userId);
                      },
                      text: "Schedule Follow-Up",
                      size: 16,
                      weight: FontWeight.w600,
                      verticalPadding: 16,
                    )
                  ],
                );
              } else if (state is UserErrorState) {
                return Text('Error: ${state.error}');
              } else {
                return const Text('Something is wrong');
              }
            },
          ),
        ),
      )),
    );
  }
}

class ProfileViewSessionTakenRow extends StatelessWidget {
  final bool isBold;
  final String first;
  final String second;
  const ProfileViewSessionTakenRow({
    super.key,
    required this.first,
    required this.second,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        simpleText(
          first,
          fontSize: isBold ? 16 : 18,
          fontWeight: isBold ? FontWeight.w500 : FontWeight.w700,
        ),
        simpleText(second,
            fontSize: isBold ? 16 : 18,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w700),
      ],
    );
  }
}

bool isHealthCoach(String coachId) {
  // Check if coachInfo is available
  bool isOneOnOne = false;

  String? offeringId = coachId;

  for (OfferingsModel offerings in myOfferings ?? []) {
    if (offerings.sId == offeringId) {
      if (offerings.title == "Health") {
        isOneOnOne = true;
        return isOneOnOne;
      }
    }
  }

  return isOneOnOne; // The coach is not a Yoga or Meditation coach
}
