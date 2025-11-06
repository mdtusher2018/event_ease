// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';

class LearnMoreButton extends StatelessWidget {
  LearnMoreButton({super.key, this.onTap});
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,  // Center horizontally
          children: [
            Text(
              AppString.learnMore,
              style: styleForBoldText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.darkGrey,
                  height: 1.50),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(AppIcons.rightArrowIcon, height: 20.h,width: 20.w,),
          ],
        ),
      ),
    );
  }
}
