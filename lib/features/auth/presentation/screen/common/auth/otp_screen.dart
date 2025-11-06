// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/auth/otp_controller.dart';
import 'package:event_ease/features/auth/presentation/controller/auth/sign_up_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/common_image.dart';
import '../../../widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  SignUpController controller = Get.find<SignUpController>();
  OtpController otpController = Get.find<OtpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.enterOtp,
          style: styleForBoldText.copyWith(fontSize: 24.sp, height: 1.60.h),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
              imageSrc: AppImages.otp,
              imageType: ImageType.png,
              height: 272.h,
              width: 272.w,
            ),
            SizedBox(height: 57.h),
            Center(
              child: Text(
                "${AppString.codeHasBeenSentTo}\n${controller.emailController.text}",
                style: styleForBoldText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 36.h),
            OtpTextField(
              numberOfFields: 6,
              fieldWidth: 53.w,
              fieldHeight: 49.h,
              filled: true,
              fillColor: AppColors.textFieldBg,
              contentPadding: EdgeInsets.all(2),
              textStyle: styleForBoldText.copyWith(
                fontSize: 24.sp,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(12),
              borderColor: AppColors.primary,
              disabledBorderColor: AppColors.primary,
              focusedBorderColor: AppColors.primary,
              enabledBorderColor: AppColors.primary,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // Handle logic when the user changes a single digit.
              },
              onSubmit: (String otp) {
                // Assign the OTP to the controller
                otpController.otpCode = otp;
              },
            ),
            SizedBox(height: 36.h),
            Obx(() {
              return otpController.showResendButton.value
                  ? TextButton(
                onPressed: otpController.resendOtp,
                child: Text(
                  AppString.resendOtp,
                  style: styleForBoldText.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.resendOtpIn,
                    style: styleForBoldText.copyWith(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " ${otpController.remainingTime.value} s",
                    style: styleForBoldText.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              );
            }),
            Spacer(),
            Obx(() => CustomButton(
              isLoading: otpController.isLoading.value,
              text: AppString.verifyOtp,
              onTap: () {
                otpController.verifyOtp();
              },
            ),),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
