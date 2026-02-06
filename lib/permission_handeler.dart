import 'dart:io';

import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  }
}

Future<bool> requestLocationPermission() async {
  if (Platform.isIOS) {
    LocationPermission permission;

    try {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      }

      return false;
    } catch (e) {
      print("Error requesting location permission: $e");
      return false;
    }
  } else {
    if (await Permission.location.isGranted) {
      return true;
    }
    var status = await Permission.locationAlways.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      Get.to(LocationPermissionScreen());
      return false;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }
    return false;
  }
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
  await Permission.location.request();
  await Permission.photos.request();
  await requestNotificationPermission();
}

Future<void> requestNotificationPermission() async {
  try {
    if (!(await Permission.notification.isGranted)) {
      await Permission.notification.request();
    }
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (e) {
    print('Notification permission error: $e');
  }
}
