import 'dart:developer';
import 'dart:io';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/profile/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/auth/location_permission_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/edit_profile_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
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
    text: kDebugMode
        ? ((PrefsHelper.myRole == "user")
              ? "raseldev847@gmail.com"
              : "rasel.chowdhury0001@gmail.com")
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
        final havepermission = await Geolocator.isLocationServiceEnabled();
        log("havepermission : $havepermission");
        if (havepermission) {
          Get.offAllNamed(RoutesName.nav);
        } else {
          Get.offAll(
            () => LocationPermissionScreen(
              parentBusiness: PrefsHelper.parentBusinessId,
            ),
          );
        }
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
        isRemember.value = true;
        _handleSuccessfulLogin(response);

        PrefsHelper.setParentBusinessId(
          response.data['user']['parentBusiness'] ?? "",
        );




        if (response.success) {
          if ((response.data["user"]?["phone"] as String).isEmpty) {
            showEditProfileInputDialog(
              context: context,
              name: name,
              email: email,
            );
            return;
          }
        }
        Get.to(
          LocationPermissionScreen(
            parentBusiness: response.data['user']['parentBusiness'],
          ),
        );
      } else {
        await googleSignIn.signOut();
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Google Sign-In Error: $e");
      log("StackTrace: $s");
      await googleSignIn.signOut();
      Get.snackbar("Google Sign-In Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple(BuildContext context) async {
    isLoading.value = true;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final name =
          "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();
      final email =
          (credential.email != null &&
              !credential.email!.endsWith('@privaterelay.appleid.com'))
          ? credential.email
          : "";
      final role = PrefsHelper.myRole;

      log(">>>>>>>>>> Name : $name");
      log(">>>>>>>>>> email : $email");
      log(">>>>>>>>>> role : $role");
      log(">>>>>>>>>> appleId : ${credential.userIdentifier}");

      final body = {
        "appleId": credential.userIdentifier, // always available
        if (email!.isNotEmpty) "email": email,
        if (name.isNotEmpty) "name": name,
        "role": role,
      };

      final response = await authRepository.loginWithApple(body);

      if (response.statusCode != 200) {
        Get.snackbar("Error".tr, response.message);
        return;
      }

      final user = response.data['user'];

      // Role mismatch check
      if (user['role'] != PrefsHelper.myRole) {
        Get.snackbar(
          "Access Denied",
          "You're trying to log in as a ${user['role']}, "
              "but this portal is intended for ${PrefsHelper.myRole} access.",
        );
        return;
      }

      isRemember.value = true;
      _handleSuccessfulLogin(response);


        PrefsHelper.setParentBusinessId(
          response.data['user']['parentBusiness'] ?? "",
        );




      if (response.success) {
        if ((response.data["user"]?["phone"] as String).isEmpty) {
          showEditProfileInputDialog(
            context: context,
            name: name,
            email: email,
          );
          return;
        }
      }
      Get.to(
        LocationPermissionScreen(
          parentBusiness: response.data['user']['parentBusiness'],
        ),
      );
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
    PrefsHelper.accountCreateWith = "${response.data['user']['loginWth']}";

    if (isRemember.value) {
      PrefsHelper.setString("userId", PrefsHelper.userId);
      PrefsHelper.setString("token", PrefsHelper.token);
      PrefsHelper.setString("myName", PrefsHelper.myName);
      PrefsHelper.setString("myRole", PrefsHelper.myRole);
      PrefsHelper.setString("myImage", PrefsHelper.myImage);
      PrefsHelper.setBool("isLogIn", isRemember.value);
      PrefsHelper.setString("accountCreateWith", PrefsHelper.accountCreateWith);
    }
  }
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) async {
  if ((state == AppLifecycleState.paused ||
      state == AppLifecycleState.detached)) {
    await GoogleSignIn().signOut();
    log("logout.................................");
    Get.back(result: true);
    await PrefsHelper.removeAllPrefData();
  }
}

void showEditProfileInputDialog({
  required BuildContext context,
  String? name,
  String? email,
}) {
  EditController controller = Get.put(EditController());
  controller.nameController.text = name ?? "";
  controller.emailController.text = email ?? "";

  Get.dialog(
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async {
        await GoogleSignIn().signOut();
        log("logout.................................");
        Get.back(result: true);
        await PrefsHelper.removeAllPrefData();
        return false;
      },
      child: Dialog(
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
                  "Update Personal Details".tr,
                  style: styleForBoldText.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),

                Text(
                  AppString.userName,
                  style: styleForNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: AppString.userName,
                  isSuffix: false,
                  controller: controller.nameController,
                ),
                Platform.isIOS? SizedBox.shrink():
                const SizedBox(height: 16),
                Platform.isIOS? SizedBox.shrink():
                Text(
                  AppString.email,
                  style: styleForNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Platform.isIOS? SizedBox.shrink():
                const SizedBox(height: 6),
                Platform.isIOS? SizedBox.shrink():
                CustomTextField(
                  hintText:
                      "${AppString.email}${(Platform.isIOS) ? " (optional)" : ""}",
                  isSuffix: false,
                  controller: controller.emailController,
                  enabled: (controller.emailController.text.isEmpty),
                ),

                const SizedBox(height: 16),

                /// Date of Birth
                if (PrefsHelper.myRole == "user")
                  Text(
                    AppString.dateOfBirth,
                    style: styleForNormalText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (PrefsHelper.myRole == "user") const SizedBox(height: 6),
                if (PrefsHelper.myRole == "user")
                  Obx(
                    () => GestureDetector(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),

                          initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                              : "${AppString.dateOfBirth}${(Platform.isAndroid) ? " (optional)" : ""}",
                          style: styleForNormalText.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                /// Phone Number
                Text(
                  AppString.phoneNumber,
                  style: styleForNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                CustomPhoneField(controller: controller.phoneController),

                const SizedBox(height: 12),

                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppString.doYouHaveAnyReferral,
                            style: styleForNormalText,
                          ),
                          Checkbox(
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            value: controller.isCode.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (value) {
                              controller.isCode.value = value!;
                            },
                          ),
                        ],
                      ),
                      if (controller.isCode.value)
                        CustomTextField(
                          hintText: AppString.referralCode,
                          isSuffix: false,
                          backgroundColor: AppColors.textFieldBg,
                          controller: controller.referralController,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                        side: BorderSide(color: AppColors.primary, width: 2),
                        value: controller.isAgree.value,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) => controller.toggleRememberMe(),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${AppString.iAcceptThe} ",
                              style: styleForNormalText.copyWith(
                                fontSize: 18.sp,
                                height: 1.56.h,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(RoutesName.signUpPrivacyPolicy);
                                },
                              text: AppString.privacyPolicy,
                              style: styleForBoldText.copyWith(
                                color: AppColors.primary,
                                fontSize: 18.sp,
                                height: 1.56.h,
                              ),
                            ),
                            TextSpan(
                              text: " & ",
                              style: styleForBoldText.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 18.sp,
                                height: 1.56.h,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(RoutesName.termsOfService);
                                },
                              text: AppString.termsOfService,
                              style: styleForBoldText.copyWith(
                                color: AppColors.primary,
                                fontSize: 18.sp,
                                height: 1.56.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Actions
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  /// VALIDATION
                                  if (controller.nameController.text.isEmpty) {
                                    Get.snackbar(
                                      "Validation Error",
                                      "Please enter your name",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (Platform.isAndroid) {
                                    if (controller
                                        .emailController
                                        .text
                                        .isEmpty) {
                                      Get.snackbar(
                                        "Validation Error",
                                        "Please enter your email",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.shade600,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                  }

                                  // if (!Platform.isIOS) {
                                  //   if (controller.selectedDate.value == null &&
                                  //       PrefsHelper.myRole == "user") {
                                  //     Get.snackbar(
                                  //       "Validation Error",
                                  //       "Please select your date of birth",
                                  //       snackPosition: SnackPosition.BOTTOM,
                                  //       backgroundColor: Colors.red.shade600,
                                  //       colorText: Colors.white,
                                  //     );
                                  //     return;
                                  //   }
                                  // }

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
                                  if (!controller.isAgree.value) {
                                    Get.snackbar(
                                      "Validation Error",
                                      "Please accept the Privacy Policy",
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
                          child: controller.isLoading.value
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
    ),
  );
}
