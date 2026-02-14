import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget buildActionButton({
  required Widget icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: icon,
    label: Text(label, style: styleForBoldText.copyWith(fontSize: 16.sp, color: Colors.white),),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
    ),
  );
}