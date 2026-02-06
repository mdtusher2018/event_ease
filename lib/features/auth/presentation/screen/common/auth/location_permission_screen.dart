import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/notification/permission_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/auth/notification_permission_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/permission_handeler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatelessWidget {
  final String? parentBusiness;
  final PermissionController controller = Get.find<PermissionController>();

  LocationPermissionScreen({Key? key, this.parentBusiness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Token: ${PrefsHelper.token}");
    final String role = PrefsHelper.myRole;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              CircleAvatar(
                backgroundColor: AppColors.textFieldBg,
                radius: 50.r,
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 40.r,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                AppString.findEventsNearYou,
                style: styleForBoldText.copyWith(
                  fontSize: 32.sp,
                  height: 1.2.h,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                AppString.enableLocationServices,
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
                "${AppString.wantToFindTheBestEvents}!",
                style: styleForNormalText.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  height: 1.5.h,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 270),

              Obx(
                () => CustomButton(
                  text: AppString.allowLocationAccess,
                  isLoading: controller.isLoading.value,
                  onTap: () async {
                    controller.isLoading.value = true;

                    await controller.getCurrentLocation();
                    controller.isLoading.value = false;

                    log("Latitude: ${controller.latitude.value}");
                    log("Longitude: ${controller.longitude.value}");
                    log("Address: ${controller.address.value}");

                    if (!(await requestLocationPermission())) {
                      await openAppSettings();
                    } else if (await Permission.notification.isGranted) {
                      Get.offAllNamed(RoutesName.nav);
                    } else {
                      Get.to(
                        () => NotificationPermissionScreen(
                          role: role,
                          parentBusiness: parentBusiness,
                        ),
                      );
                    }

                    controller.isLoading.value = false;
                  },
                ),
              ),

              SizedBox(height: 10.h),

              TextButton(
                onPressed: () async {
                  if (await Permission.notification.isGranted) {
                    Get.offAllNamed(RoutesName.nav);
                  } else {
                    Get.to(
                      () => NotificationPermissionScreen(
                        role: role,
                        parentBusiness: parentBusiness,
                      ),
                    );
                  }
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
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
