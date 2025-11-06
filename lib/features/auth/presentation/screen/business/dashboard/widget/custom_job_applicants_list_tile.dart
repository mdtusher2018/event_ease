// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_images.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';

class CustomJobApplicantsListTile extends StatelessWidget {
  CustomJobApplicantsListTile({super.key, this.name = "Marco"});
  String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CommonImage(imageSrc: AppImages.profileImage,imageType: ImageType.network, borderRadius: 100, size: 45,),
      title: Text(name, style: styleForBoldText.copyWith(color: Colors.black, fontSize: 19),),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary
        ),
        child: Text(AppString.viewCv, style: styleForBoldText.copyWith(fontSize: 16, color: Colors.white),),
      ),
    );
  }
}
