// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/styles.dart';

class CustomDescriptionTextField extends StatelessWidget {
  CustomDescriptionTextField({super.key, required this.hintText, required this.controller, this.validator});
  String hintText;
  TextEditingController controller;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: 3, // Keeping the maxLines from the original
      style: styleForNormalText.copyWith(
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: AppColors.textFieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: hintText,
        hintStyle: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 14.sp, fontWeight: FontWeight.w400),
      ),
    );
  }
}