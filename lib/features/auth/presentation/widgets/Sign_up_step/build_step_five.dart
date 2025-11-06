// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';

class BuildStepFive extends StatefulWidget {
  BuildStepFive({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepFive> createState() => _BuildStepFiveState();
}

class _BuildStepFiveState extends State<BuildStepFive> {
  final _formKey = GlobalKey<FormState>();
  SignUpStepController controller = Get.find<SignUpStepController>();





  @override
  void initState() {
    super.initState();
    loadDraft(); // Load saved data when widget starts
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
    controller.startTime.value =await PrefsHelper.getString("startTime");
    controller.endTime.value =await PrefsHelper.getString("endTime");

    // Load selected days
    final savedIndexes =await PrefsHelper.getStringList("selectedDays");
    controller.selectedDays.clear();
    controller.selectedDays
        .addAll(List.generate(dayNames.length, (index) => false));

    for (var index in savedIndexes) {
      int i = int.tryParse(index) ?? -1;
      if (i >= 0 && i < controller.selectedDays.length) {
        controller.selectedDays[i] = true;
        controller.selectedDay.add(dayNames[i]);
      }
    }
  }












  final List<String> dayNames = [
    AppString.sunday,
    AppString.monday,
    AppString.tuesday,
    AppString.wednesday,
    AppString.thursday,
    AppString.friday,
    AppString.saturday,
  ];


  // void saveDraft() {
  //   PrefsHelper.startTime = controller.startTime.value;
  //   PrefsHelper.setString("startTime", PrefsHelper.startTime);
  //   PrefsHelper.endTime = controller.endTime.value;
  //   PrefsHelper.setString("endTime", PrefsHelper.endTime);

  //   Get.snackbar("Success".tr, "Draft saved!", backgroundColor: Colors.white, colorText: Colors.black);
  // }

  void continuePage() {
    if (_formKey.currentState!.validate()) {


      if (!controller.selectedDays.contains(true)) {
      Get.snackbar(
        "Error",
        "Please select at least one day.",
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return;
    }
      if(controller.startTime.value.isEmpty || controller.endTime.value.isEmpty) {
        Get.snackbar("Error".tr,"Please select start and end time.", backgroundColor: Colors.white, colorText: Colors.red);
        return;
      }

      widget.onContinue!();
    }
  }
  String formatTimeOfDay(TimeOfDay time, {BuildContext? context}) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context ?? Get.context!);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay picked = await OtherHelper.pickTime(
      context,
      TimeOfDay.now(),
    );

    final formatted = formatTimeOfDay(picked);

    if (isStartTime) {
      controller.startTime.value = formatted;
      log("Start Time: $formatted");
    } else {
      controller.endTime.value = formatted;
      log("End Time: $formatted");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                Text(AppString.stepBusinessHours, style: styleForBoldText.copyWith(fontSize: 24.sp)),
              if (widget.titleBool == false)
                Text(
                  AppString.businessHours,
                  style: styleForBoldText.copyWith(fontSize: 24.sp),
                ),
              SizedBox(height: 10.h),
              Text(
                '${AppString.whenAreYouAvailableForCustomers}?',
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),

              // Days of Week Section
              Text(
                AppString.daysOfWeek,
                style: styleForBoldText.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                // Ensure selectedDays has the correct length
                if (controller.selectedDays.length != dayNames.length) {
                  controller.selectedDays.clear();
                  controller.selectedDays.addAll(List.generate(dayNames.length, (index) => false));
                }

                return Column(
                  children: List.generate(dayNames.length, (index) {
                    return CheckboxListTile(
                      title: Text(
                        dayNames[index],
                        style: styleForBoldText.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                      value: controller.selectedDays[index],
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      onChanged: (value) {
                        if (value == true) {
                          controller.selectedDay.add(dayNames[index]);
                        } else {
                          controller.selectedDay.remove(dayNames[index]);
                        }
                        log("selected day====${controller.selectedDay}");
                        controller.selectedDays[index] = value!;
                      },
                    );
                  }),
                );
              }),
              SizedBox(height: 16.h),

              Text(
                AppString.startTime,
                style: styleForBoldText.copyWith(
                    fontSize: 18.sp, color: AppColors.primary, height: 1.50),
              ),
              const SizedBox(height: 8),
              Obx(() => InkWell(
                onTap: () => _selectTime(context, true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.textFieldBg,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        controller.startTime.value.isNotEmpty ? controller.startTime.value:"",
                        style: styleForNormalText.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),),

              SizedBox(height: 15.h),
              Text(
                AppString.endTime,
                style: styleForBoldText.copyWith(
                    fontSize: 18.sp, color: AppColors.primary, height: 1.50),
              ),
              const SizedBox(height: 8),
              Obx(() => InkWell(
                onTap: () => _selectTime(context, false),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.textFieldBg,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        controller.endTime.value.isNotEmpty ? controller.endTime.value:"",
                        style: styleForNormalText.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
              SizedBox(height: 20.h),
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
                                fontSize: 20.sp),
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
      ),
    );
  }
}