// ignore_for_file: must_be_immutable

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';

class BuildStepFour extends StatefulWidget {
   BuildStepFour({super.key,  this.onContinue, this.bottomButtons = true, this.titleBool = true});
   VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepFour> createState() => _BuildStepFourState();
}

class _BuildStepFourState extends State<BuildStepFour> {
  final _formKey = GlobalKey<FormState>();
  SignUpStepController controller = Get.find<SignUpStepController>();



  @override
  void initState() {
    super.initState();
    loadDraft(); // restore saved draft if exists
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


  void loadDraft() async{
    controller.facebookController.text =
        await PrefsHelper.getString("facebook");
    controller.instagramController.text =
       await PrefsHelper.getString("instagram");
    controller.tilTokController.text =
        await PrefsHelper.getString("tiktok");
  }





  // void saveDraft() {
  //   PrefsHelper.facebook = controller.facebookController.text;
  //   PrefsHelper.setString("facebook", PrefsHelper.facebook);
  //   PrefsHelper.instagram = controller.instagramController.text;
  //   PrefsHelper.setString("instagram", PrefsHelper.instagram);
  //   PrefsHelper.tiktok = controller.tilTokController.text;
  //   PrefsHelper.setString("tiktok", PrefsHelper.tiktok);

  //   Get.snackbar("Success".tr, "Draft saved!", backgroundColor: Colors.white, colorText: Colors.black);
  // }

  void continuePage() {
    if (_formKey.currentState!.validate()) {
      widget.onContinue!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center the text
            if(widget.titleBool==true)
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
            if(widget.titleBool==true)
               SizedBox(height: 20.h),
            if(widget.titleBool==true)
              Text(
                AppString.stepSocialNetworks,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            if(widget.titleBool==false)
              Text(
                AppString.socialNetworks,
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
            CustomTextField(
              hintText: AppString.facebook,
              isSuffix: false,
              controller: controller.facebookController,
            ),
             SizedBox(height: 10.h),
            // Short Description Field
            Text(
              AppString.instagram,
                style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
            ),
            SizedBox(height: 5.h,),
            CustomTextField(
              hintText: AppString.instagram,
              isSuffix: false,
              controller: controller.instagramController,
            ),
            SizedBox(height: 10.h,),
            Text(
              AppString.tikTok,
                style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
            ),
            SizedBox(height: 5.h,),
            // Detailed Description Field
            CustomTextField(
              hintText: AppString.tikTok,
              isSuffix: false,
              controller: controller.tilTokController,
            ),
             SizedBox(height: 10.h),

            if (widget.bottomButtons == true) const Spacer(),
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
                            fontSize: 20.sp
                        )
                      ),
                       SizedBox(width: 8.w),
                       Icon(
                        Icons.arrow_forward,
                        color: Colors.white,

                      ),
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
