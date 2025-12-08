import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/auth/sign_up_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/helper/other_helper.dart';
import '../../../widgets/common_image.dart';
import '../../../widgets/custom_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.find<SignUpController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: _formKey, // Wrap the form fields in a Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                CommonImage(
                  imageSrc: AppIcons.appLogo,
                  imageType: ImageType.png,
                  height: 64.h,
                  width: 352.w,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    AppString.createYourAccount,
                    style: styleForBoldText.copyWith(fontSize: 32.sp),
                  ),
                ),
                SizedBox(height: 23.h),
                CustomTextField(
                  hintText: AppString.firstName,
                  isSuffix: false,
                  controller: controller.firstNameController,
                  validator: (value) => OtherHelper.validator(value),
                ),

                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: "Last Name".tr,
                  isSuffix: false,
                  controller: controller.sureNameController,
                  validator: (value) => OtherHelper.validator(value),
                ),

                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: AppString.userName,
                  isSuffix: false,
                  controller: controller.userNameController,
                  validator: (value) => OtherHelper.validator(value),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  prefixIcon: AppIcons.emailLogo,
                  hintText: AppString.email,
                  isSuffix: false,
                  backgroundColor: AppColors.textFieldBg,
                  controller: controller.emailController,
                  validator: (value) => OtherHelper.emailValidator(value),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  prefixIcon: AppIcons.phoneLogo,
                  hintText: AppString.phoneNumber,

                  isSuffix: false,
                  keyboardType: TextInputType.phone,
                  backgroundColor: AppColors.textFieldBg,
                  controller: controller.phoneController,
                  validator: (value) => OtherHelper.phoneValidator(value),
                ),
                SizedBox(height: 20.h),
                if (PrefsHelper.myRole == 'user')
                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.selectDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBg,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 21.h,
                                    horizontal: 20.w,
                                  ),
                                  child: SizedBox(
                                    height: 16.h,
                                    width: 16.w,
                                    child: CommonImage(
                                      imageSrc: AppIcons.calenderIcon,
                                      imageType: ImageType.svg,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  controller.selectedDate.value != null
                                      ? DateFormat(
                                        'dd/MM/yyyy',
                                        // 'yyyy-MM-dd',
                                      ).format(controller.selectedDate.value!)
                                      : AppString.dateOfBirth,
                                  style: styleForNormalText.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  }),

                if (PrefsHelper.myRole == 'user') SizedBox(height: 20.h),

                if (PrefsHelper.myRole == 'user')
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBg,
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: CommonImage(
                              imageSrc: AppIcons.genderIcon,
                              imageType: ImageType.svg,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                                value:
                                    controller.selectedGender.value.isNotEmpty
                                        ? controller.selectedGender.value
                                        : null,
                                style: styleForNormalText.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                hint: Text(
                                  AppString.selectGender,
                                  style: styleForNormalText.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                items:
                                    controller.genderItem.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedGender.value = newValue;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                if (PrefsHelper.myRole == 'user') SizedBox(height: 20.h),

                CustomTextField(
                  prefixIcon: AppIcons.loginPassword,
                  hintText: AppString.password,
                  isSuffix: true,
                  backgroundColor: AppColors.textFieldBg,
                  controller: controller.passwordController,
                  validator: (value) => OtherHelper.passwordValidator(value),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  prefixIcon: AppIcons.loginPassword,
                  hintText: AppString.confirmPassword,
                  isSuffix: true,
                  backgroundColor: AppColors.textFieldBg,
                  controller: controller.confirmPasswordController,
                  validator:
                      (value) => OtherHelper.confirmPasswordValidator(
                        value,
                        controller.passwordController,
                      ),
                ),

                SizedBox(height: 20.h),

                // if (PrefsHelper.myRole == 'user')
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
                          validator: (value) => OtherHelper.validator(value),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),
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
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(
                                        RoutesName.signUpPrivacyPolicy,
                                      );
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
                              recognizer:
                                  TapGestureRecognizer()
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
                SizedBox(height: 20.h),
                Obx(
                  () => CustomButton(
                    text: AppString.signUp,
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (controller.isAgree.value) {
                        if (_formKey.currentState!.validate()) {
                          if (controller.selectedDate.value == null &&
                              PrefsHelper.myRole == 'user') {
                            Get.snackbar(
                              "Date of Birth Required",
                              "Please select your date of birth.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return; // Stop execution
                          }

                          if (controller.selectedGender.value.isEmpty &&
                              PrefsHelper.myRole == 'user') {
                            Get.snackbar(
                              "Gender Required",
                              "Please select your gender.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return; // Stop execution
                          }

                          controller.createUser();
                        } else {
                          log("Form validation failed");
                        }
                      } else {
                        Get.snackbar(
                          AppString.acceptTerms,
                          AppString.pleaseAcceptThePrivacyPolicy,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),

                SizedBox(height: 42.h),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppString.alreadyHaveAnAccount}?",
                        style: styleForNormalText.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                          height: 1.40.h,
                          letterSpacing: 0.20,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesName.signIn);
                        },
                        child: Text(
                          AppString.signIn,
                          style: styleForBoldText.copyWith(
                            color: AppColors.primary,
                            height: 1.40.h,
                            letterSpacing: 0.2,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
