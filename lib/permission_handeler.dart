import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestGalleryPermission() async {
  if (await Permission.phone.isGranted) {
    return;
  }

  var status = await Permission.photos.request();

  if (status.isGranted) {
    return;
  }

  if (status.isDenied) {
    Get.snackbar(
      "Permission Required",
      "Gallery access is required to use this app.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    // Close app if denied
    Future.delayed(const Duration(seconds: 2), () async {
      await Permission.photos.request();
    });
  }

  if (status.isPermanentlyDenied) {
    Get.snackbar(
      "Permission Required",
      "Please enable gallery permission in settings.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
    // await openAppSettings();
    // Future.delayed(const Duration(seconds: 2), () {
    //   SystemNavigator.pop();
    // });
  }
}

Future<bool> requestLocationPermission() async {
  if (await Permission.location.isGranted) {
    return true;
  }
  var status = await Permission.locationAlways.request();

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    Get.snackbar(
      "Permission Required",
      "Location access is required to use this app.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    Get.to(LocationPermissionScreen());
    // Close app if denied
    // Future.delayed(const Duration(seconds: 2), () {
    //   SystemNavigator.pop();
    // });
    return false;
  }

  if (status.isPermanentlyDenied) {
    Get.snackbar(
      "Permission Required",
      "Please enable Location permission in settings.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
    // await openAppSettings();
    // Future.delayed(const Duration(seconds: 2), () {
    //   SystemNavigator.pop();
    // });
    return false;
  }
  return false;
}

Future<bool> requestNotificationsPermission() async {
  if (await Permission.notification.isGranted) {
    return true;
  }
  var status = await Permission.notification.request();

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    Get.snackbar(
      "Permission Required",
      "Notification access is required to use this app.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    return false;
  }

  if (status.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }
  return false;
}

/// Call this before `runApp()` to ensure all required permissions are requested
Future<void> requestAppPermissions() async {
  await Permission.locationAlways.request();
  await Permission.photos.request();
  await requestNotificationPermission();
}

Future<void> requestNotificationPermission() async {
  await Permission.notification.request();
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (e) {
    print('Notification permission error: $e');
  }
}
