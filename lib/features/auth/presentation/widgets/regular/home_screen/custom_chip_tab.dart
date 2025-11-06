// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChipTab extends StatelessWidget {
   CustomChipTab({super.key,
     this.backgroundColor = AppColors.primary, this.title = "New Post",
     this.textColor = Colors.white,
     this.onTap,
     this.isClick = false

   });

  Color backgroundColor;
  Color textColor;
  String title;
  bool isClick;
   Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        padding: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.primary),
        ),
        backgroundColor: isClick == true? AppColors.primary : backgroundColor,
        label: Text(
          title,
          style: styleForNormalText.copyWith(color: isClick == true? AppColors.white:textColor, fontWeight: FontWeight.w600, fontSize: 14.sp),
        ),
      ),
    );
  }
}
