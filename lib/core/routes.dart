import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/feature/analytic/presentations/analytic_screen.dart';
import 'package:zanadu_coach/feature/groupsession/presentations/create_group_session.dart';
import 'package:zanadu_coach/feature/groupsession/presentations/group_session_screen.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/all_health_coach_model.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/get_video_cubit/get_video_cubit.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/all_see_all_screen.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/gusee_all.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/health_coach_detail_screen.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/see_all_screen.dart';
import 'package:zanadu_coach/feature/health_coach/presentations/user_profile_health_coach.dart';
import 'package:zanadu_coach/feature/home/presentations/home_bottombar.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart'
    hide CoachInfo;
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/logic/signup_cubit/signup_cubit.dart';
import 'package:zanadu_coach/feature/login/presentations/login_screen.dart';
import 'package:zanadu_coach/feature/onboarding/presentations/onboarding_two.dart';
import 'package:zanadu_coach/feature/onboarding/presentations/splash_screen.dart';
import 'package:zanadu_coach/feature/onboarding/presentations/splash_screen_one.dart';
import 'package:zanadu_coach/feature/onboarding/presentations/splash_screen_two.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/notes_screen.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/one_one_session.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/one_one_session_request.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/one_session_discovery_form.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/one_session_profile_view.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/schedule_follow_up.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/special_intake_discovery_form.dart';
import 'package:zanadu_coach/feature/one_on_one_session/presentations/update_zh_scorecard.dart';
import 'package:zanadu_coach/feature/onetimepasscode/presentation/one_time_password.dart';
import 'package:zanadu_coach/feature/orientation_session/presentations/orientation_sessions.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/about_cubit/about_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/notification_cubit/notification_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/cubit/switch_profile/switch_profile_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/provider/edit_profile_provider.dart';
import 'package:zanadu_coach/feature/profile/presentations/calendar_reminder_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/edit_profile_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/help_and_support/TicketHistoryScreen.dart';
import 'package:zanadu_coach/feature/profile/presentations/help_and_support/about_us.dart';
import 'package:zanadu_coach/feature/profile/presentations/help_and_support/help_support_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/help_and_support/payment_issue.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/change_email.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/change_pass_email.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/change_pass_pass.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/change_password.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/change_phone.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/my_account_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/one_time_pass_pass.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_account/one_time_passcode.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_info_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_videos/add_new_video.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_videos/key_video_detail_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_videos/local_video_playing_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_videos/my_videos.dart';
import 'package:zanadu_coach/feature/profile/presentations/my_videos/my_videos_detail_screen.dart';
import 'package:zanadu_coach/feature/profile/presentations/profile_notification.dart';
import 'package:zanadu_coach/feature/profile/presentations/profile_screen.dart';

import 'package:zanadu_coach/feature/session/logic/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/session_cubit/session_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/today_schedule_session_cubit/today_schedule_session_cubit.dart';
import 'package:zanadu_coach/feature/session/presentations/reminder_screen.dart';
import 'package:zanadu_coach/feature/session/presentations/reschedule_session.dart';
import 'package:zanadu_coach/feature/session/presentations/schedule_screen.dart';
import 'package:zanadu_coach/feature/signup/logic/provider/signup_provider.dart';
import 'package:zanadu_coach/feature/signup/presentations/signUp_first.dart';
import 'package:zanadu_coach/feature/signup/presentations/signup_second.dart';
import 'package:zanadu_coach/feature/signup/presentations/third_party_signup.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';
import 'package:zanadu_coach/feature/users/logic/user_cubit/user_cubit.dart';
import 'package:zanadu_coach/feature/users/presentations/recommended_offering_screen.dart';
import 'package:zanadu_coach/feature/video_calling/group_video_calling.dart';

/// All of the screens in the app will be added here for reference
class Screens {
  static const splash = "splash";
  static const welcome = "welcome";
  static const homeBottomBar = "homeBottomBar";
  static const home = "home";
  static const login = "login";
  static const splashOne = "splashOne";
  static const splashTwo = 'splashTwo';
  static const onboardingTwo = 'onboardingTwo';
  static const signupscreenfirst = 'signupscreenfirst';
  static const signupscreensecond = 'signupscreensecond';
  static const thirdpartysignupscreensecond = 'thirdpartysignupscreensecond';
  static const analytic = "analytic";
  static const oneTimePassword = 'oneTimePassword';
  static const forgetPassword = 'forgetPassword';
  static const forgetPasswordTwo = 'forgetPasswordTwo';
  static const forgetPasswordThree = 'forgetPasswordThree';
  static const inSessionMessage = 'inSessionMessage';
  static const editProfileScreen = 'editProfileScreen';
  static const editProfileNotificationScreen = 'editProfileNotificationScreen';
  static const calenderReminder = 'calenderReminder';
  static const myAccount = 'myAccount';
  static const helpSupport = 'helpSupport';
  static const helpSupportAbout = 'helpSupportAbout';
  static const changePassword = 'changePassword';
  static const changeEmail = 'changeEmail';
  static const changePhone = 'changePhone';
  static const healthCoachDetail = 'healthCoachDetail';
  static const profileOneTimePasscode = 'profileOneTimePasscode';
  static const groupSession = 'groupSession';
  static const createGroupSession = 'createGroupSession';
  static const oneOneSession = 'oneOneSession';
  static const oneOneSessionRequest = 'oneOneSessionRequest';
  static const oneOneSessionProfile = 'oneOneSessionProfile';
  static const oneOneSessionDiscovery = 'oneOneSessionDiscovery';
  static const oneOneSessionSpecialDiscovery = 'oneOneSessionSpecialDiscovery';
  static const updateZHScoreCard = 'updateZHScoreCard';
  static const scheduleFollowUp = 'scheduleFollowUp';
  static const helpSupportPayment = "helpSupportPayment";
  static const addNewVideo = "addNewVideo";
  static const ticketHistoryScreen="ticketHistoryScreen";
  static const myVideos = "myVideos";
  static const payOuts = "payOuts";
  static const myVideosDetail = "myVideosDetail";
  static const keymyVideosDetail = "keymyVideosDetail";
  static const profile = "profile";
  static const notes = "notes";
  static const orientation = "orientation";
  static const schedule = "schedule";
  static const reschedulesession = "reschedulesession";
  static const seeAll = "seeAll";
  static const allseeAll = "allseeAll";
  static const guseeAll = "guseeAll";
  static const oneOnOneVideo = "oneOnOneVideo";
  static const groupVideo = "groupVideo";
  static const myInfo = "myInfo";
  static const guHealthDetailCoachScreen = "guHealthDetailCoachScreen";
  static const recommendedOffering = "recommendedOffering";
  static const changePassPassword = 'changePassPassword';
  static const changePassEmail = 'changePassEmail';
  static const reminderScreen = 'reminderScreen';
  static const profileOneTimePassPasscode = 'profileOneTimePassPasscode';
  static const localVideoPlayingScreen = 'localVideoPlayingScreen';
}

class Routes {
  /// Global NavigatorKey to be used inside the MaterialApp
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Implementation of the onGenerateRoute function inside the MaterialApp
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Screens.splash:
        return CupertinoPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case Screens.splashOne:
        return CupertinoPageRoute(
          builder: (context) => const SplashScreenOne(),
        );

      case Screens.splashTwo:
        return CupertinoPageRoute(
          builder: (context) => const SplashScreenTwo(),
        );

      case Screens.onboardingTwo:
        return CupertinoPageRoute(
          builder: (context) => const OnBoardingTwoScreen(),
        );

      case Screens.signupscreenfirst:
        return CupertinoPageRoute(
          builder: (context) => const SignUpScreenFirst(),
        );

      case Screens.signupscreensecond:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignUpCubit(),
            child: ChangeNotifierProvider(
              create: (context) => SignUpProvider(context),
              child: const SignUpSecondScreen(),
            ),
          ),
        );

      case Screens.thirdpartysignupscreensecond:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignUpCubit(),
            child: ChangeNotifierProvider(
              create: (context) => SignUpProvider(context),
              child: ThirdPartySignUpSecondScreen(
                email: settings.arguments as String,
              ),
            ),
          ),
        );

      case Screens.login:
        return CupertinoPageRoute(
          builder: (context) =>
              LoginScreen(isBackButton: settings.arguments as bool),
        );

      case Screens.oneTimePassword:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignUpCubit(),
            child: ChangeNotifierProvider(
              create: (context) => SignUpProvider(context),
              child: const OneTimePassword(),
            ),
          ),
        );

      case Screens.homeBottomBar:
        return CupertinoPageRoute(
          builder: (context) => HomeBottomBar(),
        );

      case Screens.analytic:
        return CupertinoPageRoute(
          builder: (context) => AnalyticScreen(),
        );

      case Screens.healthCoachDetail:
        return CupertinoPageRoute(
          builder: (context) => HealthCoachDetailScreen(
              healthCoach: settings.arguments as AllHealthCoachesModel),
        );

      case Screens.groupSession:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSessionCubit(),
            child: GroupSession(),
          ),
        );

      case Screens.createGroupSession:
        return CupertinoPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AllSessionCubit(),
              ),
              BlocProvider(
                create: (context) => TodayScheduleSessionCubit(),
              ),
            ],
            child: const CreateGroupSession(),
          ),
        );

      case Screens.oneOneSession:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSessionCubit(),
            child: OneOneSessionScreen(),
          ),
        );

      case Screens.oneOneSessionRequest:
        return CupertinoPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AllSessionCubit(),
              ),
              BlocProvider(
                create: (context) => UserCubit(),
              ),
            ],
            child: const OneOneSessionRequest(),
          ),
        );

      case Screens.oneOneSessionProfile:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => UserCubit(),
            child: OneSessionProfileView(userId: settings.arguments as String),
          ),
        );

      case Screens.oneOneSessionDiscovery:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => UserCubit(),
            child:
                OneSessionDiscoveryForm(userId: settings.arguments as String),
          ),
        );

      case Screens.oneOneSessionSpecialDiscovery:
        var arguments = settings.arguments as Map<String, dynamic>?;

        // Check if arguments is not null before accessing its values
        if (arguments != null) {
          String userId = arguments['userId'];
          String category = arguments['category'];

          // Use date and name in your screen
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => UserCubit(),
              child: SpecialIntakeDiscoveryForm(
                userId: userId,
                category: category,
              ),
            ),
          );
        } else {
          // Handle the case where arguments is null
          return null;
        }

      case Screens.updateZHScoreCard:
        var arguments = settings.arguments as Map<String, dynamic>?;

        // Check if arguments is not null before accessing its values
        if (arguments != null) {
          String date = arguments['date'];
          String name = arguments['name'];
          String userId = arguments['userId'];
          String imgUrl = arguments['imgUrl'];

          // Use date and name in your screen
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => UserCubit(),
              child: UpdateZHScoreCard(
                data: date,
                name: name,
                userId: userId,
                imgUrl: imgUrl,
              ),
            ),
          );
        } else {
          // Handle the case where arguments is null
          return null;
        }

      case Screens.guHealthDetailCoachScreen:
        var arguments = settings.arguments as Map<String, dynamic>?;

        // Check if arguments is not null before accessing its values
        if (arguments != null) {
          CoachInfo coachInfo = arguments['coachInfo'];
          CoachProfile coachProfile = arguments['coachProfile'];

          // Use date and name in your screen
          return CupertinoPageRoute(
            builder: (context) => GUHealthCoachDetailScreen(
              coachInfo: coachInfo,
              coachProfile: coachProfile,
            ),
          );
        } else {
          // Handle the case where arguments is null
          return null;
        }

      case Screens.scheduleFollowUp:
        return CupertinoPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AllSessionCubit(),
              ),
              BlocProvider(
                create: (context) => TodayScheduleSessionCubit(),
              ),
            ],
            child: ScheduleFollowUp(userId: settings.arguments as String),
          ),
        );

      case Screens.editProfileScreen:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => EditProfileProvider(context),
            child: const EditProfileScreen(),
          ),
        );

      case Screens.myInfo:
        return CupertinoPageRoute(
          builder: (context) => const MyInfoScreen(),
        );

      case Screens.editProfileNotificationScreen:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NotificationCubit(),
                  child: ProfileNotificationScreen(),
                ));

      case Screens.calenderReminder:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSessionCubit(),
            child: const CalendarReminderScreen(),
          ),
        );

      case Screens.myAccount:
        return CupertinoPageRoute(
          builder: (context) => MyAccountScreen(),
        );

      case Screens.helpSupport:
        return CupertinoPageRoute(
          builder: (context) => HelpSupportScreen(),
        );

      case Screens.helpSupportAbout:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AboutCubit(),
            child: const HelpSupportAboutUs(),
          ),
        );

      case Screens.changePassword:
        return CupertinoPageRoute(
          builder: (context) => ChangePasswordScreen(),
        );

      case Screens.groupVideo:
        var arguments = settings.arguments as Map<String, dynamic>?;

        // Check if arguments is not null before accessing its values
        if (arguments != null) {
          String channelId = arguments['channelId'];
          String endtime = arguments['endtime'];
          String sessionId = arguments['sessionId'];
          String chatroomId = arguments['chatroomId'];

          // Use date and name in your screen
          return CupertinoPageRoute(
            builder: (context) => GroupVideoCall(
              channelId: channelId,
              endtime: endtime,
              sessionId: sessionId,
              chatroomId: chatroomId,
            ),
          );
        } else {
          // Handle the case where arguments is null
          return null;
        }

      case Screens.changeEmail:
        return CupertinoPageRoute(
          builder: (context) => ChangeEmailScreen(),
        );

      case Screens.changePhone:
        return CupertinoPageRoute(
          builder: (context) => ChangePhoneScreen(),
        );

      case Screens.profileOneTimePasscode:
        return CupertinoPageRoute(
          builder: (context) => ProfileOneTimePassword(),
        );

      case Screens.helpSupportPayment:
        return CupertinoPageRoute(
          builder: (context) => HelpSupportPaymentIssue(),
        );

      case Screens.myVideos:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => GetVideoCubit(),
            child: const MyVideosScreen(),
          ),
        );

      case Screens.addNewVideo:
        return CupertinoPageRoute(
          builder: (context) => AddNewVideo(),
        );

      case Screens.myVideosDetail:
        return CupertinoPageRoute(
          builder: (context) =>
              MyVideosDetailScreen(videos: settings.arguments as MyVideos),
        );
      case Screens.ticketHistoryScreen:
        return CupertinoPageRoute(
          builder: (context) => TicketHistoryScreen(),
        );

      case Screens.keymyVideosDetail:
        return CupertinoPageRoute(
          builder: (context) =>
              KeyMyVideosDetailScreen(videos: settings.arguments as MyVideos),
        );

      case Screens.profile:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SwitchProfileCubit(),
            child: const ProfileScreen(),
          ),
        );

      case Screens.notes:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => UserCubit(),
            child: NotesScreen(userId: settings.arguments as String),
          ),
        );

      case Screens.orientation:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSessionCubit(),
            child: OrientationSession(),
          ),
        );

      case Screens.schedule:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CalendarCubit(),
            child: ScheduleScreen(
              date: settings.arguments as String,
            ),
          ),
        );

      case Screens.changePassPassword:
        return CupertinoPageRoute(
          builder: (context) => const ChangePassPasswordScreen(),
        );

      case Screens.changePassEmail:
        return CupertinoPageRoute(
          builder: (context) => const ChangePassEmailScreen(),
        );

      case Screens.profileOneTimePassPasscode:
        return CupertinoPageRoute(
          builder: (context) =>
              ProfileOneTimePassPassword(email: settings.arguments as String),
        );

      case Screens.seeAll:
        return CupertinoPageRoute(
          builder: (context) => BrowseSeeAllScreen(
            healthCoach: settings.arguments as AllHealthCoachesModel,
          ),
        );

      case Screens.allseeAll:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => GetVideoCubit(),
            child: AllBrowseSeeAllScreen(
              healthCoach: settings.arguments as AllHealthCoachesModel,
            ),
          ),
        );

      case Screens.recommendedOffering:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => UserCubit(),
              child: RecommendedOfferingScreen(
                userId: settings.arguments as String,
              )),
        );

      case Screens.guseeAll:
        return CupertinoPageRoute(
          builder: (context) => GuBrowseSeeAllScreen(
            myVideos: settings.arguments as List<MyVideos>,
          ),
        );

      case Screens.reschedulesession:
        var arguments = settings.arguments as Map<String, dynamic>?;
        if (arguments != null) {
          String sessionId = arguments['sessionId'];
          String title = arguments['title'];
          String description = arguments['description'];
          String reason = arguments['reason'];

          // Use date and name in your screen
          return CupertinoPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AllSessionCubit(),
                ),
                BlocProvider(
                  create: (context) => TodayScheduleSessionCubit(),
                ),
              ],
              child: RescheduleSessionScreen(
                  description: description,
                  sessionId: sessionId,
                  title: title,
                  reason: reason),
            ),
          );
        } else {
          // Handle the case where arguments is null
          return null;
        }

      case Screens.localVideoPlayingScreen:
        return CupertinoPageRoute(
          builder: (context) => LocalVideoPlayingScreen(
            video: settings.arguments as File,
          ),
        );

      case Screens.reminderScreen:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => CalendarCubit(),
              child: const ReminderScreen()),
        );

      // Check if arguments is not null before accessing its values

      default:
        return null;
    }
  }

  /// Returns the current BuildContext at any point in the app
  static BuildContext get currentContext => navigatorKey.currentContext!;

  /// Implementation of Navigator.pushNamed() function
  static void goTo(String route, {Object? arguments}) {
    Navigator.pushNamed(currentContext, route, arguments: arguments);
  }

  /// Implementation of Navigator.pushReplacementNamed() function
  static void goToReplacement(String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(currentContext, route, arguments: arguments);
  }

  /// Implementation of Navigator.pushReplacementNamed() function
  static void closeAllAndGoTo(String route, {Object? arguments}) {
    Navigator.popUntil(currentContext, (route) => route.isFirst);
    Navigator.pushReplacementNamed(currentContext, route, arguments: arguments);
  }

  /// Implementation of Navigator.pop() function
  static void goBack() {
    Navigator.pop(currentContext);
  }
}
