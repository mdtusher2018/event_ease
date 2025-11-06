import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class CustomListingFeatureEventContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? likeOnPressed;
  final VoidCallback? commentOnPressed;
  final VoidCallback? shareOnPressed;
  final VoidCallback? bookmarkOnPressed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAnnouncementTap;
  final Function(bool)? switchOnChanged;

  final bool switchValue;
  final String? likeCount;
  final String? commentCount;
  final String? name;
  final IconData? verificationIcon;
  final String? location;
  final String? peopleCount;
  final String? doller;
  final String? rating;
  final String type;
  final String typeImage;
  final String image;
  final bool verification;
  final Widget peopleCountIcon;

  const CustomListingFeatureEventContainer({
    super.key,
    this.onTap,
    this.likeOnPressed,
    this.commentOnPressed,
    this.shareOnPressed,
    required this.image,
    this.bookmarkOnPressed,
    this.onEdit,
    this.onDelete,
    this.onAnnouncementTap,
    this.switchOnChanged,
    this.switchValue = true,
    this.likeCount,
    this.commentCount,
    this.name,
    this.verificationIcon,
    this.location,
    this.peopleCount,
    this.doller,
    this.rating,
    this.type = "Florist",
    required this.typeImage,
    this.verification = true,
    this.peopleCountIcon = const Icon(Icons.people),
  });

  // void _showWishlistPopUp(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => const WishlistPopUp(),
  //   );
  // }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Delete Confirmation'),
        content: Text(
          'Are you sure to delete?',
          style: styleForNormalText.copyWith(color: AppColors.darkGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('No', style: styleForNormalText.copyWith(fontSize: 16, color: Colors.deepPurpleAccent),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:  Text('Yes',style: styleForNormalText.copyWith(fontSize: 16, color: Colors.deepPurpleAccent)),
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
      onTap: onTap ?? () => Get.toNamed(RoutesName.businessDetail),
      child: Container(
        width: double.infinity,
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
                  width: double.infinity,
                  borderRadius: 8,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      type,
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
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(typeImage, height: 22.h, width: 22.w,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Row(
            //   children: [
            //     IconButton(
            //       onPressed: likeOnPressed,
            //       icon: const Icon(Icons.favorite_border, size: 30),
            //     ),
            //     Text(
            //       likeCount ?? "0",
            //       style:
            //       styleForNormalText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            //     ),
            //     const SizedBox(width: 5),
            //     IconButton(
            //       onPressed: commentOnPressed ?? () => showCommentBottomSheet(context),
            //       icon: const Icon(Icons.insert_comment_outlined, size: 30),
            //     ),
            //     Text(
            //       commentCount ?? "0",
            //       style:
            //       styleForNormalText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            //     ),
            //     const SizedBox(width: 5),
            //     IconButton(
            //       onPressed: shareOnPressed,
            //       icon: const Icon(Icons.share_outlined, size: 30),
            //     ),
            //     const Spacer(),
            //     IconButton(
            //       onPressed: () => _showWishlistPopUp(context),
            //       icon: const Icon(Icons.bookmark_border, size: 30),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              name ?? "Unknown",
                              style: styleForBoldText.copyWith(color: Colors.black, fontSize: 25.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (verification) SvgPicture.asset(AppIcons.verificationIcon),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location ?? "No location",
                        style: styleForNormalText.copyWith(fontSize: 17.sp, color: AppColors.grey),
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        peopleCountIcon,
                        SizedBox(width: 2),
                        Text(
                          peopleCount ?? "0",
                          style: styleForNormalText.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      doller ?? "€€€",
                      style: styleForNormalText.copyWith(fontSize: 14),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text(
                          rating ?? "0.0",
                          style: styleForNormalText.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
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
            )
          ],
        ),
      ),
    );
  }
}
