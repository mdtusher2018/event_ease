import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewShowWidget extends StatelessWidget {
  final String name, profileImage, comment;
  final num ratting;

  const ReviewShowWidget({
    super.key,
    required this.comment,
    required this.name,
    required this.profileImage,
    required this.ratting,
  });

  @override
  Widget build(BuildContext context) {
    log(profileImage);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Header
          Row(
            children: [
              // Profile Image
              CommonImage(
                imageSrc: profileImage, // Replace with the actual image source
                height: 30.h,
                width: 30.w,
                borderRadius: 50.r, // Circular profile image
                imageType: ImageType.network,
              ),
              SizedBox(width: 10),
              // Name Text
              Text(
                name, // Replace with the actual name
                style: styleForBoldText.copyWith(
                  color: AppColors.grey,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),

          // Rating Bar
          RatingBar.builder(
            initialRating: ratting.toDouble(), // Set initial rating
            minRating: 1, // Minimum rating value
            itemSize: 24.r, // Size of each star
            direction: Axis.horizontal,
            allowHalfRating: true, // Allow half ratings
            ignoreGestures: true, // Prevent user from changing rating
            itemCount: 5, // Total number of stars
            itemPadding: EdgeInsets.symmetric(
              horizontal: 4.0,
            ), // Space between stars
            itemBuilder:
                (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange, // Color of the stars
                ),
            onRatingUpdate: (rating) {
              if (kDebugMode) {
                print(rating); // Prints the rating when changed
              }
            },
          ),
          SizedBox(height: 5),

          // Review Text
          SizedBox(
            width: 250,
            child: Text(
              comment,
              style: styleForNormalText.copyWith(
                color: AppColors.grey,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                height: 1.1.h,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
