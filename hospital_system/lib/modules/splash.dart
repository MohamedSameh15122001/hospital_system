import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hospital_system/main.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_home.dart';
import 'package:hospital_system/modules/login.dart';
import 'package:hospital_system/modules/manager_modules/manager_home.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_layout.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_notifications.dart';
import 'package:hospital_system/modules/patient_modules/patient_layout.dart';
import 'package:hospital_system/shared/another/push_notification_service.dart';
import 'package:hospital_system/shared/components/components.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';

import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key, required this.who}) : super(key: key);
  final String who;

  @override
  Widget build(BuildContext context) {
    PushNotificationsService.init(
      fcmTokenUpdate: (String fcm) {},
      onNavigateInApp: (type) {
        navigatorKey.currentState!.push(FadeRoute(const NurseNotifications()));
      },
      onMessageInApp: () {
        showToast(text: 'new notification', state: ToastStates.SUCCESS);
      },
    );
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Color.fromARGB(255, 68, 70, 84),
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );
    return SplashView(
      // logo: const FlutterLogo(),
      loadingIndicator: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SpinKitWave(
          color: mainColor,
          size: 40,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      bottomLoading: false,
      showStatusBar: true,
      title: Image.asset(
        'lib/assets/images/splash.png',
        width: mediaQuery(context).width * .8,
      ),

      // gradient: const LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: <Color>[Colors.green, Colors.blue]),
      done: Done(
        token == null || token!.isEmpty
            ? Login()
            : who == "manger"
                ? const MangerHome()
                : who == "doctor"
                    ? const DoctorHome()
                    : who == "nurse"
                        ? const NurseLayout()
                        : who == "patient"
                            ? const PatientLayout()
                            : Login(),
        animationDuration: const Duration(seconds: 2),
        // curve: Curves.easeInOut,
      ),
    );
  }
}
