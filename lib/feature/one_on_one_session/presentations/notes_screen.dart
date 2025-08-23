import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/date_converter.dart';

class NotesScreen extends StatefulWidget {
  final String userId;
  const NotesScreen({super.key, required this.userId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController controller = TextEditingController();
  late UserCubit userCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUserNotes(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is CreateNoteState) {
            controller.clear();
            userCubit.getUserNotes(userId: widget.userId);
            showGreenSnackBar(state.message);
          }
        },
        child: Scaffold(
          appBar: NotesAppBar(
            controller: controller,
            onpressed: () {
              userCubit.postPersonalNote(
                  userId: widget.userId, notes: controller.text);

              Navigator.of(context).pop();
            },
            firstText: "Notes",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoadingState) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    } else if (state is GetUserNotesState) {
                      // Access the loaded plan from the state
                      var data = state.notes;
                      if (data.isEmpty) {
                        return Center(
                          child: simpleText("There is no notes of this user"),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var note = data[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: NotesContainer(
                                date: myformattedDate(note.createdAt ?? " "),
                                note: note.notes ?? "",
                                time: myformattedTime(note.createdAt ?? " ")),
                          );
                        },
                        itemCount: data.length,
                        shrinkWrap: true,
                      );
                    } else if (state is UserErrorState) {
                      return Text('Error: ${state.error}');
                    } else {
                      return const Text('Something is wrong');
                    }
                  },
                ),
              ),
            ),
          ),
        ));
  }
}

class NotesContainer extends StatelessWidget {
  final String date;
  final String time;
  final String note;
  const NotesContainer({
    super.key,
    required this.date,
    required this.time,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15,
          ),
          border: Border.all(color: AppColors.greyLight)),
      child: Column(
        children: [
          Form(
            child: TextFormField(
              enabled: false,
              initialValue: note,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          height(8),
          Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset("assets/icons/calendar.svg"),
              width(5),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    date,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              width(9),
              SvgPicture.asset("assets/icons/clock.svg"),
              width(5),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: simpleText(
                    time,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textLight,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
