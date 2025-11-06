// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/helper/other_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../custom_text_field.dart';

class ContactInformationSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController websiteController;
  String title;

   ContactInformationSection({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.websiteController,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleForBoldText),
        const SizedBox(height: 10),
        Text(
          '${AppString.email} (Optional)',
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.email,
          isSuffix: false,
          controller: emailController,
          validator: (value) => OtherHelper.validator(value),
        ),
        const SizedBox(height: 10),
        Text(
          '${AppString.phoneNumber} (Optional)',
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.phoneNumber,
          keyboardType: TextInputType.phone,
          isSuffix: false,
          controller: phoneController,
          validator: (value) => OtherHelper.validator(value),
        ),
        const SizedBox(height: 10),
        Text(
          AppString.website,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.website,
          isSuffix: false,
          controller: websiteController,
        ),
      ],
    );
  }
}