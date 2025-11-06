// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_images.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/auth/forget_password_controller.dart';
import '../../../utils/app_icons.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  ForgetPasswordController controller = Get.find<ForgetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.forgetPassword,
          style: styleForBoldText.copyWith(fontSize: 24.sp, height: 1.60.h),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 20),
        child: Column(
          children: [
            CommonImage(
              imageSrc: AppImages.forgetPassword,
              imageType: ImageType.png,
              height: 333.h,
              width: 333.w,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: AppString.enterYourEmail,
              isSuffix: false,
              controller: controller.emailController,
              prefixIcon: AppIcons.emailLogo,
            ),
            Spacer(),
            Obx(
              () => CustomButton(
                isLoading: controller.isLoading.value,
                text: AppString.continueText,
                onTap: () {
                  controller.forgetPassword();
                },
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
