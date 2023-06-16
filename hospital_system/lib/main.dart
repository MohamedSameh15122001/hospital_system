import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/splash.dart';
import 'package:hospital_system/shared/another/cache_helper.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/bloc_observer.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';

// Create a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  token = CacheHelper.getData('token');
  String who = await CacheHelper.getData('who') ?? 'manger';
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
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade200,
          primarySwatch: primaryColor,
        ),
        home: SplashScreen(who: who),
      ),
    );
  }
}
