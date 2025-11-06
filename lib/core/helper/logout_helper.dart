import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutHelper {

  static Future<void> logoutUser({bool confirm = true, required String routeName}) async {
    if (confirm) {
      bool shouldLogout = await _showLogoutConfirmationDialog();
      if (!shouldLogout) return;
    }

    await GoogleSignIn().signOut();
    log("logout.................................");
    Get.back(result:  true);
    await PrefsHelper.removeAllPrefData();

    log(">>>>>>>>>>>>>>> Log out ============================");
    log(">>>>>>>>>>>>>>> Token: ${PrefsHelper.token}");
    // Navigate after cleanup
    await Get.offAllNamed(routeName);
  }

  static Future<bool> _showLogoutConfirmationDialog() async {
    return await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Logout".tr, style: styleForBoldText.copyWith(fontSize: 18, color: Colors.black),),
        content: Text("Are you sure you want to logout?".tr,style: styleForNormalText.copyWith(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel".tr, style: styleForNormalText.copyWith(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400))
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text("Logout".tr, style: styleForNormalText.copyWith(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    ) ??
        false;
  }
}
