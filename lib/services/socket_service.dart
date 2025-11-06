import 'dart:developer';

import 'package:event_ease/features/auth/presentation/controller/notification/notification_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../core/helper/prefs_helper.dart';

class SocketServices {
  static late io.Socket socket;
  bool show = false;

  ///<<<============ Connect with socket ====================>>>
  static void connectToSocket({String token = ""}) {
    log("Socket Initialized");
    socket = io.io(
      AppUrl.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({
            'token': token.isNotEmpty ? token : PrefsHelper.token,
          })
          .setQuery({'token': token})
          .enableAutoConnect()
          .build(),
    );

    print("Token socket========${PrefsHelper.token}");

    socket.onConnect((data) {
      notificationSocketMethod();  // ✅ can call now
      log("=============================> Connection $data");
    });

    socket.onConnectError((data) {
      if (kDebugMode) {
        print("============================>Connection Error $data");
      }
    });

    socket.connect();
  }

  ///<<<============ Notification handler ====================>>>
  static Future<void> notificationSocketMethod() async {
    socket.off("notification::${PrefsHelper.userId}");
    socket.on("notification::${PrefsHelper.userId}", (data) {
      log("notification Response: $data");
      if (data != null) {
        final NotificationController notificationController =
            Get.find<NotificationController>();
        notificationController.homePageNotification.value = true;
      }

      if (kDebugMode) {
        print("================> get Data on socket: $data");
      }
      // NotificationService.showNotification(data);
    });
  }
}
