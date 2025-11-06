import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomJobListWidget extends StatelessWidget {
  final Function()? onTap;
  final Function()? shareOnPressed;
  final Function()? bookmarkOnPressed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAnnouncementTap;
  final Function(bool)? switchOnChanged;

  final bool switchValue;
  final String? name;
  final IconData? verificationIcon;
  final String? location;
  final String type;
  final String typeImage;
  final bool verification;
  final Widget peopleCountIcon;
  final String image;

  const CustomJobListWidget({
    super.key,
    this.onTap,
    this.shareOnPressed,
    this.bookmarkOnPressed,
    this.name,
    this.verificationIcon,
    this.location,
    this.onEdit,
    this.onDelete,
    this.onAnnouncementTap,
    this.switchOnChanged,
    this.switchValue = true,
    this.verification = true,
    required this.image,
    required this.type,
    required this.typeImage,
    this.peopleCountIcon = const Icon(Icons.people), required imageType,
  });

  // void _showWishlistPopUp(BuildContext context) {
  //   showDialog(context: context, builder: (context) => const WishlistPopUp());
  // }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text(
          'Are you sure to delete?',
          style: styleForNormalText.copyWith(color: AppColors.darkGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (onDelete != null) {
        onDelete!();
      } else {
        Get.snackbar('Deleted', 'Item has been deleted successfully.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
      onTap ??
              () {
            Get.toNamed(RoutesName.jobDetailScreen);
          },
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 5,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                CommonImage(
                  imageSrc: image,
                  imageType: ImageType.network,
                  height: 188,
                  borderRadius: 8,
                  width: double.infinity,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      type,
                      maxLines: 1,
                      style: styleForBoldText.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:  EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(typeImage, height: 22.h, width: 22.w,),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: shareOnPressed,
                    icon:  SvgPicture.asset(AppIcons.shareIcon, height: 26.h, width: 26.w,)
                ),
                // const Spacer(),
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   onPressed: () => _showWishlistPopUp(context),
                //   icon:  SvgPicture.asset(AppIcons.bookmarkIcon, height: 26.h, width: 26.w,),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                width: 280.w,
                child: Text(
                  name ?? "Unknown",
                  style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 20.sp,
                      height: 1.50
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 4),
                SizedBox(
                  width: 240.w,
                  child: Text(
                    location ?? "No location",
                    maxLines: 1,
                    style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
                GestureDetector(
                  onTap: () => _showDeleteConfirmationDialog(context),
                  child: const Icon(Icons.delete),
                ),
                InkWell(
                  onTap: onAnnouncementTap ?? () => Get.toNamed(RoutesName.sponsorshipScreen),
                  child: SvgPicture.asset(AppIcons.announcementIcon),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: switchValue,
                    activeColor: AppColors.primary,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey.shade400,
                    onChanged: switchOnChanged,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
