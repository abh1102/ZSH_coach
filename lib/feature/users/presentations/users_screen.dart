import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/widgets/image_widget.dart';
import 'package:zanadu_coach/widgets/tag_container.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UserCubit userCubit;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUserListByCoach();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const SafeArea(
              child: Center(child: CircularProgressIndicator.adaptive()));
        } else if (state is GetUserListState) {
          var data = state.userList.length;

          if (state.userList.isEmpty) {
            return SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textDark,
                            ),
                          ),
                          width(3),
                          Text(
                            "Users",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: Center(child: simpleText("No Users"))));
          }

          return Scaffold(
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      floating: false,
                      pinned: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textDark,
                            ),
                          ),
                          width(3),
                          Text(
                            "Users",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: SearchBarDelegate(
                        onSearch: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Filter the user list based on the search query
                          if (state.userList[index].userList?.fullName
                                  ?.toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ??
                              false) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h), // Adjust vertical padding
                              child: GestureDetector(
                                onTap: () {
                                  Routes.goTo(Screens.oneOneSessionProfile,
                                      arguments: state.userList[index].userId);
                                },
                                child: UserScreenRowWidget(
                                  offeringName:
                                      state.userList[index].offeringName ?? [],
                                  imgUrl: state.userList[index].userList?.image,
                                  userId: state.userList[index].userId ?? " ",
                                  username: state
                                          .userList[index].userList?.fullName ??
                                      "",
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container if not matching the search query
                          }
                        },
                        childCount: data,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is UserErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Text('Something is wrong');
        }
      },
    );
  }
}

class UserScreenRowWidget extends StatefulWidget {
  final List<String> offeringName;
  final String userId;
  final String username;
  final String? imgUrl;

  const UserScreenRowWidget({
    Key? key,
    required this.username,
    required this.userId,
    this.imgUrl,
    required this.offeringName,
  }) : super(key: key);

  @override
  State<UserScreenRowWidget> createState() => _UserScreenRowWidgetState();
}

class _UserScreenRowWidgetState extends State<UserScreenRowWidget> {
  @override
  Widget build(BuildContext context) {
    // String firstLetter = widget.offeringName.isNotEmpty
    //     ? widget.offeringName[0].toLowerCase()
    //     : '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
            ),
            child: Row(
              children: [
                CircularCustomImageWidget(
                  url: widget.imgUrl ?? defaultAvatar,
                  myheight: 44,
                  mywidth: 44,
                ),
                width(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      simpleText(
                        widget.username,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      height(3),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            widget.offeringName.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: TagContainer(
                                firstLetter: widget.offeringName[index],
                                fontSize: 9,
                                padding: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        PopupMenuButton<String>(
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          icon: SvgPicture.asset("assets/icons/horizontal_dot.svg"),
          onSelected: (value) {
            Routes.goTo(Screens.scheduleFollowUp, arguments: widget.userId);
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'schedule',
                child: Text(
                  'Schedule Follow-Up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Function(String) onSearch;

  SearchBarDelegate({
    required this.onSearch,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        height: 61.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryGreen),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            width(10.0),
            SvgPicture.asset(
              "assets/icons/search.svg",
              width: 21.w,
              height: 21.h,
            ), // Search Icon
            width(10.0),
            Expanded(
              child: TextField(
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: "Search Users",
                  border: InputBorder.none,
                ),
                onChanged: onSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 61.h;

  @override
  double get minExtent => 61.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
