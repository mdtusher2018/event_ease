// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/styles.dart';
import '../../../custom_text_field.dart';

class SocialNetworkSection extends StatelessWidget {
  final TextEditingController facebookController;
  final TextEditingController instagramController;
  final TextEditingController twitterController;
  final TextEditingController tiktokController;
  String title;

   SocialNetworkSection({
    super.key,
    required this.facebookController,
    required this.instagramController,
    required this.twitterController,
    required this.tiktokController,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        const SizedBox(height: 10),
        Text(
            AppString.facebook,
            style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
        ),
        SizedBox(height: 5.h,),
        CustomTextField(
          hintText: AppString.facebook,
          isSuffix: false,
          controller: facebookController,
        ),
        SizedBox(height: 10.h),
        // Short Description Field
        Text(
            AppString.instagram,
            style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
        ),
        SizedBox(height: 5.h,),
        CustomTextField(
          hintText: AppString.instagram,
          isSuffix: false,
          controller: instagramController,
        ),
        SizedBox(height: 10.h,),
        Text(
            AppString.twitter,
            style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
        ),
        SizedBox(height: 5.h,),
        // Detailed Description Field
        CustomTextField(
          hintText: AppString.twitter,
          isSuffix: false,
          controller: twitterController,
        ),
        SizedBox(height: 10.h,),
        Text(
            AppString.tikTok,
            style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
        ),
        SizedBox(height: 5.h,),
        // Detailed Description Field
        CustomTextField(
          hintText: AppString.tikTok,
          isSuffix: false,
          controller: tiktokController,
        ),


      ],
    );
  }
}