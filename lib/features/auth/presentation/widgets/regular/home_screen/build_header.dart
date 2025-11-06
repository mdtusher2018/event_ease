// ignore_for_file: must_be_immutable

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/controller/notification/notification_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/permission_handeler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import '../../common_image.dart';

class LocationController extends GetxController {
  RxString userAddress = "Fetching location...".obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserAddress();
  }

  Future<void> _fetchUserAddress() async {
    try {
      bool granted = await requestLocationPermission();
      if (!granted) {
        userAddress.value = "Permission Denied";
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        userAddress.value = "${place.street}, ${place.locality}, ${place.country}";
      } else {
        userAddress.value = "Location unavailable";
      }
    } catch (e) {
      userAddress.value = "Location unavailable";
    }
  }
}

class BuildHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final Function()? notificationOnPressed;

  BuildHeader({super.key, required this.globalKey, this.notificationOnPressed});

  final NotificationController notificationController = Get.find<NotificationController>();
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile picture & drawer
        GestureDetector(
          onTap: () {
            if (globalKey.currentState != null) {
              globalKey.currentState!.openDrawer();
            }
          },
          child: Container(
            height: 51.h,
            width: 51.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              shape: BoxShape.circle,
            ),
            child: CommonImage(
              imageSrc: PrefsHelper.myImage,
              imageType: ImageType.network,
              borderRadius: 100,
            ),
          ),
        ),
        SizedBox(width: 5.w),
        // Greeting & location
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppString.hello} ${PrefsHelper.myName}",
              style: styleForBoldText.copyWith(
                color: AppColors.darkGrey,
                fontSize: 18.sp,
                height: 1.56.h,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.location2,
                  height: 16.h,
                  width: 16.w,
                ),
                SizedBox(width: 5.w),
                SizedBox(
                  width: 260.w,
                  child: Obx(() {
                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            locationController.userAddress.value,
                            style: styleForNormalText.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      
                        ),
                        // Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        // Notification icon
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFE1E1E1), width: 0.77),
              boxShadow: [
                BoxShadow(
                  color: Colors.white70,
                  blurRadius: 1,
                  blurStyle: BlurStyle.solid,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: notificationOnPressed,
                  icon: SvgPicture.asset(AppIcons.notificationIcon),
                ),
                // 🔴 Notification dot
                Obx(() {
                  return notificationController.homePageNotification.value
                      ? Positioned(
                          right: 10,
                          top: 8,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : const SizedBox();
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
