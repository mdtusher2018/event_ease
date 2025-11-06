import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';

class CustomDrawerListTile extends StatelessWidget {
  const CustomDrawerListTile({
    super.key,
    this.leadingIcon,
    required this.title,
    required this.onTabFunction,
  });
  final String title;
  final String? leadingIcon;
  final VoidCallback onTabFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTabFunction,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Row(
          children: [
            SvgPicture.asset(leadingIcon ?? '',height: 26.h, width: 26.w),
            SizedBox(width: 20.w,),
            Text(
              title,
              style: styleForBoldText.copyWith(
                fontSize: 18.sp,
                color: AppColors.darkGrey,
                height: 1.50.h,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );

    //   ListTile(
    //   leading: leadingIcon,
    //   title: Text(
    //     title,
    //     style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.darkGrey,height: 1.50.h),
    //   ),
    //   trailing: Icon(
    //     Icons.arrow_forward_ios_outlined,
    //     color: AppColors.primary,
    //     size: 16,
    //   ),
    //   onTap: onTabFunction,
    // );
  }
}
