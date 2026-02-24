// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/event_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/widgets/commonSubscriptionCardDesign.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/payment_selection_page.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/help_center/help_center_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/styles.dart';

class EventCardScreen extends StatelessWidget {
  EventCardScreen({super.key, required this.id, required this.eventName});

  String id;
  String eventName;
  final controller = Get.put(EventSubscriptionProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Event Card",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Choose the Level of Visibility You Want!".tr,
              style: styleForBoldText.copyWith(fontSize: 30.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              "The higher the package, the more visibility you get in search results."
                  .tr,
              style: styleForNormalText.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.50.h,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              "Event Card",
              style: styleForBoldText.copyWith(fontSize: 24.sp),
            ),
            Text(
              "Promote your Event profile in search result".tr,
              style: styleForNormalText.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.56.h,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.subscriptionPlans.isEmpty) {
                return SizedBox(
                  height: 480.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          size: 60.sp,
                          color: AppColors.purple,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Subscriptions Coming Soon",
                          style: styleForBoldText.copyWith(
                            fontSize: 22.sp,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            "Premium plans will be available in the next update.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                itemCount: controller.subscriptionPlans.length,
                itemBuilder: (context, index) {
                  final model = controller.subscriptionPlans[index];
                  return SubscriptionCard(
                    model: model,
                    selectButtonOnTap: () {
                      // Get.to(PaymentMethodScreen(amount: model.options.first.price.toDouble(),
                      // duration: model.options.first.expirationDays as int,
                      // subscriptionFor: id,
                      // subscriptionForType: "Event",subscriptionId: model.id,
                      // subscriptionOptionIndex: 0,
                      // subscriptionName: model.title,
                      // name: eventName,
                      // ));
                    },
                    onOptionTap: (i) {
                      Get.to(
                        PaymentMethodScreen(
                          amount: model.options[i].price.toDouble(),
                          duration: model.options[i].expirationDays as int,
                          subscriptionFor: id,
                          subscriptionForType: "Event",
                          subscriptionId: model.id,
                          subscriptionOptionIndex: i,
                          subscriptionName: model.title,
                          name: eventName,
                        ),
                      );
                    },
                    indexFonExpantion: index,
                  );
                },
              );
            }),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Want customized visibility?'.tr,
                    style: styleForNormalText.copyWith(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Add your navigation or action
                            Get.to(() => HelpCenterScreen(target: 1));
                          },
                        text: ' ${AppString.contactUs} ',
                        style: styleForBoldText.copyWith(
                          fontSize: 16.sp,
                          decoration: TextDecoration.underline,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: 'for a personalized package!'.tr,
                        style: styleForNormalText.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
