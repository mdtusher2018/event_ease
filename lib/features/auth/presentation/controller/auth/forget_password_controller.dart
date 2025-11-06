import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../../../../core/routers/routes_name.dart';

class ForgetPasswordController extends GetxController{

  RxBool isLoading = false.obs;
  AuthRepository authRepository = AuthRepository();
  TextEditingController emailController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Forget Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> forgetPassword() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "email": emailController.text,
      };

      final response = await authRepository.forgetPassword(body: body);
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> Success got OTP");
        PrefsHelper.token = response.data['forgetToken'];
        PrefsHelper.setString("token", PrefsHelper.token);
        Get.offNamed(RoutesName.otp);
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

}