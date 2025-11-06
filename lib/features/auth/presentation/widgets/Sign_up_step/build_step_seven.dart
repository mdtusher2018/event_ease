// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_text_field.dart';

class BuildStepSeven extends StatefulWidget {
  BuildStepSeven({
    super.key,
    this.onContinue,
    this.bottomButtons = true,
    this.titleBool = true,
  });
  VoidCallback? onContinue;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepSeven> createState() => _BuildStepSevenState();
}

class _BuildStepSevenState extends State<BuildStepSeven> {
  final _formKey = GlobalKey<FormState>();

  SignUpStepController controller = Get.find<SignUpStepController>();

  List<bool> selectedEventTypes = List.generate(8, (_) => false);
  List<bool> selectedAdditionalServices = List.generate(8, (_) => false);
  String selectedPriceRange = '';

  int? selectedAdditionalServiceIndex;

  final List<Map<String, String>> priceOptions = [
    {"label": "€-Budget", "value": "budget"},
    {"label": "€€-Medium", "value": "medium"},
    {"label": "€€€-High", "value": "high"},
    {"label": "€€€€-Luxury", "value": "luxury"},
  ];


  int guestCount = 0;




  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {

    controller.selectedPriceRange.value =
        await PrefsHelper.getString("priceRange") ;
    guestCount = await PrefsHelper.getInt("guestCount");
    controller.maxCountController.text = guestCount.toString();



    setState(() {}); // refresh UI after loading
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
  PrefsHelper.setInt("guestCount", guestCount);

  // FAQs
  for (int i = 0; i < controller.questionControllers.length; i++) {
    PrefsHelper.setString("faq_question_$i", controller.questionControllers[i].text);
    PrefsHelper.setString("faq_answer_$i", controller.answerControllers[i].text);
  }
Get.offAndToNamed(RoutesName.nav);
  Get.snackbar("Success".tr, "Draft saved!", backgroundColor: Colors.white, colorText: Colors.black);
}







  void handleEventTypeChange(int index, bool? value) {
    setState(() {
      selectedEventTypes[index] = value ?? false;
    });
  }

  void handleAdditionalServiceChange(int index, bool? value) {
    setState(() {
      selectedAdditionalServices[index] = value ?? false;
    });
  }

  void handlePriceRangeChange(String value) {
    setState(() {
      selectedPriceRange = value;
    });
  }

  void incrementGuestCount() {
    setState(() {
      guestCount++;
      controller.maxCountController.text = guestCount.toString();
    });
  }

  void decrementGuestCount() {
    setState(() {
      if (guestCount > 0) {
        guestCount--;
        controller.maxCountController.text = guestCount.toString();
      }
    });
  }


  void continuePage() {
    if (_formKey.currentState!.validate()) {


//  if (controller.selectedSupportedServices.isEmpty) {
//       Get.snackbar("Error".tr,"Please select at least one Supported Service",
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }
//     if (controller.selectedAdditionalServices.isEmpty) {
//       Get.snackbar("Error".tr,"Please select at least one Additional Service",
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }
if(controller.selectedProviderType.value.isEmpty) {
      Get.snackbar("Error".tr,"Please select a Provider Type",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
}
    if (controller.selectedPriceRange.value.isEmpty) {
      Get.snackbar("Error".tr,"Please select a Price Range",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (guestCount <= 0) {
      Get.snackbar("Error".tr,"Guest count must be greater than 0",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }



      widget.onContinue!();
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
                  AppString.stepServicesDetails,
                  style: styleForBoldText.copyWith(fontSize: 24.sp),
                ),
              if (widget.titleBool == false)
                Text(
                  AppString.servicesDetails,
                  style: styleForBoldText.copyWith(fontSize: 24.sp),
                ),
              SizedBox(height: 10.h),
              Text(
                '${AppString.whatDoesYourBusinessOffer}??',
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                AppString.providerType,
                style: styleForBoldText.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Obx(
                () => SizedBox(
                  height: 50,
                  child: DropdownButtonFormField<String>(
                    value:
                        controller.selectedProviderType.value.isNotEmpty
                            ? controller.selectedProviderType.value
                            : null, // 🧠 Only assign if it has a value
                    decoration: InputDecoration(
                      fillColor: AppColors.textFieldBg,
                      filled: true,
                      hintText: AppString.providerType,
                      hintStyle: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      
                    ),
                    items:
                        controller.providerList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["_id"],
                            child: Text(
                              item["name"],
                              style: styleForNormalText.copyWith(fontSize: 14.sp),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedProviderType.value = value;
                        log("Selected Provider ID: $value");
                      }
                    },
                     

                  ),
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                '${AppString.canNotFindProviderType}??',
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Stack(
                children: [
                  CustomTextField(
                    hintText: AppString.writeYourProviderType,
                    isSuffix: false,
                    controller: controller.findProviderController,
                  ),
                  Positioned(
                    right: 15.w,
                      top: 16.h,
                      child: InkWell(
                        onTap: (){
                          if(controller.findProviderController.text.isEmpty){
                            Get.snackbar("Warning", "please fill the field", backgroundColor: Colors.orange, colorText: Colors.white);
                          }else{
                            controller.postFindProvider();
                          }
                        },
                        child: Obx(
                          () {
                            if(controller.findProviverLoading.value){
                              return CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.primary,
                              child:CircularProgressIndicator()
                            );
                            }
                            return CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            );
                          }
                        ),
                      )
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.supportedServiceTypes,
                        style: styleForBoldText.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.primary,
                          height: 1.50.h,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.showSupportedServiceList.toggle(); // 🔄 toggle visibility
                        },
                        icon: Icon(
                          controller.showSupportedServiceList.value
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: AppColors.grey,
                          size: 24,
                        ),
                      )
                    ],
                  ),

                  if (controller.showSupportedServiceList.value)

                    Obx(() {
                      if (controller.supportedServiceList.isEmpty ||
                          controller.selectedSupportedStates.length !=
                              controller.supportedServiceList.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "No Data",
                            style: styleForBoldText.copyWith(
                              fontSize: 14.sp,
                              height: 1.40,
                              color: AppColors.darkGrey,
                              letterSpacing: 0.20,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: List.generate(controller.supportedServiceList.length, (index) {
                          final service = controller.supportedServiceList[index];
                          final serviceName = service['name'];

                          return CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            side: BorderSide(color: AppColors.primary),
                            title: Text(
                              serviceName,
                              style: styleForBoldText.copyWith(
                                fontSize: 14.sp,
                                height: 1.40,
                                color: AppColors.darkGrey,
                                letterSpacing: 0.20,
                              ),
                            ),
                            value: controller.selectedSupportedStates[index],
                            onChanged: (bool? value) {
                              controller.selectedSupportedStates[index] = value ?? false;

                              if (value == true) {
                                if (!controller.selectedSupportedServices.contains(serviceName)) {
                                  controller.selectedSupportedServices.add(serviceName);
                                }
                              } else {
                                controller.selectedSupportedServices.remove(serviceName);
                              }

                              log("Selected Services: ${controller.selectedSupportedServices}");
                            },
                          );
                        }),
                      );
                    }),
                ],
              )),




              SizedBox(height: 10.h),

              Text(
                '${AppString.canNotFindProviderType}??',
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Stack(
                children: [
                  CustomTextField(
                    hintText: AppString.writeYourProviderType,
                    isSuffix: false,
                    controller: controller.findSupportServiceController,
                  ),
                  Positioned(
                      right: 15.w,
                      top: 16.h,
                      child: InkWell(
                        onTap: (){
                          if(controller.findSupportServiceController.text.isEmpty){
                            Get.snackbar("Warning", "please fill the field", backgroundColor: Colors.orange, colorText: Colors.white);
                          }else{
                            controller.postFindSupportService();
                          }
                        },
                        child: Obx(
                          () {
                                 if(controller.findSupportLoading.value){
                              return CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.primary,
                              child:CircularProgressIndicator()
                            );
                            }
                            return CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            );
                          }
                        ),
                      )
                  )
                ],
              ),
              SizedBox(height: 20.h),

              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.additionalServices,
                        style: styleForBoldText.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.primary,
                          height: 1.50.h,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.showAdditionalServiceList.toggle(); // 🔄 toggle visibility
                        },
                        icon: Icon(
                          controller.showAdditionalServiceList.value
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: AppColors.grey,
                          size: 24,
                        ),
                      )
                    ],
                  ),

                  if (controller.showAdditionalServiceList.value)

                    Obx(() {
                      if (controller.additionalServiceList.isEmpty ||
                          controller.selectedAdditionalStates.length !=
                              controller.additionalServiceList.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "No Data",
                            style: styleForBoldText.copyWith(
                              fontSize: 14.sp,
                              height: 1.40,
                              color: AppColors.darkGrey,
                              letterSpacing: 0.20,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: List.generate(controller.additionalServiceList.length, (index) {
                          final service = controller.additionalServiceList[index];
                          final serviceName = service['name'];

                          return CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            side: BorderSide(color: AppColors.primary),
                            title: Text(
                              serviceName,
                              style: styleForBoldText.copyWith(
                                fontSize: 14.sp,
                                height: 1.40,
                                color: AppColors.darkGrey,
                                letterSpacing: 0.20,
                              ),
                            ),
                            value: controller.selectedAdditionalStates[index],
                            onChanged: (bool? value) {
                              controller.selectedAdditionalStates[index] = value ?? false;

                              if (value == true) {
                                if (!controller.selectedAdditionalServices.contains(serviceName)) {
                                  controller.selectedAdditionalServices.add(serviceName);
                                }
                              } else {
                                controller.selectedAdditionalServices.remove(serviceName);
                              }

                              log("Selected Services: ${controller.selectedAdditionalServices}");
                            },
                          );
                        }),
                      );
                    }),
                ],
              )),


               SizedBox(height: 10.h),
              Text(
                '${AppString.canNotFindProviderType}??',
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Stack(
                children: [
                  CustomTextField(
                    hintText: AppString.writeYourProviderType,
                    isSuffix: false,
                    controller: controller.findAdditionalServiceController,
                  ),
                  Positioned(
                      right: 15.w,
                      top: 16.h,
                      child: InkWell(
                        onTap: (){
                          if(controller.findAdditionalServiceController.text.isEmpty){
                            Get.snackbar("Warning", "please fill the field", backgroundColor: Colors.orange, colorText: Colors.white);
                          }else{
                            controller.postFindAdditionalService();
                          }
                        },
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      )
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                AppString.priceRange,
                style: styleForBoldText.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.primary,
                  height: 1.50.h,
                ),
              ),
              SizedBox(height: 10.h),

              Obx(() => Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: priceOptions.map((option) {
                  final label = option["label"]!;
                  final value = option["value"]!;
                  return ChoiceChip(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.grey, width: 0.3),
                    ),
                    label: Text(label),
                    selected: controller.selectedPriceRange.value == value,
                    onSelected: (selected) {
                      controller.handlePriceRangeChange(selected ? value : '');
                    },
                    checkmarkColor: Colors.white,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: controller.selectedPriceRange.value == value
                          ? Colors.white
                          : Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              )),

              SizedBox(height: 20.h),
              Text(
                AppString.maximumGuestCapacity,
                style: styleForBoldText.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.primary,
                  height: 1.50.h,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textFieldBg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      guestCount.toString(),
                      style: styleForNormalText.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: decrementGuestCount,
                          icon: Icon(
                            Icons.remove_circle,
                            color: AppColors.primary,
                          ),
                        ),
                        IconButton(
                          onPressed: incrementGuestCount,
                          icon: Icon(
                            Icons.add_circle_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
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
                              height: 1.40.h,
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
      ),
    );
  }
}
