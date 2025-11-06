// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../utils/styles.dart';
import '../../../custom_text_field.dart';
import '../../../regular/Custom_description_Text_field.dart';

class GeneralInformationSection extends StatelessWidget {
  final TextEditingController eventTitleController;
  final TextEditingController eventShortDescriptionController;
  final TextEditingController eventDetailedDescriptionController;
  String title;

   GeneralInformationSection({
    super.key,
    required this.eventTitleController,
    required this.eventShortDescriptionController,
    required this.eventDetailedDescriptionController,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleForBoldText.copyWith(fontSize:20)),
        const SizedBox(height: 10),
        Text(AppString.eventName, style: styleForBoldText.copyWith(fontSize: 16)),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.eventTitle,
          isSuffix: false,
          controller: eventTitleController,
        ),
        const SizedBox(height: 10),
        Text(AppString.shortDescription, style: styleForBoldText.copyWith(fontSize: 16)),
        const SizedBox(height: 5),
        CustomDescriptionTextField(
          hintText: AppString.shortDescription,
          controller: eventShortDescriptionController,
        ),
        const SizedBox(height: 10),
        Text(AppString.detailedDescription, style: styleForBoldText.copyWith(fontSize: 16)),
        const SizedBox(height: 5),
        CustomDescriptionTextField(
          hintText: AppString.detailedDescription,
          controller: eventDetailedDescriptionController,
        ),
      ],
    );
  }
}