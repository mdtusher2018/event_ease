// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/auth/sign_up_step_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/styles.dart';

class BuildStepTwo extends StatefulWidget {
  BuildStepTwo({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepTwo> createState() => _BuildStepTwoState();
}

class _BuildStepTwoState extends State<BuildStepTwo> {
  final _formKey = GlobalKey<FormState>();

  // Track if images have been uploaded
  RxBool logoUploaded = false.obs;
  SignUpStepController controller = Get.find<SignUpStepController>();
  // bool _coverUploaded = false;
  // bool _galleryUploaded = false;






  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  void _loadDraft() async{
    // Business Logo
    String savedBusinessLogo = await PrefsHelper.getString("businessLogo");
    if (savedBusinessLogo.isNotEmpty) {
      controller.businessLogo.value = savedBusinessLogo;
      logoUploaded.value = true;
    }

    // Cover Logo
    String savedCoverLogo =await PrefsHelper.getString("coverLogo");
    if (savedCoverLogo.isNotEmpty) {
      controller.coverLogo.value = savedCoverLogo;
    }

    // Gallery Logos
    List<String> savedGallery =await PrefsHelper.getStringList("galleryLogo");
    if (savedGallery.isNotEmpty) {
      controller.galleryLogo.value =
          savedGallery.map((path) => File(path)).toList();
    }
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
    // Check if at least logo is uploaded before continuing
    if (_formKey.currentState!.validate()) {
      if (!logoUploaded.value) {
        Get.snackbar(
          "Required",
          "Please upload a business logo",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
         if (controller.coverLogo.value.isEmpty) {
        Get.snackbar(
          "Required",
          "Please upload a business Cover Image",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
         if (controller.galleryLogo.isEmpty) {
        Get.snackbar(
          "Required",
          "Please upload atleast 1 gallery image ",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      widget.onContinue!();
    }
  }
  void businessImage () async {
    controller.businessLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
    if (controller.businessLogo.value.isNotEmpty) {
      logoUploaded.value = true;
    }
  }
  void coverImage () async {
    controller.coverLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  void galleryImage() async {
    final List<String> paths = await OtherHelper.pickMultipleImage(ImageSource.gallery);
    controller.galleryLogo.value = paths.map((path) => File(path)).toList();
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
            if (widget.titleBool == true) SizedBox(height: 20.h),
            if (widget.titleBool == true)
              Text(
                AppString.stepImagesMedia,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            if (widget.titleBool == false)
              Text(
                AppString.imagesMedia,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            SizedBox(height: 10.h),
            Text(
              AppString.showcaseYourBusinessWithVisualContent,
              style: styleForNormalText.copyWith(
                color: AppColors.grey,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),

            // Business Logo Section
            Row(
              children: [
                Text(
                  "${AppString.businessLogo}*",
                  style: styleForBoldText.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                logoUploaded.value
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Container(),

              ],
            ),
            SizedBox(height: 10.h),
            Obx(() => Row(
              children: [
                InkWell(
                  onTap: () => businessImage(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload, color: Colors.white, size: 20.r),
                        SizedBox(width: 8.r),
                        Text(
                          logoUploaded.value
                              ? AppString.changeImage
                              : AppString.uploadImage,
                          style: styleForBoldText.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                controller.businessLogo.value.isNotEmpty? CommonImage(imageSrc: controller.businessLogo.value, height: 30, width: 30,imageType: ImageType.file,):SizedBox()
              ],
            ),),

            SizedBox(height: 20.h),

            // Cover Image Section
            Text(
              AppString.coverImage,
              style: styleForBoldText.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                InkWell(
                  onTap: () => coverImage(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload, color: Colors.white, size: 20.r),
                        const SizedBox(width: 8),
                        Text(
                          AppString.uploadImage,
                          style: styleForBoldText.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Obx(() => controller.coverLogo.value.isNotEmpty? CommonImage(imageSrc: controller.coverLogo.value, height: 30, width: 30,imageType: ImageType.file,):SizedBox(),)

              ],
            ),

            SizedBox(height: 20.h),

            // Gallery Images Section
            Text(
              AppString.galleryImages,
              style: styleForBoldText.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                InkWell(
                  onTap: () => galleryImage(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload, color: Colors.white, size: 20.r),
                        SizedBox(width: 8.w),
                        Text( AppString.uploadImage,
                          style: styleForBoldText.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.coverLogo.value.isNotEmpty?SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: controller.galleryLogo.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: CommonImage(imageSrc: controller.galleryLogo[index].path, height: 30, width: 30,imageType: ImageType.file),
                      );
                    },),
                )
                    :SizedBox(),)

              ],
            ),
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
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, color: Colors.white),
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
