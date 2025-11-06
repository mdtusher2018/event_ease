// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/helper/other_helper.dart';
import '../../../../../core/routers/routes_name.dart';

class SignUpController extends GetxController {
  final RxBool isLoading = false.obs;

  AuthRepository authRepository = AuthRepository();

  bool isSignUp = false;
  final RxBool isAgree = false.obs;
  final RxBool isCode = false.obs;
  final RxString selectedGender = "".obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController sureNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  var genderItem = ["male", "female", "others"];

  void toggleRememberMe() {
    isAgree.value = !isAgree.value;
  }

  Future<void> selectDate(BuildContext context) async {
    final date = await OtherHelper.selectDate(context, selectedDate.value);
    selectedDate.value = date;
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  RxString privacyPolicySignUp = "".obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create User >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> createUser() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "sureName": firstNameController.text,
        "lastName": sureNameController.text,
        // "sureName": sureNameController.text,
        "name": userNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
        "dateOfBirth": selectedDate.value.toString(),
        "gender": selectedGender.value,
        "role": PrefsHelper.myRole,
        "termsAndConditions": isAgree.value,
        "customId": referralController.text
      };

      final response = await authRepository.createUser(body: body);
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        PrefsHelper.token = response.data;
        PrefsHelper.setString("token", PrefsHelper.token);
        Get.offAllNamed(RoutesName.otp, arguments: {'isSignUp': true});
      } else {
        Get.snackbar("Error".tr,response.message);
        log(">>>>>>>>>>>>>>> Error 200");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
      Get.snackbar("Error".tr,"$e $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void>getPrivacyPolicySignUp()async{
    isLoading.value = true;
    try {
      var response = PrefsHelper.myRole=="user"? await authRepository.getPrivacyPolicySignUpUser(): await authRepository.getPrivacyPolicySignUpBusiness();

      var policyData = response is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (policyData != null) {
          isLoading.value = false;
          privacyPolicySignUp.value = policyData["content"] ?? "";
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

  // Future<void> loginWithGoogle() async {
  //   isLoading.value = true;
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) return; // user canceled
  //
  //     var name = googleUser.displayName;
  //     var image = googleUser.photoUrl;
  //     var email = googleUser.email;
  //     var role = PrefsHelper.myRole;
  //
  //     log(">>>>>>>>>> Name : $name");
  //     log(">>>>>>>>>> email : $email");
  //     log(">>>>>>>>>> image : $image");
  //     log(">>>>>>>>>> role : $role");
  //
  //     var body = {
  //       "email": email,
  //       "name": name ,
  //       "profileImage": image,
  //       "role": role,
  //     };
  //
  //     final response = await authRepository.loginWithGoogle(body);
  //     if (response.statusCode == 200) {
  //       if (response.data['user']['role'] != PrefsHelper.myRole) {
  //         Get.snackbar(
  //           "Access Denied",
  //           "You're trying to log in as a ${response.data['user']['role']}, but this portal is intended for ${PrefsHelper.myRole} access.",
  //         );
  //         return;
  //       }
  //
  //       _handleSuccessfulLogin(response);
  //        Get.to(
  //         LocationPermissionScreen(
  //
  //           parentBusiness: response.data['user']['parentBusiness'],
  //         ),
  //       );
  //     } else {
  //       Get.snackbar("Error".tr,response.message);
  //     }
  //   } catch (e, s) {
  //     log("Google Sign-In Error: $e");
  //     log("StackTrace: $s");
  //     Get.snackbar("Google Sign-In Failed", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  void _handleSuccessfulLogin(dynamic response) {
    SocketServices.connectToSocket(token: response.data['accessToken']);

    PrefsHelper.userId = response.data['user']['_id'];
    PrefsHelper.token = response.data['accessToken'];
    PrefsHelper.myName = response.data['user']['name'];
    PrefsHelper.myRole = response.data['user']['role'];
    PrefsHelper.myImage = "${response.data['user']['profileImage']}";

    PrefsHelper.setString("userId", PrefsHelper.userId);
    PrefsHelper.setString("token", PrefsHelper.token);
    PrefsHelper.setString("myName", PrefsHelper.myName);
    PrefsHelper.setString("myRole", PrefsHelper.myRole);
    PrefsHelper.setString("myImage", PrefsHelper.myImage);

    
  }
}
