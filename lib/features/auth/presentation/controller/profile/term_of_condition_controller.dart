import 'dart:convert';

import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermOfConditionController extends GetxController {
  RxString termCondition = "".obs;
  //============================================================get policy ,terms of services, suport, about us
  RxBool isLoading = false.obs;
  AuthRepository authRepository = AuthRepository();

  getTermOfCondition({String? status}) async {
    isLoading.value = true;
    try {
      var response = await authRepository.getTermsCondition();

      var termsData = response is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        if (termsData != null) {
          isLoading.value = false;
          termCondition.value = termsData["content"] ?? "";
        }
      } else {
        Get.snackbar("Error".tr,"Terms of Condition not found");
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
    getTermOfCondition();
  }
}
