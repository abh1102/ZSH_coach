import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/review_answer_container.dart';

class OneSessionDiscoveryForm extends StatefulWidget {
  final String userId;

  const OneSessionDiscoveryForm({super.key, required this.userId});

  @override
  State<OneSessionDiscoveryForm> createState() =>
      _OneSessionDiscoveryFormState();
}

class _OneSessionDiscoveryFormState extends State<OneSessionDiscoveryForm> {
  late UserCubit userCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUsersAnswer(id: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "Health", secondText: "Intake Form"),
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
              } else if (state is GetUserAnswersState) {
                // Access the loaded plan from the state

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
                            number: index+1),
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
