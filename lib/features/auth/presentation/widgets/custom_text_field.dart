// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/styles.dart';

class CustomTextField extends StatefulWidget {
   CustomTextField({
    super.key,
    required this.hintText,
    required this.isSuffix,
    this.prefixIcon,
    this.backgroundColor = AppColors.textFieldBg,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.contentPadding = 20,
    this.borderRadius = 12,
    this.maxLine = 1,
    this.enabled,
  });

  final String hintText;
  final double contentPadding;
  final int maxLine;
  final double borderRadius;
  final TextInputType keyboardType;
  final bool isSuffix;
  final String? prefixIcon;
  final TextEditingController controller;
  final Color backgroundColor;
  final FormFieldValidator? validator;
  bool? enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLine,
      style: styleForNormalText.copyWith(color: Colors.black, fontSize: 16.sp),
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      obscureText: widget.isSuffix ? !passwordVisible : false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(widget.contentPadding.h),
        prefixIcon: widget.prefixIcon != null?Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: SizedBox(
            height: 16.h,
            width: 16.w,
            child: CommonImage(
              imageSrc: widget.prefixIcon!,
              imageType: ImageType.svg,
            ),
          ),
        ):null,
        suffixIcon:
            widget.isSuffix
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon:
                      !passwordVisible
                          ? Icon(
                            Icons.visibility_off,
                            color: AppColors.grey,
                            size: 20.r,
                          )
                          : Icon(
                            Icons.visibility,
                            color: AppColors.grey,
                            size: 20.r,
                          ),
                )
                : null,
        filled: true,
        fillColor: widget.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: widget.hintText,
        hintStyle: styleForNormalText.copyWith(
          color: AppColors.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
