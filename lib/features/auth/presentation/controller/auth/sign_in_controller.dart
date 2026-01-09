import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/profile/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/edit_profile_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
                ? "yepesej669@cameltok.com"
                : "cicar23886@ishense.com")
            : "",
  );
  final TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? "hello123" : "",
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

  Future<void> loginWithGoogle(BuildContext context) async {
    isLoading.value = true;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar("Failed", "Google Sign-In Failed");
        return;
      }

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
          await googleSignIn.signOut();
          Get.snackbar(
            "Access Denied",
            "You're trying to log in as a ${response.data['user']['role']}, but this portal is intended for ${PrefsHelper.myRole} access.",
          );
          return;
        }

        _handleSuccessfulLogin(response);
        if (response.success) {
          if ((response.data["user"]?["phone"] as String).isEmpty) {
            showEditProfileInputDialog(context: context);
            return;
          }
        }
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

  Future<void> loginWithApple() async {
    isLoading.value = true;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.your.bundle.id.service", // Apple Service ID
          redirectUri: Uri.parse(
            "https://yourdomain.com/callbacks/sign_in_with_apple",
          ),
        ),
      );

      var name = "${credential.givenName ?? ''} ${credential.familyName ?? ''}";
      var email = credential.email;
      var role = PrefsHelper.myRole;

      log(">>>>>>>>>> Name : $name");
      log(">>>>>>>>>> email : $email");
      log(">>>>>>>>>> role : $role");

      var body = {
        "identityToken": credential.identityToken,
        "authorizationCode": credential.authorizationCode,
        "email": credential.email,
        "name": name,
        "role": role,
      };

      final response = await authRepository.loginWithGoogle(
        body,
      ); // Changed to loginWithApple

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
      log("Apple Sign-In Error: $e");
      log("StackTrace: $s");
      Get.snackbar("Apple Sign-In Failed", e.toString());
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

void showEditProfileInputDialog({required BuildContext context}) {
  EditController controller = Get.put(EditController());
  Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                "Update Personal Details",
                style: styleForBoldText.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),

              /// Date of Birth
              Text(
                "Date of Birth",
                style: styleForNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.selectedDate.value ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.selectedDate.value = date;
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      controller.selectedDate.value != null
                          ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(controller.selectedDate.value!)
                          : "Select date of birth",
                      style: styleForNormalText.copyWith(color: AppColors.grey),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Gender
              Text(
                "Gender",
                style: styleForNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select gender"),
                      value:
                          controller.selectedGender.value.isNotEmpty
                              ? controller.selectedGender.value
                              : null,
                      items:
                          controller.genderItem.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedGender.value = value;
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Phone Number
              Text(
                "Phone Number",
                style: styleForNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              CustomPhoneField(controller: controller.phoneController),

              const SizedBox(height: 24),

              /// Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : () {
                                  /// VALIDATION
                                  if (controller.selectedDate.value == null) {
                                    Get.snackbar(
                                      "Validation Error",
                                      "Please select your date of birth",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (controller.phoneController.text
                                      .trim()
                                      .isEmpty) {
                                    Get.snackbar(
                                      "Validation Error",
                                      "Please enter your phone number",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  Get.back();
                                  controller.editProfile(); // SAME API CALL
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            controller.isLoading.value
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
