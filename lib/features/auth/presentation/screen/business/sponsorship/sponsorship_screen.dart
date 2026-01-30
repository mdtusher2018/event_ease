// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/my_subscription_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/sponsorship_business_page.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/sponsorship_event_page.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/sponsorship_job_page.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SponsorshipScreen extends StatefulWidget {
  SponsorshipScreen({super.key});

  @override
  State<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends State<SponsorshipScreen> {
  MySubscriptionController controller = Get.put(MySubscriptionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadParentBusinessId();
  }

  RxString parentBusinessId = "".obs;

  void loadParentBusinessId() async {
    parentBusinessId.value = await PrefsHelper.getParentBusinessId() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.sponsorship,
          style: styleForBoldText.copyWith(fontSize: 23),
        ),
      ),
      body: Obx(() {
        if (parentBusinessId.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Create Your 1st business to access the Sponsorship".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Get.toNamed(RoutesName.signUpStep);
                    },
                    child: Text(
                      "Complete Profile".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Text(
                "${AppString.boostYourBusinessVisibility}!",
                style: styleForBoldText.copyWith(fontSize: 24.sp, height: 1.27),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                "${AppString.highlightYourProfile}.",
                style: styleForNormalText.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.50.h,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              // Container(
              //   height: 242,
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(color: Colors.grey, width: 0.5),
              //   ),
              //   child: Center(
              //     child: CircleAvatar(
              //       radius: 18,
              //       backgroundColor: AppColors.primary,
              //       child: Icon(Icons.play_arrow, color: Colors.white),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
              Text(
                "${AppString.stepWhatDoYouWantToPromote}?",
                style: styleForBoldText.copyWith(fontSize: 24.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Get.to(SponsorshipBusinessPage());
                  // Get.toNamed(RoutesName.businessProfileCardScreen);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.businessIcon),
                      SizedBox(height: 10.h),
                      Text(
                        AppString.profile,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        AppString.showcaseYourBusinessProfile,
                        style: styleForNormalText.copyWith(fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Get.to(SponsorshipEventPage());
                  // Get.toNamed(RoutesName.eventCardScreen);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.eventIcon),
                      SizedBox(height: 10.h),
                      Text(
                        AppString.event,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "${AppString.promoteYourUpcomingEventsToIncreaseAttendance}.",
                        style: styleForNormalText.copyWith(fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Get.to(SponsorshipJobPage());
                  // Get.toNamed(RoutesName.jobCardScreen);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.jobIcon),
                      SizedBox(height: 10.h),
                      Text(
                        AppString.job,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${AppString.attractTalentByPromotingYourOpenPositions}.",
                        style: styleForNormalText.copyWith(fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  AppString.purchasedPack,
                  style: styleForBoldText.copyWith(fontSize: 24.sp),
                ),
              ),

              Obx(() {
                if (controller.subscriptions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: Text(
                        "No Purchased Pack Found",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscriptionWrapper = controller.subscriptions[index];
                    final subscription = subscriptionWrapper.subscription;
                    final option =
                        subscription.options[subscriptionWrapper
                            .subscriptionOptionIndex];
                    //  ${remainingCredits.toStringAsFixed(2)}
                    String footerText =
                        (subscriptionWrapper.status == "notActivate")
                            ? "The pack must be activated within ${option.refoundDays.toInt()} days; otherwise, it will be removed, and the amount will be converted into advertising credits."
                            : "By blocking the pack, the remaining amount will be converted into advertising credits. You will receive ${subscriptionWrapper.potentialCredits.toStringAsFixed(2)} credits.";

                    return SubscriptionCard(
                      businessName: subscriptionWrapper.subscriptionFor.name,
                      title: subscription.title,
                      subtitle: subscription.subTitle,
                      features: subscription.feature,
                      buttonText:
                          (subscriptionWrapper.status == "notActivate")
                              ? "Activate"
                              : (subscriptionWrapper.status == "activate")
                              ? "Stop"
                              : "Got Credits",
                      controller: controller,
                      onButtonPressed: () {
                        final id = subscriptionWrapper.id;

                        if (subscriptionWrapper.status == "notActivate") {
                          controller.activateSubscription(id);
                        } else if (subscriptionWrapper.status == "activate") {
                          controller.stopSubscription(id);
                        } else {
                          log(
                            "No API call needed (status: ${subscriptionWrapper.status})",
                          );
                          Get.snackbar(
                            "Info",
                            "No action required. Subscription already stopped or converted to credits.",
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                        }
                      },
                      footerNote: footerText,
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String businessName;
  final List<String> features;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String footerNote;
  final MySubscriptionController controller;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.businessName,
    required this.subtitle,
    required this.features,
    required this.buttonText,
    required this.onButtonPressed,
    required this.footerNote,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    businessName,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: styleForBoldText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 24.sp,
                ),
              ),

              /// Subtitle
              Text(
                subtitle,
                style: styleForNormalText.copyWith(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),

              SizedBox(height: 10.h),

              /// Features Heading
              Text(
                "Package Includes:",
                style: styleForBoldText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 18.sp,
                ),
              ),

              SizedBox(height: 10.h),

              /// Features List
              ...features.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    "• $item",
                    style: styleForNormalText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.56.h,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              /// Button
              Obx(() {
                return CustomButton(
                  text: buttonText,
                  borderRadius: 12.r,
                  isLoading: controller.buttonLoading.value,
                  onTap: onButtonPressed,
                );
              }),

              SizedBox(height: 10.h),

              /// Footer Note
              Text(
                footerNote,
                style: styleForNormalText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
