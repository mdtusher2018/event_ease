import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/my_subscription_history.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/delete_profile.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/ticket%20get%20section/ticket_archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/helper/logout_helper.dart';
import 'custom_drawer_list_tile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.only(
                top: 40.h,
                left: 15,
                right: 15,
                bottom: 30.h,
              ),
              //width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 61.h,
                    width: 61.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CommonImage(
                      imageSrc: PrefsHelper.myImage,
                      imageType: ImageType.network,
                      height: 61.h,
                      fill: BoxFit.cover,
                      width: 61.w,
                      borderRadius: 50.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PrefsHelper.myName,
                        style: styleForBoldText.copyWith(fontSize: 20.sp),
                      ),
                      Text(
                        PrefsHelper.myRole,
                        style: styleForBoldText.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomDrawerListTile(
              leadingIcon: AppIcons.profileIcon,
              title: AppString.editProfile,
              onTabFunction: () {
                Get.toNamed(RoutesName.editProfile);
              },
            ),
            Divider(),
            if (PrefsHelper.myRole == "organizer")
              CustomDrawerListTile(
                leadingIcon: AppIcons.job,
                title: AppString.businessProfile,
                onTabFunction: () {
                  Get.toNamed(RoutesName.businessProfile);
                },
              ),
            if (PrefsHelper.myRole == "organizer") Divider(),
            CustomDrawerListTile(
              leadingIcon: AppIcons.passwordIcon,
              title: AppString.changePassword,
              onTabFunction: () {
                Get.toNamed(RoutesName.changePassword);
              },
            ),
            Divider(),
            if (PrefsHelper.myRole == "organizer")
              CustomDrawerListTile(
                leadingIcon: AppIcons.sponsorshipIcon,
                title: AppString.sponsorship,
                onTabFunction: () {
                  Get.toNamed(RoutesName.sponsorshipScreen);
                },
              ),
            if (PrefsHelper.myRole == "organizer") Divider(),

            CustomDrawerListTile(
              leadingIcon: AppIcons.language,
              title: AppString.language,
              onTabFunction: () {
                Get.toNamed(RoutesName.language);
              },
            ),
            Divider(),
            // if (PrefsHelper.myRole == "user")
              CustomDrawerListTile(
                leadingIcon: AppIcons.referralsIcon,
                title: AppString.myReferrals,
                onTabFunction: () {
                  Get.toNamed(RoutesName.myReferralsScreen);
                },
              ),
            // if (PrefsHelper.myRole == "user") 
            Divider(),
            // if (PrefsHelper.myRole == "user")
              CustomDrawerListTile(
                leadingIcon: AppIcons.job,
                title: AppString.job,
                onTabFunction: () {
                  Get.toNamed(RoutesName.job);
                },
              ),
            // if (PrefsHelper.myRole == "user") 
            Divider(),

            CustomDrawerListTile(
              leadingIcon: AppIcons.support,
              title: "Tickets Archive".tr,
              onTabFunction: () {
                Get.to(TicketArchivePage());
              },
            ),
            Divider(),

            CustomDrawerListTile(
              leadingIcon: AppIcons.helpCenterIcon,
              title: AppString.helpCenter,
              onTabFunction: () {
                Get.toNamed(RoutesName.helpCenter);
              },
            ),
            Divider(),
            CustomDrawerListTile(
              leadingIcon: AppIcons.termServiceIcon,
              title: AppString.termsOfService,
              onTabFunction: () {
                Get.toNamed(RoutesName.termsOfService);
              },
            ),
            Divider(),
            CustomDrawerListTile(
              leadingIcon: AppIcons.privacyPolicyIcon,
              title: AppString.privacyPolicy,
              onTabFunction: () {
                Get.toNamed(RoutesName.privacyPolicy);
              },
            ),     
            if (PrefsHelper.myRole == "organizer")Divider(),
              if (PrefsHelper.myRole == "organizer")   CustomDrawerListTile(
              leadingIcon: AppIcons.sponsorshipIcon,
              title: "My Subscription".tr,
              onTabFunction: () {
                Get.to(MySubscriptionHistoryScreen());
              },
            ),
            Divider(),
            CustomDrawerListTile(title: "Delete Account".tr, 
              leadingIcon: "assets/icons/delete.svg",
            onTabFunction: (){
              Get.to(DeleteProfilePage());
            }),
  Divider(),
            ListTile(
              leading: SvgPicture.asset(
                AppIcons.logoutIcon,
                height: 26.h,
                width: 26.w,
              ),
              title: Text(
                AppString.logout,
                style: styleForBoldText.copyWith(
                  fontSize: 18.sp,
                  color: Colors.red,
                  height: 1.50,
                ),
              ),
              onTap: () async {
                // Pass route name string, not result of navigation
                LogoutHelper.logoutUser(
                  routeName: RoutesName.role,
                ); // <-- no await or Get.offAllNamed here
                log(">>>>>>> log out ==========");
                //LogoutHelper.logoutUser(confirm: false);
              },
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SvgPicture.asset(
                    AppIcons.instagramIcon,
                    height: 22.h,
                    width: 22.w,
                  ),
                ),
                SizedBox(width: 10.w),
                ClipOval(
                  child: SvgPicture.asset(
                    AppIcons.facebookIcon,
                    height: 22.h,
                    width: 22.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Text(
              "${AppString.version} 1.0",
              style: styleForBoldText.copyWith(
                color: AppColors.grey,
                fontSize: 14.sp,
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
