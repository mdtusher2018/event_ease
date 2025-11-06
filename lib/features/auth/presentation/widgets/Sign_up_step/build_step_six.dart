
// ignore_for_file: must_be_immutable

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_url.dart';

class BuildStepSix extends StatefulWidget {
  BuildStepSix({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepSix> createState() => _BuildStepSixState();
}

class _BuildStepSixState extends State<BuildStepSix> {
  final _formKey = GlobalKey<FormState>();

  SignUpStepController controller = Get.find<SignUpStepController>();




  @override
  void initState() {
    super.initState();
    loadDraft(); // ✅ Load saved draft when screen opens
  }

  /// ✅ Save draft into PrefsHelper
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


  /// ✅ Load draft from PrefsHelper
  void loadDraft() async{
    if (PrefsHelper.address.isNotEmpty && PrefsHelper.latitude.isNotEmpty && PrefsHelper.longitude.isNotEmpty) {
      controller.addressSearchController.text =PrefsHelper.address;
      controller.lat =PrefsHelper.latitude;
      controller.long = PrefsHelper.longitude;
    }
 
  }










  // void saveDraft() {
  //   PrefsHelper.address = controller.addressSearchController.text;
  //   PrefsHelper.setString("address", PrefsHelper.address);
  //   PrefsHelper.latitude = controller.lat;
  //   PrefsHelper.setString("latitude", PrefsHelper.latitude);
  //   PrefsHelper.longitude = controller.long;
  //   PrefsHelper.setString("longitude", PrefsHelper.longitude);

  //   Get.snackbar("Success".tr, "Draft saved!", backgroundColor: Colors.white, colorText: Colors.black);

  // }

  void continuePage() {
      if (controller.addressSearchController.text.trim().isEmpty) {
    Get.snackbar(
      "Error",
      "Please enter your address.",
      backgroundColor: Colors.white,
      colorText: Colors.red,
    );
    return;
  }
    widget.onContinue!();
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
                AppString.stepAddressMap,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            if (widget.titleBool == false)
              Text(AppString.addressMap, style: styleForBoldText.copyWith(fontSize: 24.sp)),
             SizedBox(height: 10.h),
            Text(
              '${AppString.whereAreYouLocated}?',
              style: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 18.sp, fontWeight: FontWeight.w600,),
            ),
             SizedBox(height: 16.h),
            // Business Name Field
            Text(
              AppString.address,
              style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 50,
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller.addressSearchController,
                googleAPIKey: AppUrl.googleMapPlaceKey,
                containerVerticalPadding: 4,
focusNode: FocusNode(),
                inputDecoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: AppString.searchLocation,
                  hintStyle: styleForNormalText.copyWith(
                    color: AppColors.grey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: AppColors.textFieldBg,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                debounceTime: 800,
                boxDecoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textFieldBg
                ),
                
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (prediction) {},
                itemClick: (prediction) {
                  controller.addressSearchController.text = prediction.description!;
                  // searchController.text = prediction.description!;
                  controller.addressSearchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length),
                  );
                },
              ),
            ),
             SizedBox(height: 15.h),
          

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
