import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class GuideScreen extends StatelessWidget {
  GuideScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  Widget _buildGuideItem({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        height: 57.h,
        width: 57.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          // border: Border.all(color: Colors.grey, width: 0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]
        ),

        child: Center(
          child: CommonImage(
            imageSrc: iconPath,
            imageType: ImageType.svg,
            height: 24,
            width: 24,
          ),
        ),
      ),
      title: Text(
        title,
        style: styleForNormalText.copyWith(
          fontSize: 14.sp,
          height: 1.5.h,
          fontWeight: FontWeight.w700,
        ),
      ),

      subtitle: Column(
        children: [
          SizedBox(height: 5,),
          Text(
            subtitle,
            style: styleForNormalText.copyWith(
              fontSize: 14.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
              height: 1.2
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.guide,
          style: styleForBoldText.copyWith(color: AppColors.primary, fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(color: AppColors.primary, width: 61, height: 2),
                  SizedBox(width: 2.w),
                  Text(
                    AppString.eventTips,
                    style: styleForNormalText.copyWith(color: AppColors.darkGrey, fontSize: 18.sp),
                  ),
                  SizedBox(width: 2.w),
                  Container(color: AppColors.primary, width: 61, height: 2),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              AppString.essentialsForEveryEvent,
              style: styleForBoldText.copyWith(fontSize: 24.sp),
            ),
            SizedBox(height: 10),
            Text(
              "${AppString.letUsGuideYouToAPerfectEvent}!",
              style: styleForNormalText.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            _buildGuideItem(
              iconPath: AppIcons.locationIcon,
              title: AppString.location,
              subtitle: AppString.discoverThePerfectSetting),
            SizedBox(height: 10),
            _buildGuideItem(
              iconPath: AppIcons.foodIcon,
              title: AppString.foodBeverage,
              subtitle:AppString.delightYourGuests
            ),
            SizedBox(height: 10),
            _buildGuideItem(
              iconPath: AppIcons.setupIcon,
              title: AppString.setups,
              subtitle: AppString.setTheMood,
            ),
            SizedBox(height: 10),
            _buildGuideItem(
              iconPath: AppIcons.cameraIcon,
              title: AppString.photosVideos,
              subtitle: AppString.captureEveryMoment,
            ),
            SizedBox(height: 10),
            _buildGuideItem(
              iconPath: AppIcons.musicVibeIcon,
              title: AppString.animationMusic,
              subtitle: AppString.provideHighQuality,
            ),
            SizedBox(height: 10),
            _buildGuideItem(
              iconPath: AppIcons.giftBoxIcon,
              title: AppString.gadgetPartyKit,
              subtitle: AppString.addPersonal,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              borderRadius: 12.r,
              fontSize: 22.sp,
              text: AppString.createChecklist,
              onTap: () {
                NavScreen.selectedIndex = 1;
                Get.offAllNamed(RoutesName.nav, arguments: {'tab': NavScreen.selectedIndex});
              },
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "${AppString.havenNotDecidedYet}?",
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              AppString.doNotWorry,
              style: styleForNormalText.copyWith(
                fontSize: 20.sp,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w500,
                height: 1.50.h,
              ),
            ),
            SizedBox(height: 10.h),
            CustomSearchField(
              hintText: "${AppString.whatAreYouLookingFor}?",
              prefixIcon: SizedBox(
                width: 18.w,
                height: 18.h,
                child: Center(child: SvgPicture.asset(AppIcons.searchIcon, height: 18.h, width: 18.w)),
              ),
              suffixIcon: CommonImage(imageSrc: AppIcons.filterIcon, imageType: ImageType.svg, height: 18.h, width: 18.w),
              controller: searchController,
              readOnly: true,
              onTap: () {
                Get.toNamed(RoutesName.search);
              },
              onPressedSuffix: () {
                Get.toNamed(RoutesName.filter);
              },
            ),

            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }
}
