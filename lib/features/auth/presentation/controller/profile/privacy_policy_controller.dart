import 'dart:convert';

import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  RxString privacyPolicy = "".obs;
  //============================================================get policy ,terms of services, suport, about us
  RxBool isLoading = false.obs;
  AuthRepository authRepository = AuthRepository();

  getPolicy({String? status}) async {
    isLoading.value = true;
    try {
      var response = await authRepository.getPrivacyPolicy();

      var policyData = response is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        if (policyData != null) {
          isLoading.value = false;
          privacyPolicy.value = policyData["content"] ?? "";
        }
      } else {
        Get.snackbar("Error".tr,"Privacy policy not found");
      }
    } catch (e, s) {
      debugPrint("Error====$e");
      debugPrint("Error====$s");
    } finally {
      isLoading.value = false;
    }
  }



  @override
  void onInit() {
    super.onInit();
    getPolicy();
  }
}
