import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/helper/prefs_helper.dart';
// import '../../../../../core/routers/routes_name.dart';
import '../../../../../services/socket_service.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find<SignInController>();
  RxBool isRemember = false.obs;
  RxBool isLoading = false.obs;
  AuthRepository authRepository = AuthRepository();
  final TextEditingController emailController = TextEditingController(
    text:
        kDebugMode
            ? ((PrefsHelper.myRole == "user")
                ? "cagaka9569@kwifa.com"
                : "cicar23886@ishense.com")
            : "",
  );
  final TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );

  void toggleRememberMe() {
    isRemember.value = !isRemember.value;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Login User >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> loginUser() async {
    log(">>>>>>>>>>>>>>> Token ${PrefsHelper.token}");
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      final response = await authRepository.loginUser(body: body);
      if (response.statusCode == 200) {
        log("${PrefsHelper.myRole}................");

        if (response.data['user']['role'] != PrefsHelper.myRole) {
          Get.snackbar(
            "Access Denied",
            "You're trying to log in as a ${response.data['user']['role']}, but this portal is intended for ${PrefsHelper.myRole} access.",
          );
          return;
        }

        log(">>>>>>>>>>>>>>> Success 200");
        _handleSuccessfulLogin(response);
        // log(response.data['user']['parentBusiness']);
        PrefsHelper.setParentBusinessId(
          response.data['user']['parentBusiness'] ?? "",
        );
        PrefsHelper.address = response.data['user']['address'];
        PrefsHelper.setString("address", PrefsHelper.address);
        PrefsHelper.myRole = response.data['user']['role'];
        Get.offAllNamed(RoutesName.nav);

        // if (await Permission.location.isGranted &&
        //     await Permission.notification.isGranted) {
        //   // if (response.data['user']['role'] == "organizer" &&
        //   //     response.data['user']['parentBusiness'] == null) {
        //   //   Get.toNamed(RoutesName.signUpStep);
        //   // } else {
        //     Get.offAllNamed(RoutesName.nav);
        //   // }
        // } else if (await Permission.location.isGranted &&
        //     !await Permission.notification.isGranted) {
        //   Get.to(
        //     () => NotificationPermissionScreen(
        //       role: response.data['user']['role'],
        //       parentBusiness: response.data['user']['parentBusiness'],
        //     ),
        //   );
        // } else {
        //   Get.to(
        //     LocationPermissionScreen(
        //       parentBusiness: response.data['user']['parentBusiness'],
        //     ),
        //   );
        // }
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        log(">>>>>>>>>>>>>>> Error ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Google Login

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // user canceled

      var name = googleUser.displayName;
      var image = googleUser.photoUrl;
      var email = googleUser.email;
      var role = PrefsHelper.myRole;

      log(">>>>>>>>>> Name : $name");
      log(">>>>>>>>>> email : $email");
      log(">>>>>>>>>> image : $image");
      log(">>>>>>>>>> role : $role");

      var body = {
        "email": email,
        "name": name,
        "profileImage": image,
        "role": role,
      };

      final response = await authRepository.loginWithGoogle(body);
      if (response.statusCode == 200) {
        if (response.data['user']['role'] != PrefsHelper.myRole) {
          Get.snackbar(
            "Access Denied",
            "You're trying to log in as a ${response.data['user']['role']}, but this portal is intended for ${PrefsHelper.myRole} access.",
          );
          return;
        }

        _handleSuccessfulLogin(response);
        Get.to(
          LocationPermissionScreen(
            parentBusiness: response.data['user']['parentBusiness'],
          ),
        );
      } else {
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Google Sign-In Error: $e");
      log("StackTrace: $s");
      Get.snackbar("Google Sign-In Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _handleSuccessfulLogin(dynamic response) {
    SocketServices.connectToSocket(token: response.data['accessToken']);

    PrefsHelper.userId = response.data['user']['_id'];
    PrefsHelper.token = response.data['accessToken'];
    PrefsHelper.myName = response.data['user']['name'];
    PrefsHelper.myRole = response.data['user']['role'];
    PrefsHelper.myImage = "${response.data['user']['profileImage']}";

    if (isRemember.value) {
      PrefsHelper.setString("userId", PrefsHelper.userId);
      PrefsHelper.setString("token", PrefsHelper.token);
      PrefsHelper.setString("myName", PrefsHelper.myName);
      PrefsHelper.setString("myRole", PrefsHelper.myRole);
      PrefsHelper.setString("myImage", PrefsHelper.myImage);
      PrefsHelper.setBool("isLogIn", isRemember.value);
    }
  }
}
