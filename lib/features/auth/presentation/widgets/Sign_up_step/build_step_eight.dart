// ignore_for_file: must_be_immutable

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/styles.dart';

class BuildStepEight extends StatefulWidget {
  BuildStepEight({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  _BuildStepEightState createState() => _BuildStepEightState();
}

class _BuildStepEightState extends State<BuildStepEight> {
  // List to hold question and answer data
  List<Map<String, String>> faqList = [
    {'question': '', 'answer': ''},
  ];

  SignUpStepController controller = Get.find<SignUpStepController>();

  // Function to add more FAQ fields
  void addFAQField() {
    setState(() {
      faqList.add({'question': '', 'answer': ''});
      controller.questionControllers.add(TextEditingController());
      controller.answerControllers.add(TextEditingController());
    });
  }

  // Function to delete a FAQ field
  void deleteFAQField(int index) {
    setState(() {
      faqList.removeAt(index);
      controller.questionControllers.removeAt(index);
      controller.answerControllers.removeAt(index);
    });
  }

void saveDraft() async {
  // Business info
  PrefsHelper.setString("businessName", controller.businessNameController.text);
  PrefsHelper.setString("shortDescription", controller.shortDescriptionController.text);
  PrefsHelper.setString("detailDescription", controller.detailedDescriptionController.text);

  // Logos & gallery
  PrefsHelper.setString("businessLogo", controller.businessLogo.value);
  PrefsHelper.setString("coverLogo", controller.coverLogo.value);
  PrefsHelper.setStringList(
      "galleryLogo", controller.galleryLogo.map((e) => e.path).toList());

  // Contact info
  PrefsHelper.setString("email", controller.emailController2.text);
  PrefsHelper.setString("phoneNumber", controller.phoneNumberController.text);
  PrefsHelper.setString("website", controller.websiteController.text);

  // Socials
  PrefsHelper.setString("facebook", controller.facebookController.text);
  PrefsHelper.setString("instagram", controller.instagramController.text);
  PrefsHelper.setString("tiktok", controller.tilTokController.text);

  // Timings & selected days
  PrefsHelper.setString("startTime", controller.startTime.value);
  PrefsHelper.setString("endTime", controller.endTime.value);
  PrefsHelper.setStringList(
      "selectedDays",
      controller.selectedDays
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => e.key.toString())
          .toList());

  // Location
  PrefsHelper.setString("address", controller.addressSearchController.text);
  PrefsHelper.setString("latitude", controller.lat);
  PrefsHelper.setString("longitude", controller.long);

  // Price & guests
  PrefsHelper.setString("priceRange", controller.selectedPriceRange.value);
  // PrefsHelper.setInt("guestCount", guestCount);

  // FAQs
  for (int i = 0; i < controller.questionControllers.length; i++) {
    PrefsHelper.setString("faq_question_$i", controller.questionControllers[i].text);
    PrefsHelper.setString("faq_answer_$i", controller.answerControllers[i].text);
  }
   Get.offAndToNamed(RoutesName.nav);
  Get.snackbar("Success".tr, "Draft saved!", backgroundColor: Colors.white, colorText: Colors.black);
      
}
  // void saveDraft() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Draft Saved!')),
  //   );
  // }

  void continuePage() {

 bool allValid = true;

  // Loop through all question and answer controllers
  for (int i = 0; i < controller.questionControllers.length; i++) {
    if (controller.questionControllers[i].text.isEmpty ||
        controller.answerControllers[i].text.isEmpty) {
      allValid = false;
      break;
    }
  }

  if (controller.questionControllers.isEmpty) {
    // No FAQ added
    Get.snackbar(
      "Required",
      "Please add at least one FAQ",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (!allValid) {
    // Some fields are empty
    Get.snackbar(
      "Required",
      "Please fill all question and answer fields",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }


      widget.onContinue!();

  }

  // void continuePage() {
  //   // Check if at least logo is uploaded before continuing
  //   if (_formKey.currentState!.validate()) {
  //     if (!_logoUploaded) {
  //       Get.snackbar(
  //           "Required",
  //           "Please upload a business logo",
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white
  //       );
  //       return;
  //     }
  //     widget.onContinue();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Subtitle
          if (widget.titleBool == true)
            Center(
              child: Text(
                AppString.signUpForPianoFestaBusiness,
                style: styleForBoldText.copyWith(
                  fontSize: 32.sp,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (widget.titleBool == true)  SizedBox(height: 20.h),
          if (widget.titleBool == true)
            Text(
              AppString.stepAddFaq,
              style: styleForBoldText.copyWith(fontSize: 24.sp),
            ),
          if (widget.titleBool == false)
            Text(
              AppString.addFaq,
              style: styleForBoldText.copyWith(fontSize: 24.sp),
            ),

           SizedBox(height: 20.h),

          // Loop through faqList to display question-answer fields
          ...List.generate(faqList.length, (index) {
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
                if (faqList.length > 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteFAQField(index),
                    ),
                  ),

                 SizedBox(height: 20.h),
              ],
            );
          }),

          InkWell(
            onTap: addFAQField,
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
          if (widget.bottomButtons == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: saveDraft,
                  child: Text(
                    'Save As Draft',
                    style: styleForBoldText.copyWith(fontSize: 20.sp),
                  ),
                ),
                ElevatedButton(
                  onPressed: continuePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: styleForBoldText.copyWith(
                          color: Colors.white,
                          height: 1.40,
                          letterSpacing: 0.20,
                          fontSize: 20.sp,
                        ),
                      ),
                       SizedBox(width: 8.w),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
