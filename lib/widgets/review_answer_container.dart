import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';


class ReviewAnswerContainer extends StatelessWidget {
  final String question;
  final List<String> answer;
  final int number;
  const ReviewAnswerContainer({
    super.key,
    required this.question,
    required this.answer,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24.h,
        horizontal: 19.w,
      ),
      decoration: BoxDecoration(
        gradient: Insets.fixedGradient(opacity: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child:
          ReviewAnswerRow(number: number, question: question, answers: answer),
    );
  }
}

class ReviewAnswerRow extends StatelessWidget {
  final String question;
  final List<String> answers;
  final int number;

  const ReviewAnswerRow({
    Key? key,
    required this.number,
    required this.question,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.2), // Adjust as needed
        1: FlexColumnWidth(0.9), // Adjust as needed
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: body1Text(
                "Q.$number",
                color: AppColors.textDark,
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: body1Text(
                  question,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: simpleText(
                "Ans-",
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers
                      .map((answer) => simpleText(
                            answer,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
