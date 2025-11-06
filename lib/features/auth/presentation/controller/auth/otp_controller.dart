import 'dart:async';
import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../../../../core/routers/routes_name.dart';
import '../../../data/repository/auth_repository.dart';

class OtpController extends GetxController {
  final RxBool isLoading = false.obs;

  AuthRepository authRepository = AuthRepository();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isSignUp = false;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OTP
  late String otpCode;
  RxBool showResendButton = false.obs;
  final RxInt remainingTime = 120.obs;
  Timer? timer;

  // Starts the resend timer
  void startResendTimer() {
    remainingTime.value = 120;
    showResendButton.value = false;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime.value--;
        update();
      } else {
        showResendButton.value = true;
        timer.cancel();
        update();
      }
    });
  }

  // Stops the timer (used during cleanup)
  void stopTimer() {
    timer?.cancel();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OTP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> verifyOtp() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {"otp": otpCode};

      final response =
          isSignUp
              ? await authRepository.otp(body: body)
              : await authRepository.forgetPasswordOtp(body: body);

      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> Success isSignUp : $isSignUp");
        if (isSignUp) {
          log(">>>>>>>>>>>>>>> I Am In SignUp");
          if (PrefsHelper.myRole == "user") {
            log(">>>>>>>>>>>>>>> Role : ${PrefsHelper.myRole}");
            PrefsHelper.token = response.data['accessToken'];
            PrefsHelper.setString("token", PrefsHelper.token);
           if(!await Permission.location.isGranted){
             Get.to(
              LocationPermissionScreen(
                parentBusiness: null,
              ),
            );
            return;
           }
            Get.offAllNamed(RoutesName.nav);
            //          log(">>>>>>>>>>>>>>> Role : ${PrefsHelper.myRole}");
            // PrefsHelper.token = response.data['accessToken'];
            // PrefsHelper.setString("token", PrefsHelper.token);
            // Get.offAllNamed(RoutesName.nav);
          } else {
            log(">>>>>>>>>>>>>>> Role : ${PrefsHelper.myRole}");
            PrefsHelper.token = response.data['accessToken'];
            PrefsHelper.setString("token", PrefsHelper.token);
            Get.offAllNamed(RoutesName.signUpStep);
          }
        } else {
          log(">>>>>>>>>>>>>>> I Am Not In SignUp");
          Get.offAllNamed(RoutesName.createNewPassword);
        }
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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> new Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> newPassword() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "newPassword": passwordController.text,
        "confirmPassword": confirmPasswordController.text,
      };

      final response = await authRepository.newPassword(body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> Success isSignUp : $isSignUp");
        Get.offAllNamed(RoutesName.signIn);
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;

    Map<String, dynamic> body = {};

    try {
      final response = await authRepository.resendOtp(body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("OTP Resent Successfully: $response");
        Get.snackbar(
          "Success".tr,
          "OTP Resend resent.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        startResendTimer();
      } else {
        Get.snackbar(
          "Error",
          "Failed to resend OTP.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, s) {
      log("Resend OTP Failed e: $e");
      log("Resend OTP Failed s: $s");
      Get.snackbar(
        "Error",
        "Failed to resend OTP. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isSignUp = Get.arguments?['isSignUp'] ?? false;
    startResendTimer();
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
