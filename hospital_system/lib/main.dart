import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/splash.dart';
import 'package:hospital_system/shared/another/cache_helper.dart';
import 'package:hospital_system/shared/another/push_notification_service.dart';
import 'package:hospital_system/shared/components/components.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/bloc_observer.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';
import 'package:hospital_system/shared/theme/light_theme.dart';

import 'modules/nurse_modules/nurse_notifications.dart';

// Create a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //===============================
  //firebase
  //===============================
  await Firebase.initializeApp();
  // final firebaseMessagingService = FirebaseMessagingService();
  // await firebaseMessagingService.initialize(navigatorKey);

  await PushNotificationServicesApp.init(
    fcmTokenUpdate: (fcm) {
      // check user is login
      // push to api
    },
    onNav: (type) {
      // go to notification screen
      navigatorKey.currentState!.push(FadeRoute(const NurseNotifications()));
    },
    onMessage: () {
      // let user to know new message
      showToast(text: 'new notification', state: ToastStates.SUCCESS);
    },
  );
  //===============================
  //firebase
  //===============================
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  token = CacheHelper.getData('token');
  String who = await CacheHelper.getData('who');
  runApp(MyApp(who: who));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.who});
  final String who;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade200,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ManagerCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorCubit(),
        ),
        BlocProvider(
          create: (context) => NurseCubit(),
        ),
        BlocProvider(
          create: (context) => PatientCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Hospital system',
        theme: lightTheme,

        // theme: ThemeData(
        //   scaffoldBackgroundColor: Colors.grey.shade200,
        //   primarySwatch: primaryColor,
        // ),
        home: SplashScreen(who: who), // SplashScreen(who: who)
      ),
    );
  }
}
