// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';

class SocialNetworkScreen extends StatelessWidget {
  SocialNetworkScreen({super.key});
  BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Make BuildStepOne scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                      Text(
                        AppString.stepSocialNetworks,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),

                    SizedBox(height: 10.h),
                    Text(
                      AppString.connectYourBusinessSocialMediaAccounts,
                      style: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 18.sp, fontWeight: FontWeight.w600,),
                    ),
                    SizedBox(height: 16.h),
                    // Business Name Field
                    Text(
                        AppString.facebook,
                        style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
                    ),
                    SizedBox(height: 5.h,),
                    Obx(() => CustomTextField(
                      hintText: AppString.facebook,
                      isSuffix: false,
                      controller: controller.facebookController.value,
                    ),),
                    SizedBox(height: 10.h),
                    // Short Description Field
                    Text(
                        AppString.instagram,
                        style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
                    ),
                    SizedBox(height: 5.h,),
                    Obx(() => CustomTextField(
                      hintText: AppString.instagram,
                      isSuffix: false,
                      controller: controller.instagramController.value,
                    ),),
                    SizedBox(height: 10.h,),
                    Text(
                        AppString.twitter,
                        style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
                    ),
                    SizedBox(height: 5.h,),
                    // Detailed Description Field
                    Obx(() => CustomTextField(
                      hintText: AppString.twitter,
                      isSuffix: false,
                      controller: controller.twitterController.value,
                    ),),
                    SizedBox(height: 10.h),
                    Text(
                        AppString.tikTok,
                        style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
                    ),
                    SizedBox(height: 5.h,),
                    // Detailed Description Field
                    Obx(() => CustomTextField(
                      hintText: AppString.tikTok,
                      isSuffix: false,
                      controller: controller.tikTokController.value,
                    ),),
                    SizedBox(height: 10.h),

                  ],
                ),
              ),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(text: AppString.save, isLoading: controller.isLoading.value, onTap: (){controller.updateSocialInfo(controller.businessProfileModel.value.id);},),),
          ),
        ],
      ),
    );
  }
}
