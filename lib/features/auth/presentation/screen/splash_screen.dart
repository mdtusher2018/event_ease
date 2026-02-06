import 'dart:async';
import 'dart:io';

import 'package:event_ease/core/helper/helper.dart';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/video_loader.dart';
import 'package:event_ease/services/deep_link_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/routers/routes_name.dart';
import '../utils/app_icons.dart';

class SplashScreen0 extends StatefulWidget {
  const SplashScreen0({super.key});

  @override
  State<SplashScreen0> createState() => _SplashScreen0State();
}

class _SplashScreen0State extends State<SplashScreen0> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerView();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Initialize deep links after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DeepLinkService.init();
      DeepLinkService.consumePendingLink();
    });

    // Regular splash screen delay and navigation
    Timer(const Duration(seconds: 1), () async {
      final havepermission = (Platform.isIOS)?await Geolocator.isLocationServiceEnabled():(await Permission.location.isGranted);
      (PrefsHelper.isLogIn && PrefsHelper.token.isNotEmpty)
          ? havepermission
              ? decodeJwtField(PrefsHelper.token, 'phone').isNotEmpty
                  ? Get.offAllNamed(RoutesName.nav)
                  : Get.offAllNamed(RoutesName.onboarding)
              : Get.offAll(
                () => LocationPermissionScreen(
                  parentBusiness: PrefsHelper.parentBusinessId,
                ),
              )
          : Get.offAllNamed(RoutesName.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIcons.appLogo),
            // SizedBox(height: 60.h),
            // CustomLoadingBar(
            //   duration: Duration(seconds: 4),
            //   total: 18,
            //   nextRouteName: PrefsHelper.isLogIn && PrefsHelper.token.isNotEmpty
            //       ? RoutesName.nav
            //       : RoutesName.onboarding,
            // ),
          ],
        ),
      ),
    );
  }
}
