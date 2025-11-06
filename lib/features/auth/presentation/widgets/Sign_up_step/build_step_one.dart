// ignore_for_file: must_be_immutable

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/Custom_description_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/helper/other_helper.dart';
import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';

class BuildStepOne extends StatefulWidget {
  BuildStepOne({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepOne> createState() => _BuildStepOneState();
}

class _BuildStepOneState extends State<BuildStepOne> {
  final _formKey = GlobalKey<FormState>();
  SignUpStepController controller = Get.find<SignUpStepController>();




  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  void _loadDraft() async{
    // Load saved values from PrefsHelper
    controller.businessNameController.text =
      await  PrefsHelper.getString("businessName");
    controller.shortDescriptionController.text =
      await  PrefsHelper.getString("shortDescription") ;
    controller.detailedDescriptionController.text =
      await  PrefsHelper.getString("detailDescription") ;
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


  void continuePage() {
    if (_formKey.currentState!.validate()) {
      widget.onContinue!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center the text
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
            if (widget.titleBool == true) const SizedBox(height: 20),
            if (widget.titleBool == true)
              Text(
                AppString.stepGeneralInformation,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            if (widget.titleBool == false)
              Text(
                AppString.generalInformation,
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
              controller: controller.businessNameController,
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
              controller: controller.shortDescriptionController,
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
              controller: controller.detailedDescriptionController,
              validator: (value) => OtherHelper.validator(value),
            ),
            SizedBox(height: 30.h),

            // Buttons
            if (widget.bottomButtons == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: saveDraft,
                    child: Text(
                      AppString.saveAsDraft,
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
                          AppString.continueText,
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
      ),
    );
  }
}
