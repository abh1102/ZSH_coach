import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/one_on_one_session/widgets/one_one_session_request_container.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';

import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';

class OneOneSessionRequest extends StatefulWidget {
  const OneOneSessionRequest({super.key});

  @override
  State<OneOneSessionRequest> createState() => _OneOneSessionRequestState();
}

class _OneOneSessionRequestState extends State<OneOneSessionRequest> {
  late AllSessionCubit sessionCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sessionCubit = BlocProvider.of<AllSessionCubit>(context);
    sessionCubit.getAcceptSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is EditSessionState) {
            showGreenSnackBar(state.message);
            sessionCubit.getAcceptSession();
          }
          if (state is UserLoadingState) {
            const CircularProgressIndicator.adaptive();
          }
          if (state is UserErrorState) {
            showSnackBar(state.error);
          }
        },
        child: Scaffold(
          appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Session", secondText: "Requests"),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 28.h,
                horizontal: 28.w,
              ),
              child: Column(
                children: [
                  BlocBuilder<AllSessionCubit, AllSessionState>(
                    builder: (context, state) {
                      if (state is AllSessionLoadingState) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (state is AcceptOneSessionLoadedState) {
                        // Access the loaded plan from the state
                        if (state.acceptOneSessions.isEmpty) {
                          return Center(
                            child: simpleText(
                                "There is no One On One Sessin Request"),
                          );
                        }
                        return ListView.builder(
                            itemCount: state.acceptOneSessions.length,
                            shrinkWrap: true,
                            itemBuilder: (contex, index) {
                              var data = state.acceptOneSessions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: OneOneSessionRequestContainer(
                                    offeringName: data.offeringName ?? "",
                                    imgUrl: data.userInfo?.image,
                                    decline: () {
                                      BlocProvider.of<UserCubit>(context)
                                          .editSession(
                                              sessionId: data.sId ?? " ",
                                              isApproved: false,
                                              reasonMessage:
                                                  "Decline By Coach");
                                    },
                                    accept: () {
                                      BlocProvider.of<UserCubit>(context)
                                          .editSession(
                                              sessionId: data.sId ?? " ",
                                              isApproved: true,
                                              reasonMessage:
                                                  "Accepted By Coach");
                                    },
                                    onpressed: () {
                                      Routes.goTo(
                                        Screens.oneOneSessionProfile,
                                        arguments: data.userId,
                                      );
                                    },
                                    time:
                                        myformattedTime(data.startDate ?? " "),
                                    date:
                                        myformattedDate(data.startDate ?? " "),
                                    name: data.userInfo?.fullName ?? ""),
                              );
                            });
                      } else if (state is AllSessionErrorState) {
                        print(state.error);
                        return Text('Error: ${state.error}');
                      } else {
                        return const Text('Something is wrong');
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
        ));
  }
}