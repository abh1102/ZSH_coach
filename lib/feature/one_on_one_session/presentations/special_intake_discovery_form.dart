import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/review_answer_container.dart';

class SpecialIntakeDiscoveryForm extends StatefulWidget {
  final String userId;
  final String category;

  const SpecialIntakeDiscoveryForm(
      {super.key, required this.userId, required this.category});

  @override
  State<SpecialIntakeDiscoveryForm> createState() =>
      _SpecialIntakeDiscoveryFormState();
}

class _SpecialIntakeDiscoveryFormState
    extends State<SpecialIntakeDiscoveryForm> {
  late UserCubit userCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUsersSpecialAnswer(
        id: widget.userId, category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    String heading = '';

    if (widget.category == "ENERGY_SPECIAL") {
      heading = "Energy";
    } else if (widget.category == "MINDSET_SPECIAL") {
      heading = "Mindset";
    } else {
      heading = "Nutrition";
    }
    return Scaffold(
      appBar: AppBarWithBackButtonWOSilver(
          firstText: heading, secondText: "Intake Form"),
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
              } else if (state is GetSpecialUserAnswersState) {
                // Access the loaded plan from the state
                if (state.result.isEmpty) {
                  return Center(
                    child: simpleText("No Data"),
                  );
                }
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.result.length,
                    itemBuilder: (context, index) {
                      var data = state.result[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ReviewAnswerContainer(
                            question: data.questionName ?? "",
                            answer: data.answer ?? [],
                            number: index + 1),
                      );
                    });
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
