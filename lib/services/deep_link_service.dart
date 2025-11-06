import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:event_ease/core/helper/prefs_helper.dart' show PrefsHelper;
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkService {
  static Uri? pendingLink;

  static Future<void> init() async {
    final appLinks = AppLinks();

    // Handle initial deep link (app cold start)
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        log("🚀 Initial link: $initialUri");
        pendingLink = initialUri;
        _handleRuntimeLink(initialUri);
      }
    } catch (err) {
      log("❌ Failed to get initial link: $err");
    }

    // Handle links while app is running
    appLinks.uriLinkStream.listen(
      (uri) {
        log("🔗 Incoming link: $uri");
        _handleRuntimeLink(uri);
      },
      onError: (err) {
        log("❌ Deep link error: $err");
      },
    );
  }

  static void _handleRuntimeLink(Uri uri) {
    pendingLink = uri; // store it
    _openIfLoggedIn(uri); // navigate immediately if running
  }

  static void _openIfLoggedIn(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length >= 3 && segments[0] == "share") {
      final type = segments[1];
      final id = segments[2];

      if (PrefsHelper.token.isEmpty) {
        // ✅ Delay navigation to avoid "GlobalKey reused" error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(RoutesName.signIn);
        });
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (type == "business") {
          Get.toNamed(RoutesName.businessDetail, arguments: id);
        } else if (type == "event") {
          Get.toNamed(RoutesName.eventDetailScreen, arguments: id);
        } else if (type == "job") {
          Get.toNamed(RoutesName.jobDetailScreen, arguments: id);
        }
      });
    }
  }

  /// Called later from Splash/Root
  static void consumePendingLink() {
    if (pendingLink != null) {
      _openIfLoggedIn(pendingLink!);
      pendingLink = null; // clear after use
    }
  }
}
