// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class GoToTheGuide extends StatelessWidget {
   GoToTheGuide({super.key, this.onPressed});

  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x191F2937),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),BoxShadow(
            color: Color(0x0F1F2937),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Color(0xfffef5ff),
              shape: BoxShape.circle
            ),
            child: CommonImage(
              imageSrc: AppIcons.essentialEvent,
              imageType: ImageType.svg,
              height: 50.h,
              width: 50.w,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.essentialsForEveryEvent,
                    style: styleForBoldText.copyWith(color: AppColors.darkGrey, fontSize: 17.sp, fontWeight: FontWeight.w500, ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    AppString.featuredEventSpecialistDetails,
                    style: styleForNormalText.copyWith(color: AppColors.grey, fontWeight: FontWeight.w500, fontSize: 13.sp, letterSpacing: 0.5, height: 1.3),
                    maxLines: 2, // Ensure it only takes up to 2 lines
                    overflow: TextOverflow.ellipsis, // Handle overflow gracefully with an ellipsis
                  ),
                  SizedBox(height: 8,),
                  InkWell(
                    onTap: onPressed,
                    child: Text(
                      AppString.goToTheGuide,
                      style: styleForBoldText.copyWith(fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(height: 5,)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
