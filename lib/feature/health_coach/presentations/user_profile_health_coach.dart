import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/widgets/my_rating_row.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/data/model/signed_url_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';

class GUHealthCoachDetailScreen extends StatefulWidget {
  final CoachInfo coachInfo;
  final CoachProfile coachProfile;
  const GUHealthCoachDetailScreen(
      {super.key, required this.coachInfo, required this.coachProfile});

  @override
  State<GUHealthCoachDetailScreen> createState() =>
      _GUHealthCoachDetailScreenState();
}

class _GUHealthCoachDetailScreenState extends State<GUHealthCoachDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProfileTemplateUrl();
  }

  String? url;

  LoginRepository repo = LoginRepository();
  Future<void> _fetchProfileTemplateUrl() async {
    try {
      // Call the getSignedUrl function from the LoginCubit
      SignedUrlModel model =
          await repo.getSignedUrl(fileName: widget.coachInfo.image ?? "");

      if (mounted) {
        setState(() {
          url = model.signedUrl;
        });
      }
    } catch (e) {
      showSnackBar(e.toString());
      print("Error fetching signed URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButtonWOSilver(
          firstText: "Health", secondText: "Coach"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.w,
            vertical: 28.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageWidget(
                url: widget.coachInfo.image == null
                    ? defaultAvatar
                    : url ?? "",
                myradius: 12,
                mywidth: double.infinity,
                myheight: 226.h,
              ),
              height(20),
              NewMyRatingRow(
                name: widget.coachProfile.fullName ?? "",
                rating: widget.coachInfo.rating == null
                    ? "0"
                    : widget.coachInfo.rating.toString(),
                fontSize: 18,
                weight: FontWeight.w700,
                starSize: 15,
              ),
              height(8),
              simpleText(
                "Experience: ${widget.coachProfile.experience == null ? "0" : widget.coachProfile.experience ?? ""} Years+",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              height(16),
              body2Text("Description "),
              height(5),
              body2Text(
                widget.coachInfo.description == null
                    ? ""
                    : widget.coachInfo.description??""
                        ,
                color: AppColors.textLight,
              ),
              height(15),
              CustomImageWidget(
                url: widget.coachInfo.image == null
                    ? defaultAvatar
                    : url ?? "",
                myradius: 12,
                mywidth: double.infinity,
                myheight: 226.h,
              ),
              height(64),
              ColoredButtonWithoutHW(
                isLoading: false,
                onpressed: () {
                  Routes.goTo(Screens.guseeAll, arguments: widget.coachInfo.myVideos);
                },
                verticalPadding: 16,
                text: "See All",
                size: 16,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
