import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoListTile extends StatelessWidget {
  const CustomInfoListTile({super.key, required this.icon, required this.title, required this.subTitle});
  final Widget icon;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // minVerticalPadding: 0,
      minTileHeight: 0,
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundColor: AppColors.textFieldBg,
          child: icon),
      title: Text(title, style: styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.darkGrey),),
      subtitle: Text(subTitle,style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.darkGrey)),
    );
  }
}
