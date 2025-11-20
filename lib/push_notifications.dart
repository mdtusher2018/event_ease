import 'dart:developer';
import 'package:event_ease/features/auth/presentation/controller/notification/notification_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  NotificationService();

  // ========================================================== Show Local Notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
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

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _localNotifications.show(
      0,
      message.notification?.title ?? '🔔 New Notification',
      message.notification?.body ?? '',
      details,
    );
  }

  // ========================================================== Initialize Notifications
  Future<void> initialize() async {
    // ------------------ 1️⃣ Local notification setup
    const androidInit = AndroidInitializationSettings('icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(initSettings);

    // ------------------ 2️⃣ Request notification permissions (iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ Notification permission granted');

      // Wait briefly to ensure iOS registers APNs in background
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 1));
      }

      // ------------------ 3️⃣ Get FCM token
      try {
        final token = await _messaging.getToken();
        debugPrint('📱 FCM Token: $token');
      } catch (e) {
        debugPrint('⚠️ Could not get FCM token: $e');
      }
    } else {
      debugPrint('🚫 Notification permission not granted');
    }

    // ------------------ 4️⃣ Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("message data: ${message.data}");
      log("🔔 Foreground Notification: ${message.notification?.title}");

      final notificationController = Get.find<NotificationController>();
      final title = message.notification?.title ?? "";

      if (!title.contains("sent you a new message")) {
        notificationController.homePageNotification.value = true;
      }

      if (title.contains("sent you a new message")) {
        NavScreen.haveUnreadMassage.value = true;
      }

      _showLocalNotification(message);
    });

    // ------------------ 5️⃣ When user taps a notification (while app is backgrounded)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🟢 Notification opened: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // ------------------ 6️⃣ (Optional) Handle background messages if app is terminated
    // Define top-level function in main.dart:
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

