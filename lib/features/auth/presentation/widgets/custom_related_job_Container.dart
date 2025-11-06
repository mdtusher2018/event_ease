import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/wishlist_pop_up.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/favorite/favorite_controller.dart';

class CustomRelatedJobContainer extends StatelessWidget {
  final Function()? onTap;
  final Function()? bookmarkOnPressed;

  final String? name;
  final IconData? verificationIcon;
  final String? location;
  final String type;
  final String typeImage;
  final String id;
  final String bookType;
  final String eventJobImage;
  final bool isSponsorShipTrue;
  final bool verification;
  final Widget peopleCountIcon;

  const CustomRelatedJobContainer({
    super.key,
    this.onTap,

    this.bookmarkOnPressed,
    this.name,
    this.id="",
    this.bookType="",
    this.eventJobImage="",
    this.verificationIcon,
    this.location,
    this.verification = true,
    this.isSponsorShipTrue=false,
    this.type = "Party Planer",
    required this.typeImage,
    this.peopleCountIcon = const Icon(Icons.people),
  });

  void _showWishlistPopUp(BuildContext context, id, type,{required Function(bool) callBackWishlisted}) {
    showDialog(context: context, builder: (context) =>  WishlistPopUp(id: id,type: type,callBackWishlisted:callBackWishlisted ,));
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
                  imageSrc: eventJobImage,
                  imageType: ImageType.network,
                  height: 190,
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
                      type,maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleForNormalText.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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
if (isSponsorShipTrue)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/images/bolt.png",
                            width: 16,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),


              ],
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Share.share(AppUrl.shareJob(id));
                  },
                  icon:  SvgPicture.asset(AppIcons.shareIcon, height: 26.h, width: 26.w,)
                ),
                const Spacer(),
                PrefsHelper.myRole == "user"
                    ? GestureDetector(
                  onTap: () async {
                    await FavoriteController.instance
                        .getAllWishList()
                        .then((value) {
                      _showWishlistPopUp(context, id, bookType,callBackWishlisted:(result){} );
                    });
                  },
                  child: SvgPicture.asset(
                    AppIcons.bookmarkIcon,
                    height: 25,
                    width: 25,
                  ), // Icon(Icons.bookmark_border, size: 24.r),
                )
                    : SizedBox(),
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
                    location ?? "No location",maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    style: styleForNormalText.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500
                    ),
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
