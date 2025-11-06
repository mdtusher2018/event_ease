// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/helper/other_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/regular/Custom_description_Text_field.dart';

class GeneralInfoScreen extends StatelessWidget {
   GeneralInfoScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  BusinessProfileController controller = Get.find<BusinessProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Obx(() => Column(
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
                      AppString.stepGeneralInformation,
                      style: styleForBoldText.copyWith(fontSize: 24.sp),
                    ),

                    SizedBox(height: 10.h),
                    Text(
                      AppString.tellUsAboutYourBusiness,
                      style: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "${AppString.businessName}*",
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Business Name Field
                    CustomTextField(
                      hintText: AppString.businessName,
                      isSuffix: false,
                      controller: controller.businessNameController.value,
                      validator: (value) => OtherHelper.validator(value),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "${AppString.shortDescription}*",
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Short Description Field
                    CustomDescriptionTextField(
                      hintText: AppString.shortDescription,
                      controller: controller.shortDescriptionController.value,
                      validator: (value) => OtherHelper.validator(value),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      AppString.detailedDescription,
                      style: styleForBoldText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Detailed Description Field
                    CustomDescriptionTextField(
                      hintText: AppString.detailedDescription,
                      controller: controller.detailedDescriptionController.value,
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: CustomButton(
              text: AppString.save,
              isLoading: controller.isLoading.value,
              onTap: (){controller.updateGeneralInfo(controller.businessProfileModel.value.id);},),
          ),
        ],
      ),),
    );
  }
}