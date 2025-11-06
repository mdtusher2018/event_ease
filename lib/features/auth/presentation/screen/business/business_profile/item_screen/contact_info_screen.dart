// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/helper/other_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';

class ContactInfoScreen extends StatelessWidget {
  ContactInfoScreen({super.key});
  BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
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
                      AppString.stepContactInformation,
                      style: styleForBoldText.copyWith(fontSize: 24.sp),
                    ),

                    SizedBox(height: 10.h),
                    Text(
                      '${AppString.howCanUsersReachYou}?',
                      style: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Business Name Field
                    Text(
                      '${AppString.email} *',
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Obx(
                      () => CustomTextField(
                        hintText: AppString.email,
                        isSuffix: false,
                        controller: controller.emailController.value,
                        validator: (value) => OtherHelper.validator(value),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Short Description Field
                    Text(
                      '${AppString.phoneNumber} *',
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Obx(
                      () => CustomTextField(
                        hintText: AppString.phoneNumber,
                        isSuffix: false,
                        keyboardType: TextInputType.phone,
                        controller: controller.phoneNumberController.value,
                        validator: (value) => OtherHelper.validator(value),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      AppString.website,
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Detailed Description Field
                    Obx(
                      () => CustomTextField(
                        hintText: AppString.website,
                        isSuffix: false,
                        controller: controller.websiteController.value,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(
              () => CustomButton(
                text: AppString.save,
                isLoading: controller.isLoading.value,
                onTap: () {
                  controller.updateContactInfo(
                    controller.businessProfileModel.value.id,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
