import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HelpCenterController extends GetxController{

  AuthRepository authRepository = AuthRepository();
  RxBool isLoading = false.obs;
  RxList faqList = [].obs;

  TextEditingController issueController = TextEditingController();
  TextEditingController describeController = TextEditingController();

  UserRepository userRepository = UserRepository();

  Future<void>getFaq()async{
    isLoading.value = true;
    try {
      final response = await authRepository.getFAQ();
      if (response.statusCode == 200|| response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success ");
        faqList.value = response.data['faqs'];
      } else {
        log(">>>>>>>>>>>>>>> Error ");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }

  }

  Future<void> postTicket() async {
    isLoading.value = true;
    try {
      var body={
        "typeOfIssue": issueController.text,
        "description": describeController.text
      };
      final response = await userRepository.postTicket(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Successful".tr, response.message);
      } else {
        log("Error: \${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Exception: $e\nStackTrace: $s");
      Get.snackbar("Exception".tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFaq();
  }


}