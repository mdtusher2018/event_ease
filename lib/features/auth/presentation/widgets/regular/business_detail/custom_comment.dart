// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomComment extends StatelessWidget {
   CustomComment({super.key,  this.name="",  this.comment="",  this.profilePicture=""});

  String name ;
  String comment ;
  String profilePicture ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.r),
            border: Border.all(color: Colors.grey, width: 0.5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
          children: [
            CommonImage(imageSrc: profilePicture, imageType: ImageType.network, borderRadius: 50.r, height: 40.h,width: 40.w,),
            SizedBox(width: 5.w,),
            Text(name, style: styleForNormalText.copyWith(color: AppColors.darkGrey, fontSize: 18.sp, fontWeight: FontWeight.w500),),
            ],
        ),
          Text(comment, style: styleForNormalText.copyWith(color: AppColors.darkGrey, fontWeight: FontWeight.w400, fontSize: 20.sp,height: 1.50.h),),

        ],
      ),
    );
  }
}
