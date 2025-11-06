import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.onPressedSuffix,
    this.readOnly = false,
    this.onTap,
    required this.hintText,
    required this.controller,
    this.onChanged
  });

  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final TextEditingController controller;
  final Function()? onPressedSuffix;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58.h, // Fixed height to control vertical centering
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Color(0xFFD8DCE0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 16,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center( // Center the child vertically within the Container
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: TextFormField(
            onChanged: onChanged,
            style: styleForNormalText.copyWith(color: AppColors.darkGrey, fontSize: 16),
            keyboardType: keyboardType,
            controller: controller,
            validator: validator,
            cursorColor: Colors.black,
            readOnly: readOnly,
            onTap: onTap,
            textAlign: TextAlign.left, // Reset to left for horizontal alignment
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 21.5.h), // Adjust vertical padding
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon != null
                  ? InkWell(
                onTap: onPressedSuffix,
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Center(child: suffixIcon),
                    ),
                  )
                  : null,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: styleForBoldText.copyWith(
                fontSize: 14.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}