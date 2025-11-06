import 'dart:developer';
import 'package:event_ease/features/auth/presentation/controller/notification/notification_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  //============================================================== show local notification
  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
          icon: "icon",
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '🔔 New Notification',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  //============================================================== initialize notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('icon');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("message==================${message.data}");
      log(
        "🔔 Foreground Notification Received: ${message.notification?.title}",
      );
      final NotificationController notificationController =
          Get.find<NotificationController>();
      String title = message.notification?.title ?? "";
      if (!title.contains("sent you a new message")) {
        notificationController.homePageNotification.value = true;
      }

      log(notificationController.homePageNotification.value.toString());

      if (title.contains("sent you a new message")) {
        NavScreen.haveUnreadMassage.value = true;
      }

      _showLocalNotification(message);
    });

    // When tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("message==================${message.data}");
      log("🟢 App Opened From Notification: ${message.notification?.title}");
      _showLocalNotification(message);
    });
  }
}
