import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../core/routers/routes_name.dart';
import '../../../data/repository/auth_repository.dart';

class ChangePasswordController extends GetxController{

  final RxBool isLoading = false.obs;

  AuthRepository authRepository = AuthRepository();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Change Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> changePassword() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "oldPassword": oldPasswordController.text,
        "newPassword": newPasswordController.text
      };

      final response =  await authRepository.changePassword(body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
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

}