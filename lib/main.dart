import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/logic/provider/home_bottom_provider.dart';
import 'package:zanadu_coach/feature/login/logic/login_cubit/login_cubit.dart';
import 'package:zanadu_coach/feature/profile/logic/provider/edit_profile_provider.dart';
import 'package:zanadu_coach/feature/session/logic/cubit/feedback_cubit/feedback_cubit.dart';
import 'package:zanadu_coach/feature/session/logic/provider/session_provider.dart';
import 'package:zanadu_coach/feature/signup/logic/provider/signup_provider.dart';
import 'package:zanadu_coach/feature/video_calling/logic/chat_provider.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      
        options: const FirebaseOptions(
      iosBundleId: "com.zanaduhealth.coach",
      storageBucket: "zh-coach-staging.appspot.com",
      apiKey: "AIzaSyD-QdnAL-jlp18nzuGpnZzn1ROdUmrcf6U",
      appId: "1:847098207975:ios:a861ac5ff25aa3a03b8c42",
      messagingSenderId: "847098207975",
      projectId: "zh-coach-staging",
    ));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCPAJTKyuRogtBC_W01Wv30MWxhnKXrzfU",
            appId: "1:847098207975:android:64cb7e17abdc26ee3b8c42",
            messagingSenderId: "847098207975",
            projectId: "zh-coach-staging"));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  print("Initializing Firebase...");
  try {
    if (Platform.isIOS) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
        authDomain: "app.zanaduhealth.com",
        iosBundleId: "com.zanaduhealth.coach",
        storageBucket: "zh-coach-staging.appspot.com",
        apiKey: "AIzaSyD-QdnAL-jlp18nzuGpnZzn1ROdUmrcf6U",
        appId: "1:847098207975:ios:a861ac5ff25aa3a03b8c42",
        messagingSenderId: "847098207975",
        projectId: "zh-coach-staging",
      ));
    } else {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCPAJTKyuRogtBC_W01Wv30MWxhnKXrzfU",
              appId: "1:847098207975:android:64cb7e17abdc26ee3b8c42",
              messagingSenderId: "847098207975",
              projectId: "zh-coach-staging"));
    }
  } catch (e) {
    print(e);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => FeedBackCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SignUpProvider>(
            create: (context) => SignUpProvider(context),
          ),
          ChangeNotifierProvider<EditProfileProvider>(
            create: (context) => EditProfileProvider(context),
          ),
          ChangeNotifierProvider<TabIndexProvider>(
            create: (context) => TabIndexProvider(),
          ),
          ChangeNotifierProvider<SessionProvider>(
            create: (context) => SessionProvider(),
          ),
          ChangeNotifierProvider<GroupChatProvider>(
            create: (context) => GroupChatProvider(),
          ),
        ],
        child: ScreenUtilInit(
          builder: (context, child) => Builder(
            builder: (context) => MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: Themes.defaultTheme,
                navigatorKey: Routes.navigatorKey,
                onGenerateRoute: Routes.onGenerateRoute,
                initialRoute: Screens.splash),
          ),
          designSize: const Size(430, 932),
        ),
      ),
    );
  }
}
