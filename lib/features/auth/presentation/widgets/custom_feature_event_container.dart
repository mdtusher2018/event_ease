// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/favorite/favorite_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_images.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/wishlist_pop_up.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CustomFeatureEventContainer extends StatelessWidget {
  final Function()? onTap;
  final Function()? likeOnPressed;
  final Function()? commentOnPressed;
  final Function(bool) bookmarkOnPressed;

  String id;
  String bookType;

  final String? likeCount;
  final String? commentCount;
  final String? name;
  final String typeStatus;
  final IconData? verificationIcon;
  final String? location;
  final String? peopleCount;
  final String? doller;
  final String? rating;
  final String type;
  final String imageSrc;
  final String typeImage;
  final double imageHeight;
  final double borderRadius;
  final double padding;
  final bool verification;
  final ImageType imageType;
  final Widget peopleCountIcon;
  final bool isLiked;
  final bool isWishlisted;
  bool unbookmark;
  bool isSponsorShipTrue;
  String? folderName;
  TextEditingController? commentController = TextEditingController();

  CustomFeatureEventContainer({
    Key? key,
    this.onTap,
    this.likeOnPressed,
    this.commentOnPressed,
    required this.bookmarkOnPressed,
    this.likeCount,
    this.commentCount,
    this.name,
    required this.bookType,
    this.id = "",
    this.isSponsorShipTrue = false,
    this.verificationIcon,
    this.location,
    this.peopleCount,
    this.doller,
    this.rating,
    this.commentController,
    this.imageType = ImageType.network,
    String? imageSrc,
    this.imageHeight = 190,
    this.borderRadius = 0,
    this.padding = 0,
    required this.isLiked,
    required this.isWishlisted,
    this.folderName,
    required this.verification,
    required this.type,
    this.typeStatus = "business",
    this.unbookmark=false,
    required this.typeImage,
    this.peopleCountIcon = const Icon(Icons.people, size: 20),
  }) : imageSrc = imageSrc ?? AppImages.serviceCoverImage,
       super(key: key);

  void _showWishlistPopUp(BuildContext context, id, type,{required Function(bool) callBackWishlisted}) {
    showDialog(
      context: context,
      builder: (context) => WishlistPopUp(id: id, type: type,callBackWishlisted: callBackWishlisted,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Get.toNamed(RoutesName.businessDetail, arguments: id);
          },
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 5,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  children: [
                    CommonImage(
                      imageSrc: imageSrc,
                      imageType: imageType,
                      height: imageHeight,
                      borderRadius: borderRadius,
                      width: double.infinity,
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
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type,
                      maxLines: 1,
                      style: styleForNormalText.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(typeImage, height: 19, width: 19),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    typeStatus == "job"
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Share.share(AppUrl.shareJob(id));
                              },
                              child: SvgPicture.asset(
                                AppIcons.shareIcon,
                                height: 25,
                                width: 25,
                              ), //Icon(Icons.share_outlined, size: 24.r),
                            ),
                            PrefsHelper.myRole == "user"
                                ? GestureDetector(
                                       onTap: () async {
                                    log(unbookmark.toString()+"...............");
                                    if(unbookmark){
                                      log("message..................................");
                              bookmarkOnPressed(true);
                                      return;
                                    }
                                    await FavoriteController.instance
                                        .getAllWishList()
                                        .then((value) {
                                          _showWishlistPopUp(
                                            context,
                                            id,
                                            bookType,
                                            callBackWishlisted: bookmarkOnPressed
                                          );
                                        });
                                  },
                                  child: SvgPicture.asset(
                                     (!isWishlisted)
                                    ? AppIcons.bookmarkIcon
                                    : AppIcons.fillbookmarkIcon,
                                    height: 25,
                                    width: 25,
                                  ), // Icon(Icons.bookmark_border, size: 24.r),
                                )
                                : SizedBox(),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: likeOnPressed,
                              child: SvgPicture.asset(
                                (isLiked)
                                    ? AppIcons.fillLoveIcon
                                    : AppIcons.loveIcon,
                                height: 26,
                                width: 26,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              maxLines: 1,
                              likeCount ?? "0",
                              style: styleForNormalText.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: commentOnPressed,
                              // () => showCommentBottomSheet(
                              //   context,
                              //   commentController: commentController!,
                              //   onPressed: () {},
                              // ),
                              child: SvgPicture.asset(
                                AppIcons.comment,
                                height: 26,
                                width: 26,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              maxLines: 1,
                              commentCount ?? "0",
                              style: styleForNormalText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                // final String shareText =
                                //     "Check out this awesome business on EventEase!";
                                // final String shareLink =
                                //     "https://eventease.app/business/$name";
                                // Share.share('$shareText\n$shareLink');
log("share prased");
Share.share( bookType== "eventId"?AppUrl.shareEvent(id):AppUrl.shareBusiness(id));
                              },
                              child: SvgPicture.asset(
                                AppIcons.shareIcon,
                                height: 25,
                                width: 25,
                              ), //Icon(Icons.share_outlined, size: 24.r),
                            ),

                            const Spacer(),
                            PrefsHelper.myRole == "user"
                                ? GestureDetector(
                                  onTap: () async {
                                    log(unbookmark.toString()+"...............");
                                    if(unbookmark){
                                      log("message..................................");
                              bookmarkOnPressed(true);
                                      return;
                                    }
                                    await FavoriteController.instance
                                        .getAllWishList()
                                        .then((value) {
                                          _showWishlistPopUp(
                                            context,
                                            id,
                                            bookType,
                                            callBackWishlisted: bookmarkOnPressed
                                          );
                                        });
                                  },
                                  child: SvgPicture.asset(
                                         (!isWishlisted)
                                    ? AppIcons.bookmarkIcon
                                    : AppIcons.fillbookmarkIcon,
                                    
                                    height: 25,
                                    width: 25,
                                  ), // Icon(Icons.bookmark_border, size: 24.r),
                                )
                                : SizedBox(),
                          ],
                        ),
                    SizedBox(height: 7),

                    Row(
                      children: [
                        // Make sure name takes as much space as possible but not too wide
                        Flexible(
                          child: Text(
                            name ?? "Unknown",
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 22,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (verification == true) ...[
                          SizedBox(width: 4), // small gap between name and icon
                          SvgPicture.asset(
                            AppIcons.verificationIcon,
                            height: 17,
                            width: 17,
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location ?? "No location",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleForNormalText.copyWith(
                              fontSize: 15,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    typeStatus == "job"
                        ? SizedBox()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                peopleCountIcon,
                                SizedBox(width: 5),
                                Text(
                                  peopleCount ?? "0",
                                  style: styleForNormalText.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              doller ?? "\$0",
                              style: styleForNormalText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Make sure this Row doesn't overflow by wrapping it with Flexible or Expanded
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  rating ?? "0.0",
                                  style: styleForNormalText.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
