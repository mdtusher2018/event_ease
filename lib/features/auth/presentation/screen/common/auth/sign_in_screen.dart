// ignore_for_file: must_be_immutable

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../controller/auth/sign_in_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  SignInController controller = Get.find<SignInController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 133.h),
              CommonImage(
                imageSrc: AppIcons.appLogo,
                imageType: ImageType.png,
                height: 64.h,
                width: 352.w,
              ),
              // Image(image: AssetImage(AppIcons.appLogo)),
              SizedBox(height: 77.h),
              Center(
                child: Text(
                  AppString.signInYourAccount,
                  style: styleForBoldText.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 37.h),
              CustomTextField(
                validator: (value) => OtherHelper.emailValidator(value),
                prefixIcon: AppIcons.emailLogo,
                hintText: AppString.email,
                isSuffix: false,
                backgroundColor: AppColors.textFieldBg,
                controller: controller.emailController,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                validator: (value) => OtherHelper.validator(value),
                prefixIcon: AppIcons.loginPassword,
                hintText: AppString.password,
                isSuffix: true,
                backgroundColor: AppColors.textFieldBg,
                controller: controller.passwordController,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      side: BorderSide(color: AppColors.primary, width: 2),
                      value: controller.isRemember.value,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (value) => controller.toggleRememberMe(),
                    ),
                  ),
                  Text(
                    AppString.rememberMe,
                    style: styleForBoldText.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Obx(
                () => CustomButton(
                  text: AppString.signIn,
                  isLoading: controller.isLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.loginUser();
                    }
                  },
                ),
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: () {
                  Get.toNamed(RoutesName.forgetPassword);
                },
                child: Text(
                  "${AppString.forgetPassword}?",
                  style: styleForBoldText.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0.20,
                    height: 1.40,
                    fontSize: 16.h,
                  ),
                ),
              ),

              SizedBox(height: 26.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 1.h,
                    width: 102.w,
                    color: Color(0xFFEEEEEE),
                  ),
                  Text(
                    AppString.orContinueWith,
                    style: styleForBoldText.copyWith(
                      color: AppColors.grey,
                      fontSize: 18.sp,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    width: 102.w,
                    color: Color(0xFFEEEEEE),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              InkWell(
                onTap: () {
                  controller.loginWithGoogle(context);
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: [
                      SvgPicture.asset(
                        AppIcons.googleIcon,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // if (Platform.isIOS)
              // SizedBox(
              //   width: 80,
              //   child: SignInWithAppleButton(
              //     height: 50,
              //     text: "",
              //     onPressed: () async {
              //       controller.loginWithApple();
              //     },
              //   ),
              // ),
              SizedBox(height: 40.h),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppString.doNotHaveAnAccount}?",
                      style: styleForNormalText.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(RoutesName.signUp);
                      },
                      child: Text(
                        AppString.signUp,
                        style: styleForBoldText.copyWith(
                          color: AppColors.primary,
                          height: 1.40,
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
    );
  }
}
