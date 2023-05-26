import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_layout.dart';
import 'package:hospital_system/modules/login.dart';
import 'package:hospital_system/modules/manager_modules/manager_home.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_layout.dart';
import 'package:hospital_system/modules/patient_modules/patient_layout.dart';
import 'package:hospital_system/shared/another/cache_helper.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/bloc_observer.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await CacheHelper.saveData(
      key: 'token',
      value:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI2NDZmZjgyNWZhZGU5ZGRiODQ4MWIxZDkiLCJuYW1lIjoiTW9oYW1lZCBOYXNzZXIiLCJyb2xlIjoibWFuZ2VyIiwiaWF0IjoxNjg1MDU5NzI2fQ.A_1BKkdHkEwJehZmheKbEIjzke3dencdr07Pu4ZyEu8');
  token = CacheHelper.getData('token');
  await CacheHelper.saveData(key: 'who', value: 'Manger');
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
        debugShowCheckedModeBanner: false,
        title: 'Hospital system',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade200,
          primarySwatch: primaryColor,
        ),
        home: token == null
            ? Login()
            : who == "Manger"
                ? const MangerHome()
                : who == "Doctor"
                    ? const DoctorLayout()
                    : who == "Nurse"
                        ? const NurseLayout()
                        : who == "Patient"
                            ? const PatientLayout()
                            : Login(),
      ),
    );
  }
}
