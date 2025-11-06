// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/styles.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    this.isLoading=false,
    this.paddingVertical,
    this.onTap,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.borderColor = AppColors.primary,
    this.borderRadius = 100,
    this.fontSize = 20,
    this.height = 60,
  });
  final String text;
  final bool isLoading;
  final double? paddingVertical;
  final double height;
  final double borderRadius;
  final double fontSize;
  final Function()? onTap;
  // Gradient? backgroundColor ;
  Color? backgroundColor ;
  Color? textColor ;
  Color? borderColor;

  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(isLoading)? null: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: paddingVertical?? 11),
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          // gradient: backgroundColor,
          color: backgroundColor,
          border: Border.all(color: borderColor!, width: 1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child:
              isLoading == true
                  ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(),
                  )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: styleForBoldText.copyWith(color: textColor, fontSize: fontSize.sp, height: 1.40, letterSpacing: 0.20),
                      ),
                      if(icon != null)
                        SizedBox(width: 3,),
                      if(icon != null)
                        Icon(icon, color: Colors.white,)
                    ],
                  ),
        ),
      ),
    );
  }
}
