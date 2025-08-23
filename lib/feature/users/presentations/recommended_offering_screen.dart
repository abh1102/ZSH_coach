import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/users/data/model/recommended_offering_model.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/feature/users/widgets/speciality_container.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';

class RecommendedOfferingScreen extends StatefulWidget {
  final String userId;
  const RecommendedOfferingScreen({super.key, required this.userId});

  @override
  State<RecommendedOfferingScreen> createState() =>
      _RecommendedOfferingScreenState();
}

class _RecommendedOfferingScreenState extends State<RecommendedOfferingScreen> {
  List<OfferingsModel> allOfferings = [];
  List<RecommendedOfferingModel> recommendedOfferings = [];
  List<String> selectedOfferingIds = [];

  bool isLoading = true;
  late UserCubit userCubit;
  @override
  void initState() {
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.fetchAllAndRecommendedOfferings(
        widget.userId, myCoach?.userId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is CreateRecommendedOfferingsState) {
            showGreenSnackBar(state.message);
            
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
            firstText: "Selected",
            secondText: "Offerings",
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 28.h,
                horizontal: 28.w,
              ),
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetAllAndRecommendedOfferingsState) {
                    allOfferings = state.allOfferings;
                    recommendedOfferings = state.recommendedOfferings;
                    selectedOfferingIds = recommendedOfferings
                        .map((offering) => offering.offeringId ?? "")
                        .toList();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (OfferingsModel offering in allOfferings)
                            Column(
                              children: [
                                SpecialityCoachContainer(
                                  isChecked: recommendedOfferings.any(
                                    (recOffering) =>
                                        recOffering.offeringId == offering.sId,
                                  ),
                                  text1: offering.title ?? "",
                                  imgUrl: offering.icon,
                                  onChanged: (isChecked) {
                                    if (isChecked) {
                                      selectedOfferingIds
                                          .add(offering.sId ?? "");
                                    } else {
                                      selectedOfferingIds.remove(offering.sId);
                                    }
                                  },
                                ),
                                height(16)
                              ],
                            ),
                          height(40),
                          ColoredButtonWithoutHW(
                            isLoading: state is UserLoadingState,
                            onpressed: () {
                              userCubit.createRecommendedOfferings(
                                  widget.userId, selectedOfferingIds);
                            },
                            text: "Update Offerings",
                            size: 16,
                            weight: FontWeight.w600,
                            verticalPadding: 16,
                          )
                        ],
                      ),
                    );
                  } else if (state is UserErrorState) {
                    return Center(
                      child: simpleText(
                        state.error,
                        align: TextAlign.center,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
