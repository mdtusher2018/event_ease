// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/auth/otp_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/common_image.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  CreateNewPasswordScreen({super.key});

  OtpController controller = Get.find<OtpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppString.createNewPassword, style: styleForBoldText.copyWith(fontSize: 24.sp, height: 1.60.h),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            CommonImage(imageSrc: AppImages.createNewPassword, imageType: ImageType.png,height: 300.h, width: 300.w,),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.topLeft,
                child: Text(AppString.createYourNewPassword, style: styleForBoldText. copyWith(color: Colors.black, fontSize: 24.sp),)),
            SizedBox(height: 24.h,),
            CustomTextField(hintText: AppString.newPassword, isSuffix: true, controller: controller.passwordController, prefixIcon: AppIcons.loginPassword,),
            SizedBox(height: 24.h,),
            CustomTextField(hintText: AppString.confirmNewPassword, isSuffix: true, controller: controller.confirmPasswordController, prefixIcon: AppIcons.loginPassword,),
            SizedBox(height:172.h,),
            Obx(() => CustomButton(isLoading: controller.isLoading.value, text: AppString.continueText, paddingVertical: 12,onTap: (){controller.newPassword();},),),



          ],
        ),
      ),
    );
  }
}
