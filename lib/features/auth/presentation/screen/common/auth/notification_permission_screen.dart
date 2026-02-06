import 'dart:developer';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/notification/permission_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/permission_handeler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPermissionScreen extends StatelessWidget {
  final String role;
  final String? parentBusiness;
  final PermissionController controller = Get.find<PermissionController>();

  NotificationPermissionScreen({
    super.key,
    required this.role,
    required this.parentBusiness,
  });

  void navigateAfterPermission() {
    // if (role == "organizer" && parentBusiness == null) {
    //   Get.toNamed(RoutesName.signUpStep);
    // } else {
      Get.offAllNamed(RoutesName.nav);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              CircleAvatar(
                backgroundColor: AppColors.textFieldBg,
                radius: 50.r,
                child: Icon(Icons.notifications, color: AppColors.primary, size: 40.r),
              ),
              SizedBox(height: 20.h),
              Text(
                AppString.stayUpdated,
                style: styleForBoldText.copyWith(fontSize: 32.sp, height: 1.2.h),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                AppString.enableNotificationServices,
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.33.h,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                "${AppString.enableNotificationsToReceive}!",
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  height: 1.5.h,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 230),

              Obx(() => CustomButton(
                text: AppString.enableNotification,
                isLoading: controller.isLoading.value,
                onTap: () async {
                  controller.enableNotification.value = true;
         await requestNotificationPermission();
                  navigateAfterPermission();
                  

               
                },
              )),

              SizedBox(height: 10.h),

              TextButton(
                onPressed: () async {
                  log("Latitude: ${controller.latitude.value}");
                  log("Longitude: ${controller.longitude.value}");
                  log("Address: ${controller.address.value}");
                  log("Notification Enabled: ${controller.enableNotification.value}");
                  await controller.completePermission();
                  navigateAfterPermission();
                },
                child: Text(
                  AppString.skip,
                  style: styleForNormalText.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }





}
