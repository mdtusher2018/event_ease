// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/styles.dart';
import '../../common_image.dart';

class CustomIdeaContainer extends StatelessWidget {
  CustomIdeaContainer({
    super.key,
    this.imageWidth = double.infinity,
    this.onTap,
    required this.title,
    required this.description,
    required this.image,
    this.authorImage="",
    this.authorName="",
    this.createDate="",
    this.createTime=""
  });
  double imageWidth;
  void Function()? onTap;
  String description;
  String title;
  String image;
  String authorImage;
  String authorName;
  String createDate;
  String createTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: imageWidth,
        padding: EdgeInsets.all(5),
        // decoration: BoxDecoration(
        //     border: Border.all(color: Colors.grey,width: 0.3)
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: CommonImage(
                imageSrc: image,
                imageType: ImageType.network,
                height: 209,
                width: double.infinity,fill: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styleForBoldText.copyWith(
                color: AppColors.darkGrey,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 4,),
       Row(
  children: [
   if(authorImage.isNotEmpty) CircleAvatar(
      backgroundImage: NetworkImage(authorImage),
      radius: 12, // responsive radius
    ),
   if(authorImage.isNotEmpty) SizedBox(width: 6),

    // Author Name
   if(authorName.isNotEmpty) Flexible(
      child: Text(
        authorName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12, // responsive font
          color: Colors.black
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // prevent overflow
      ),
    ),

    if(authorName.isNotEmpty) SizedBox(width: 8),
     if(authorName.isNotEmpty)Text(
      "•",
      style: TextStyle(
        fontWeight: FontWeight.bold,

        fontSize: 18, // responsive dot
       color: Colors.black// subtle dot like social apps
      ),
    ),
     if(authorName.isNotEmpty)SizedBox(width: 8),

    // Date
    if(createDate.isNotEmpty) Text(
      createDate,
      style: TextStyle(
     
        fontSize: 12,
        color: Colors.black
      ),
    ),

    SizedBox(width: 8),
      if(createDate.isNotEmpty)  Text(
      "•",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black
      ),
    ),
      if(createDate.isNotEmpty)  SizedBox(width: 8),

    // Time
      if(createTime.isNotEmpty)  Text(
      createTime,
      style: TextStyle(
       
        color: Colors.black,
        fontSize: 12,
      ),
    ),
  ],
),

            SizedBox(height: 5),
            Text(
              description,
              maxLines: 2,overflow: TextOverflow.ellipsis,
              style: styleForNormalText.copyWith(
                color: AppColors.darkGrey,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
