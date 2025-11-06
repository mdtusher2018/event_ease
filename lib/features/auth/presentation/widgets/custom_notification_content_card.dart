import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomNotificationContentCard extends StatelessWidget {
  const CustomNotificationContentCard(
      {super.key,
        required this.avatar,
        required this.message,
        required this.timestamp,
        required this.name,
        this.attachmentName,
        this.attachmentSize,});

  final String avatar;
  final String message;
  final String name;
  final String timestamp;
  final String? attachmentName;
  final String? attachmentSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              
              children: [
                CircleAvatar(
                  radius: 26.r,
                  child: CommonImage(imageSrc: avatar, imageType: ImageType.network, size: 50.r, borderRadius: 100,),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      Text(
                        name,
                        style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.darkGrey, letterSpacing: 0.6),
                      ),
                       SizedBox(height: 8.0.h),
                       Text(
                        message,
                        style: styleForBoldText.copyWith(fontSize: 12.sp, color: AppColors.grey, letterSpacing: 0.6),
                      ),
                      if (attachmentName != null && attachmentSize != null) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file,
                              color: Colors.red,
                              size: 16,
                            ),
                             SizedBox(width: 4.0.w),
                            Text(
                              attachmentName!,
                              style: styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.darkGrey, height: 1.25.h),
                            ),
                             SizedBox(width: 4.0.w),
                            Text(
                              attachmentSize!,
                              style: styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.lightGrey, height: 1.25.h),
                            ),
                          ],
                        ),
                         SizedBox(height: 8.0.h),
                      ],
                    
                    ],
                  ),
                ),
              ],
            ),
          ),
        
              Positioned(
                top: 6,right: 8,
                child: Text(
                timestamp,
                style:  styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.lightGrey, height: 1.25.h),
                                  ),
              ),
        
        ],
      ),
    );
  }
}
