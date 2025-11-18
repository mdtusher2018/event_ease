import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/Guest/guest_home_page.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/helper/prefs_helper.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Center(
          // Center the entire content
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center, // Center the column content vertically
            crossAxisAlignment:
                CrossAxisAlignment
                    .center, // Center the column content horizontally
            children: [
              Text(
                "${AppString.welcomeTo} PianoFesta",
                style: styleForBoldText.copyWith(fontSize: 48.sp, height: 0.99),
                textAlign: TextAlign.center, // Center align text
              ),
              SizedBox(height: 30),
              Text(
                "${AppString.areYouRegisteringAsBusiness}?",
                style: styleForNormalText.copyWith(
                  fontSize: 24.sp,
                  height: 1.33.h,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center, // Center align text
              ),
              SizedBox(height: 60),
              CustomButton(
                text: AppString.regularProfile,
                onTap: () async {
                  PrefsHelper.myRole = "user";
                  await PrefsHelper.setString("myRole", PrefsHelper.myRole);
                  Get.toNamed(RoutesName.signIn);
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: AppString.businessProfile,
                onTap: () async {
                  PrefsHelper.myRole = "organizer";
                  await PrefsHelper.setString("myRole", PrefsHelper.myRole);
                  Get.toNamed(RoutesName.signIn);
                },
              ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Continue as a ",
                      style: styleForBoldText.copyWith(
                        color: AppColors.primary.withOpacity(0.8),
                        height: 1.40,
                        letterSpacing: 0.2,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: "Guest",
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(GuestHomeScreen());
                            },
                      style: styleForBoldText.copyWith(
                        color: AppColors.primary,
                        height: 1.40,
                        letterSpacing: 0.2,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
