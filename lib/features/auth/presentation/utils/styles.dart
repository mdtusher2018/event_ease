import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get styleForBoldText {
  // final ColorController colorController = Get.find<ColorController>(); // Access the controller
  return GoogleFonts.outfit(
    color: AppColors.primary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    height: 1.5.h,
    letterSpacing: 0.2,
  );
}

TextStyle get styleForNormalText {
  return GoogleFonts.outfit(
    color: AppColors.darkGrey,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    height: 1.33.h,
    letterSpacing: 0.5,
  );
}
