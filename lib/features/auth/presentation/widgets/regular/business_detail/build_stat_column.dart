import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildStatColumn(String count, String label) {
  return Column(
    children: [
      Text(
          label,
          style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.grey)
      ),
      SizedBox(height: 5,),
      Text(
        count,
        style: styleForBoldText.copyWith(fontSize: 20.sp, color: AppColors.darkGrey)
      ),

    ],
  );
}