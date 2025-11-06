import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentageRing extends StatelessWidget {
  final double percentage; // from 0 to 100
  final double size;
  final Color progressColor;
  final Color backgroundColor;

  const PercentageRing({
    super.key,
    required this.percentage,
    this.size = 121,
    this.progressColor = const Color(0xff6A0DAD), // purple
    this.backgroundColor = const Color(0xFFC79FD8), // lighter purple
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              color: backgroundColor,
            ),
          ),
          // Foreground progress arc
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 8,
              color: progressColor,
              backgroundColor: Colors.transparent,
            ),
          ),
          // Centered percentage text
          Text(
            "${percentage.toInt()}%",
            style: styleForBoldText.copyWith(
              color: AppColors.darkGrey,
              fontSize: 30.sp,
              height: 1.27.h,
            ),
          ),
        ],
      ),
    );
  }
}
