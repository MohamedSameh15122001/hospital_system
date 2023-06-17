import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Add this section to manifest
// <meta-data
// android:name="com.google.firebase.messaging.default_notification_channel_id"
// android:value="high_importance_channel" />

/// and run
/// flutter pub add flutter_local_notifications notification_permissions firebase_messaging
class PushNotificationsService {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static String? fcmToken;
  static late Function(String? notificationType) onNavigate;
  static late Function() onMessage;

  static Future init({
    required Function(String fcm) fcmTokenUpdate,
    required Function(String? type) onNavigateInApp,
    required Function() onMessageInApp,
  }) async {
    //platform init  // android icon init  //ios init for FLN
    try {
      onNavigate = onNavigateInApp;
      onMessage = onMessageInApp;
      await initNotificationChannelsAndonBackgroundMessage();

      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveBackgroundNotificationResponse:
            onReceiveNotificationResponse,
        onDidReceiveNotificationResponse: onReceiveNotificationResponse,
      );
    } catch (e) {
      log(e.toString());
    }
    await flutterLocalNotificationsPlugin.cancelAll();
    //setup firebase notification
    fcmTokenUpdate(await setupNotifications());
    log('Notification Intiated ...');
  }

  static void onReceiveNotificationResponse(NotificationResponse details) =>
      onSelectNotification(details.payload);

  static Future setupNotifications() async {
    await NotificationPermissions.requestNotificationPermissions();
    final settings = await _firebaseMessaging.requestPermission();
    log('User granted permission: ${settings.authorizationStatus}');
    if (!(await FirebaseMessaging.instance.isSupported())) return;
    if (kDebugMode) await _firebaseMessaging.subscribeToTopic('test');
    fcmToken = await _firebaseMessaging.getToken();
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then(onNotificationAction);
    FirebaseMessaging.onMessage.listen(firebaseInAppNotificationHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationAction);
    return fcmToken;
  }

//<editor-fold desc="------------Handling Functions">
  static Future<void> onNotificationAction(RemoteMessage? event) async {
    if (event != null) {
      await onSelectNotification(event.data['actionID'] as String?);
    }
  }

  static Future firebaseInAppNotificationHandler(RemoteMessage event) async {
    log('firebaseInAppNotificationHandler', name: ' Notification ');
    onMessage();
    final notification = event.notification;
    if (notification?.android != null) {
      await showNotification(
        id: 0,
        title: notification!.title,
        body: notification.body,
        payload: event.data['type'].toString(),
      );
    }
  }

  static Future<void> firebaseMessagingNotificationHandler(
    RemoteMessage event,
  ) async {
    final notification = event.notification;
    if (notification?.android != null) {
      await showNotification(
        id: notification.hashCode,
        title: notification!.title,
        body: notification.body,
        payload: event.data['type'].toString(),
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
  }) =>
      flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: getAndroidNotificationDetails(),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );

  static AndroidNotificationDetails getAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: 'lib/assets/images/hospital.png',
      priority: Priority.high,
      importance: Importance.max,
    );
  }

  static Future onSelectNotification(String? payload) async {
    log('onSelectNotification', name: ' Notification ');
    onNavigate(null);
    // final navigationService = gt<NavigationService>();
    // if (payload == null) {
    //   await navigationService.openApp();
    // } else if (payload == 'chat') {
    //   log('hi$payload');
    //   await navigationService.navigateTo(
    //     RouteNames.bottomNavBar,
    //     BottomNavCubit.chatTabIndex,
    //   );
    // }
  }

//</editor-fold>
}

Future<void> initNotificationChannelsAndonBackgroundMessage() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(
    PushNotificationsService.firebaseMessagingNotificationHandler,
  );
}
