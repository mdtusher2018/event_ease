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

class FaqScreen extends StatelessWidget {
   FaqScreen({super.key});

  BusinessProfileController controller = Get.find<BusinessProfileController>();

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
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    AppString.stepAddFaq,
                    style: styleForBoldText.copyWith(fontSize: 24.sp),
                  ),

                  SizedBox(height: 20.h),

                  // Loop through faqList to display question-answer fields
                  ...List.generate(controller.faqList.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question field
                        Text(
                          'Question ${index + 1}',
                          style: styleForBoldText.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            height: 1.56.h,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hintText: 'Add Question',
                          isSuffix: false,
                          controller: controller.questionControllers[index],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Answer field
                        Text(
                          'Answer ${index + 1}',
                          style: styleForBoldText.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            height: 1.56.h,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          maxLine: 4,
                          hintText: 'Answer',
                          isSuffix: false,
                          controller: controller.answerControllers[index],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),

                        // Delete button for each FAQ field
                        if (controller.faqList.length > 1)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteFAQField(index),
                            ),
                          ),

                        SizedBox(height: 20.h),
                      ],
                    );
                  }),

                  InkWell(
                    onTap: controller.addFAQField,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        AppString.addMore,
                        style: styleForBoldText.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 130.h),

                ],
              ),),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(text: AppString.save, isLoading: controller.isLoading.value, onTap: (){
              controller.updateFaqInfo(controller.businessProfileModel.value.id);
            },),),
          ),
        ],
      ),
    );
  }
}
