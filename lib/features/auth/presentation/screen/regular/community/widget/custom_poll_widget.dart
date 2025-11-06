import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/my_model/poll_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/common_image.dart';

class CustomPollWidget extends StatelessWidget {
  final String question;
  final String description;
  final String name;
  final String image;
  final String time;
  final List<Option> options;
  final int? selectedIndex; // optional, used for current selection
  final void Function(int index)? onOptionTap;

  const CustomPollWidget({
    super.key,
    required this.question,
    required this.description,
    required this.name,
    required this.image,
    required this.time,
    required this.options,
    this.selectedIndex,
    this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(17),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 40,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Creator info
          Row(
            children: [
              CommonImage(
                imageSrc: image,
                imageType: ImageType.network,
                height: 38.h,
                width: 38.w,
                borderRadius: 100.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      time,
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          // Question
          Text(
            question,
            style: styleForBoldText.copyWith(
              fontSize: 16.sp,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 6.h),

          // Description
          Text(
            description,
            style: styleForNormalText.copyWith(
              fontSize: 14.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),

          // Poll options
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option.isVoted;
              final percent = (option.percentage / 100).clamp(0.0, 1.0);

              return InkWell(
                onTap: () {
                  if (onOptionTap != null) {
                    onOptionTap!(index);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFE1E1E1),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Option text
                      Expanded(
                        child: Text(
                          option.text,
                          style: styleForBoldText.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Percentage and bar
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${option.percentage}% (${option.voteCount})',
                            style: styleForBoldText.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Stack(
                            children: [
                              Container(
                                width: 70.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1E1E1),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                              ),
                              Container(
                                width: 70.w * percent,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(200),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 12.h),

        
        ],
      ),
    );
  }
}
