import 'dart:developer';
import 'dart:math' as math;

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationServicesApp {
  // ignore: unused_field
  final String _ = '';
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static bool isInit = false;
  static late Function(String? type) onNavigate;

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHelper(RemoteMessage message) async {
    log(
      message.notification!.title.toString(),
      name: ' onBackgroundMessageHelper ',
    );

    final android = message.notification?.android;
    if (android != null) {
      // await showNotification(
      //   payload: 'Ahmed',
      //   title: message.notification!.title!,
      //   body: message.notification!.body!,
      // );
      // await flutterLocalNotificationsPlugin.show(
      //   0,
      //   android.title!,
      //   android.body!,
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       'channel_id',
      //       'channel_name',
      //       'channel_description',
      //     ),
      //   ),
      // );
    }
  }

  static Future<void> setupInteractMessage() async {
    final initMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initMessage != null) {
      // await NavigationService.navigateTo(RouteNames.notifications);
      //  if navigating with another type of notifications
      // final type = initMessage.data['type'] as String?;
      // onNavigate(type);
      onNavigate(null);
    }
  }

  static Future<void> requestPermissions() async {
    final settings = await messaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user given Permission', name: ' NavigationServices ');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      await AppSettings.openNotificationSettings();
    }
  }

  static Future<String> getDeviceToken() async {
    return (await messaging.getToken())!;
  }

  static Future<void> init({
    required Function(String) fcmTokenUpdate,
    required Function(String? type) onNav,
    required Function() onMessage,
  }) async {
    if (isInit) return;
    isInit = true;
    await requestPermissions();
    final token = await getDeviceToken();
    onNavigate = onNav;

    fcmTokenUpdate(token);
    log(token, name: ' FCM ');
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((event) async {
      log(event.notification!.title.toString(), name: ' onMessage ');
      onMessage();
      Future.delayed(
        Duration.zero,
        () async {
          final not = event.notification!;
          await showNotification(
            title: not.title!,
            body: not.body!,
            payload: 'Ahmed',
          );
        },
      );
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHelper);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      math.Random().nextInt(1000).toString(),
      'High Importance Notification',
      // channelDescription: 'channel_description',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'ticker',
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        // if (context != null) {
        try {
          onNavigate(null);
        } catch (e) {
          log(e.toString());
        }
        // }
      },
    );

    await FlutterLocalNotificationsPlugin().show(
      math.Random().nextInt(1000),
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }
}

// await Firebase.initializeApp();
//   FirebaseMessaging.instance.getToken().then((value) {
//     if (kDebugMode) {
//       print(value);
//       print('==================================');
//     }
//   });
//   //if app in background
//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//     if (kDebugMode) {
//       print(event);
//       print('==========');
//     }
//   });
//   //if app closed or teminated
//   FirebaseMessaging.instance.getInitialMessage().then((value) {
//     if (value != null) {}
//   });
//   FirebaseMessaging.onBackgroundMessage((message) async {
//     await Firebase.initializeApp();
//     if (kDebugMode) {
//       print(message);
//     }
//   });
//===================================================
//===================================================
//===================================================
//===================================================
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:hospital_system/modules/nurse_modules/nurse_notifications.dart';
// import 'package:hospital_system/shared/components/components.dart';

// import '../components/constants.dart';

// class FirebaseMessagingService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
//     // Request permission for notifications (optional)
//     await _firebaseMessaging.requestPermission(
//       sound: true,
//       badge: true,
//       alert: true,
//       announcement: false,
//     );

//     // Configure the onMessage, onBackgroundMessage, and onResume callbacks
//     FirebaseMessaging.onMessage.listen(_onMessage);
//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//       await _onBackgroundMessage(message, navigatorKey);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       await _onMessageOpenedApp(message, navigatorKey);
//     });
//     // Handle the initial notification if the app is launched from a terminated state
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       await _handleInitialMessage(initialMessage, navigatorKey);
//     }
//   }

//   Future<void> _onMessage(RemoteMessage message) async {
//     // Handle foreground messages here
//     showToast(text: 'new notification', state: ToastStates.SUCCESS);
//   }

//   Future<void> _onBackgroundMessage(
//       RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
//     // Handle background messages here
//     await navigatorKey.currentState!
//         .push(FadeRoute(const NurseNotifications()));
//   }

//   Future<void> _onMessageOpenedApp(
//       RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
//     // Handle notification when the app is in the background and opened from the notification
//     await navigatorKey.currentState!
//         .push(FadeRoute(const NurseNotifications()));
//   }

//   Future<void> _handleInitialMessage(
//       RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
//     // Handle the initial notification when the app is launched from a terminated state
//     await navigatorKey.currentState!
//         .push(FadeRoute(const NurseNotifications()));
//   }
// }
