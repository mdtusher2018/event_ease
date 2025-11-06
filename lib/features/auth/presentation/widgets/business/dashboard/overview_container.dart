
// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OverviewContainer extends StatelessWidget {
   OverviewContainer({super.key,
   this.icon = const Icon(Icons.person, color: AppColors.primary,),
     this.title = "Followers",
     this.totalNumber = "1234",
    //  this.day = "+10 today"
   });
  Widget icon;
  String title;
  String totalNumber;
  // String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.4),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24.r,
            child: icon,
          ),
          SizedBox(height: 10,),
          Text(title, style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.grey, height: 1.50.h,),),
          SizedBox(height: 10,),
          Text(totalNumber, style: styleForBoldText.copyWith(fontSize: 24.sp),maxLines: 1,overflow: TextOverflow.ellipsis,),
          // SizedBox(height: 10,),
          // Text(day,style: styleForNormalText.copyWith(fontSize: 12.sp, color: AppColors.grey))
        ],
      ),
    );
  }
}
