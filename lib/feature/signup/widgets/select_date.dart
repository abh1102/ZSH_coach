import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/profile/logic/provider/edit_profile_provider.dart';
import 'package:zanadu_coach/feature/signup/logic/provider/signup_provider.dart';
import 'package:zanadu_coach/widgets/format_date.dart';

class SelectStartDate extends StatelessWidget {
  const SelectStartDate({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final SignUpProvider provider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.pickStartDate();
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyDark)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDate(provider.startDate),
                style: TextStyle(
                  color: provider.startDate != null
                      ? AppColors.textLight.withOpacity(0.7)
                      : Colors.grey,
                ),
              ),
              width(15),
              SvgPicture.asset('assets/icons/Group (2).svg')
            ],
          ),
        ),
      ),
    );
  }
}

class SelectStartDateEditProfile extends StatelessWidget {
  const SelectStartDateEditProfile({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final EditProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          provider.pickStartDate();
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greyDark)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                 provider.startDate==null?myCoach?.profile?.dOB??"":
                  formatDate(provider.startDate),
                  style: TextStyle(
                    color: provider.startDate != null
                        ? AppColors.textLight.withOpacity(0.7)
                        : Colors.grey,
                  ),
                ),
                width(15),
                SvgPicture.asset('assets/icons/Group (2).svg')
              ],
            ),
          ),
        ),
      );
    });
  }
}



// class SelectStartDateSession extends StatelessWidget {
//   const SelectStartDateSession({
//     Key? key,
//     required this.provider,
//   }) : super(key: key);

//   final SessionProvider provider;

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return GestureDetector(
//         onTap: () {
//           provider.pickStartDate();
//         },
//         child: Container(
//           height: 56.h,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.greyDark)),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 17.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   formatDate(provider.startDate),
//                   style: TextStyle(
//                     color: provider.startDate != null
//                         ? AppColors.textLight.withOpacity(0.7)
//                         : Colors.grey,
//                   ),
//                 ),
//                 width(15),
//                 SvgPicture.asset('assets/icons/Group (2).svg')
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
