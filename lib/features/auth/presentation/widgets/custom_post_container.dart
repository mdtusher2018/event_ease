// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPostContainer extends StatelessWidget {
   CustomPostContainer({super.key, this.onTap, this.onTapLike, this.onTapComment, this.isLiked = false, required this.title, required this.description, required this.name, required this.likeCount, required this.commentCount, required this.time, required this.profileImage});
   Function()? onTap;
   String title;
   String description;
   String name;
   String likeCount;
   String commentCount;
   String time;
   String profileImage;
   bool isLiked;
   Function()? onTapLike;
   Function()? onTapComment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 40,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
          border: Border.all(color: Colors.black, width: 0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [ CircleAvatar(
                  radius: 20,
                    child: CommonImage(imageSrc: profileImage, imageType: ImageType.network, borderRadius: 100,)
                ),
                SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: styleForBoldText.copyWith(color: Colors.black, fontSize: 14.sp),maxLines: 1,),
                        Text(time, style: styleForBoldText.copyWith(color: Colors.black, fontSize: 14.sp),maxLines: 1,),

                      ],
                    ),
                  ),
                ],),
                SizedBox(height: 8,),
            Text(title, style: styleForBoldText.copyWith(color: Colors.black,height: 1, fontSize: 16.sp),),
            SizedBox(height: 5.h,),
            Text(description, style: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),),
            SizedBox(height: 8.h,),
            Row(
              children: [
               
      
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                   
                    Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: onTapLike,
                                child: isLiked?Icon(Icons.favorite, color: Colors.red,size: 20.r,):Icon(Icons.favorite_border, color: Colors.black,size: 20.r,)),
                            SizedBox(width: 2,),
                            Text(likeCount, style: styleForNormalText.copyWith(fontWeight: FontWeight.w500, fontSize: 14.sp),)
                          ],
                        ),
                        SizedBox(width: 10,),
                        Row(
                          children: [
                            InkWell(
                                onTap: onTapComment,
                                child: SvgPicture.asset(AppIcons.commentIcon, color: Colors.black, height: 20.h, width: 20.w,)),
                            SizedBox(width: 2,),
                            Text(commentCount,style: styleForNormalText.copyWith(fontWeight: FontWeight.w500,fontSize: 14.sp)),
                            
                          ],
                        )
      
                      ],
                    )
                  ],
                )
              ],
            )
      
          ],
      
        ),
      ),
    );
  }
}
