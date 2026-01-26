import 'dart:developer';
import 'dart:io';

import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/comment_controller.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/black_for_ios/block_controlller.dart';
import 'package:event_ease/features/auth/presentation/controller/bussiness%20controller/BusinessDetailsController.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/bussiness%20map/map_page.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/widgets/fullimage.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/inspiration/custom_idea_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../widgets/custom_feature_event_container.dart';
import '../../../widgets/regular/business_detail/build_action_button.dart';
import '../../../widgets/regular/business_detail/build_stat_column.dart';
import '../../../widgets/regular/business_detail/custom_info_list_tile.dart';

import '../../../widgets/regular/business_detail/faq_item_widget.dart';
import '../../../widgets/regular/business_detail/review_show_widget.dart';

class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({super.key});

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final BusinessDetailsController controller = Get.put(
    BusinessDetailsController(),
  );

  // void _showWishlistPopUp(BuildContext context, id, type,Function(bool) callBackWishlisted) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => WishlistPopUp(id: id, type: type,callBackWishlisted:callBackWishlisted ,),
  //   );
  // }

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  // Track selected tab index: 0 = Gallery, 1 = Reviews, 2 = Location, 3 = FAQ
  int _selectedTabIndex = 0;

  // Scroll to the section and update selected tab index
  void scrollToSection(GlobalKey key, int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildTab(
    String label,
    int index,
    GlobalKey targetKey, {
    Widget? icon,
  }) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => scrollToSection(targetKey, index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon, SizedBox(width: 8.w)],
            Text(
              label,
              style: styleForBoldText.copyWith(
                fontSize: 16.sp,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const dayShortNames = {
    "Monday": "Mon",
    "Tuesday": "Tue",
    "Wednesday": "Wed",
    "Thursday": "Thu",
    "Friday": "Fri",
    "Saturday": "Sat",
    "Sunday": "Sun",
  };

  Future<void> launchURL(String url) async {
    if (!url.startsWith('tel:') && !url.startsWith('http')) {
      url = 'tel:$url';
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error".tr, "Could not launch $url");
    }
  }

  String getRatingText(num rating) {
    if (rating == 0.0) {
      return "New";
    } else if (rating >= 1.0 && rating <= 1.9) {
      return "An experience to consider carefully";
    } else if (rating >= 2.0 && rating <= 2.9) {
      return "Check the details before choosing";
    } else if (rating >= 3.0 && rating <= 3.4) {
      return "Mixed reviews — take a look and decide for yourself";
    } else if (rating >= 3.5 && rating <= 3.9) {
      return "Differently appreciated — evaluate it personally";
    } else if (rating >= 4.0 && rating <= 4.4) {
      return "Many users had a good experience";
    } else if (rating >= 4.5 && rating <= 4.7) {
      return "Highly appreciated by the community";
    } else if (rating >= 4.8 && rating <= 5.0) {
      return "Chosen and loved by users!";
    }
    return "";
  }

  List<Widget> buildStars(num rating) {
    int fullStars = rating.floor(); // full stars
    bool hasHalfStar = (rating - fullStars) >= 0.5; // half star if needed

    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.black, size: 16.r));
    }
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.black, size: 16.r));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.black, size: 16.r));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final String? detailShow =
        Get.arguments is Map ? Get.arguments['detailShow'] as String? : null;

    return Scaffold(
      floatingActionButton:
          detailShow == 'business'
              ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: CustomButton(text: "Edit"),
              )
              : Row(
                children: [
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () async {
                      await launchURL(
                        controller.businessDetail.value!.phoneNumber,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19.r),
                        color: const Color(0xffebcfff),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: AppColors.primary,
                        size: 22.r,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: AppString.sendMessage,
                      paddingVertical: 0.h,
                      onTap: () {
                        controller.createChat();
                      },
                    ),
                  ),
                ],
              ),
      body: Obx(() {
        if (controller.isLoading.value ||
            controller.businessDetail.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      showFullImage(
                        context,
                        controller.businessDetail.value!.coverImage,
                      );
                    },
                    child: Container(
                      height: 350.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            controller.businessDetail.value!.coverImage,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -40,
                    left: 16,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showFullImage(
                              context,
                              controller.businessDetail.value!.logo,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.network(
                                controller.businessDetail.value!.logo,
                                height: 92.h,
                                width: 92.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_outlined),
                    onSelected: (value) async {
                      log("value $value");
                      if (value == 'report') {
                        Get.toNamed(
                          RoutesName.report,
                          arguments: {
                            'id': controller.businessDetail.value!.id,
                            'type': "Business",
                          },
                        );
                      }else if (value == 'block') {
                        await blockAnything(
                          id: controller.businessDetail.value!.id,
                          type: "business",
                        );
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          if (Platform.isIOS || kDebugMode)
                            PopupMenuItem<String>(
                              value: 'block',
                              child: Text('Block'),
                            ),
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Text('Report'),
                          ),
                          // Add other options here if needed
                        ],
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            controller.businessDetail.value!.name,
                            style: styleForBoldText.copyWith(
                              fontSize: 30.sp,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        if (controller.businessDetail.value!.blueVerifiedBadge)
                          SvgPicture.asset(AppIcons.verificationIcon),
                        SizedBox(width: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Text(
                            controller.businessDetail.value!.categoryName,
                            style: styleForNormalText.copyWith(
                              color: AppColors.primary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildActionButton(
                          icon: Icon(
                            (controller.businessDetail.value!.isFollowed)
                                ? Icons.person_remove
                                : Icons.person_add_alt_1_rounded,
                            size: 20.r,
                          ),
                          label: AppString.follow,
                          color: AppColors.primary,
                          onPressed: () {
                            log("message");
                            followUnfollow(
                              businessId: controller.businessDetail.value!.id,
                              isFollowed:
                                  controller.businessDetail.value!.isFollowed,
                            ).then((success) {
                              if (success) {
                                controller.businessDetail.value!.isFollowed =
                                    !controller
                                        .businessDetail
                                        .value!
                                        .isFollowed;
                                if (controller
                                    .businessDetail
                                    .value!
                                    .isFollowed) {
                                  controller
                                      .businessDetail
                                      .value!
                                      .totalFollowers += 1;
                                } else {
                                  controller
                                      .businessDetail
                                      .value!
                                      .totalFollowers -= 1;
                                }
                                controller.businessDetail.refresh();
                              }
                            });
                          },
                        ),
                        SizedBox(width: 2),
                        buildActionButton(
                          icon: Icon(
                            controller.businessDetail.value!.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20.r,
                          ),
                          label: AppString.like,
                          color: AppColors.primary,
                          onPressed: () async {
                            final isCurrentlyLiked =
                                controller.businessDetail.value!.isLiked;

                            final success = await likeUnlike(
                              businessId: controller.businessDetail.value!.id,
                              isLike:
                                  isCurrentlyLiked, // send the desired state
                            );

                            if (success) {
                              controller.businessDetail.value!.isLiked =
                                  !isCurrentlyLiked;

                              if (controller.businessDetail.value!.isLiked) {
                                controller.businessDetail.value!.totalLikes +=
                                    1;
                              } else {
                                controller.businessDetail.value!.totalLikes -=
                                    1;
                              }

                              controller.businessDetail.refresh(); // update UI
                            }
                          },
                        ),
                        SizedBox(width: 2),
                        buildActionButton(
                          icon: SvgPicture.asset(
                            AppIcons.commentIcon,
                            color: Colors.white,
                            height: 20.h,
                            width: 20.w,
                          ),
                          label: AppString.comment,
                          color: AppColors.primary,
                          onPressed: () {
                            showHomePageCommentBottomSheet(
                              id: controller.businessDetail.value!.id,
                              isBussiness: true,
                              context,
                              commentController: TextEditingController(),
                            ).then((value) {
                              controller.fetchBusinessesDetailsById();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStatColumn(
                          controller.businessDetail.value!.totalFollowers
                              .toString(),
                          AppString.followers,
                        ),
                        Container(
                          height: 30.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: AppColors.grey),
                        ),
                        buildStatColumn(
                          controller.businessDetail.value!.totalLikes
                              .toString(),
                          AppString.likes,
                        ),
                        Container(
                          height: 30.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: AppColors.grey),
                        ),
                        buildStatColumn(
                          controller.businessDetail.value!.totalComments
                              .toString(),
                          AppString.comments,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.businessDetail.value!.description,
                      style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        height: 1.2.h,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                    CustomInfoListTile(
                      icon: SvgPicture.asset(AppIcons.locationIcon2),
                      title: 'Address',
                      subTitle: controller.businessDetail.value!.address,
                    ),
                    CustomInfoListTile(
                      icon: Icon(Icons.phone, color: AppColors.primary),
                      title: 'Phone',
                      subTitle: controller.businessDetail.value!.phoneNumber,
                    ),
                    CustomInfoListTile(
                      icon: Icon(Icons.email, color: AppColors.primary),
                      title: 'Email',
                      subTitle: controller.businessDetail.value!.email,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "${AppString.hour} : ",
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "${dayShortNames[controller.businessDetail.value!.availabilities.day.first]}-${dayShortNames[controller.businessDetail.value!.availabilities.day.last]} ${controller.businessDetail.value!.availabilities.startTime} -${controller.businessDetail.value!.availabilities.endTime}",
                          style: styleForNormalText.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "${AppString.social}:",
                          style: styleForBoldText.copyWith(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap:
                              () => launchURL(
                                controller
                                    .businessDetail
                                    .value!
                                    .socialLinks
                                    .facebook,
                              ),
                          child: CommonImage(
                            imageSrc: AppIcons.facebookIcon,
                            imageType: ImageType.svg,
                            size: 16.r,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap:
                              () => launchURL(
                                controller
                                    .businessDetail
                                    .value!
                                    .socialLinks
                                    .instagram,
                              ),
                          child: CommonImage(
                            imageSrc: AppIcons.instagramIcon,
                            imageType: ImageType.svg,
                            size: 16.r,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap:
                              () => launchURL(
                                controller
                                    .businessDetail
                                    .value!
                                    .socialLinks
                                    .twitter,
                              ),
                          child: CommonImage(
                            imageSrc: AppIcons.xIcon,
                            imageType: ImageType.svg,
                            size: 16.r,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap:
                              () => launchURL(
                                controller
                                    .businessDetail
                                    .value!
                                    .socialLinks
                                    .tiktok,
                              ),
                          child: CommonImage(
                            imageSrc: AppIcons.tiktokIcon,
                            imageType: ImageType.svg,
                            size: 16.r,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.black, width: 0.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// ⭐ Rating Column
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  controller.businessDetail.value!.averageRating
                                      .toStringAsFixed(1),
                                  style: styleForNormalText.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildStars(
                                    controller
                                        .businessDetail
                                        .value!
                                        .averageRating,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 5.w),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          SizedBox(width: 10.w),

                          /// 🌿 Rating Text
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (controller
                                        .businessDetail
                                        .value!
                                        .averageRating >=
                                    4.5)
                                  SvgPicture.asset(AppIcons.leafLeft),
                                if (controller
                                        .businessDetail
                                        .value!
                                        .averageRating >=
                                    4.5)
                                  SizedBox(width: 2),
                                SizedBox(
                                  width: 70.w,
                                  child: Text(
                                    getRatingText(
                                      controller
                                          .businessDetail
                                          .value!
                                          .averageRating,
                                    ),
                                    style: styleForNormalText.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                if (controller
                                        .businessDetail
                                        .value!
                                        .averageRating >=
                                    4.5)
                                  SizedBox(width: 2),
                                if (controller
                                        .businessDetail
                                        .value!
                                        .averageRating >=
                                    4.5)
                                  SvgPicture.asset(AppIcons.leafRight),
                              ],
                            ),
                          ),

                          SizedBox(width: 10.w),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                          ),

                          /// 📝 Total Reviews
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  controller.businessDetail.value!.totalReviews
                                      .toString(),
                                  style: styleForNormalText.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Reviews",
                                  style: styleForNormalText.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    Text(
                      AppString.description,
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.businessDetail.value!.detailDescription,
                      style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        height: 1.5.h,
                      ),
                    ),

                    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    ///
                    ///
                    ///
                    ///

                    // Tabs
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildTab(
                              AppString.gallery,
                              0,
                              _galleryKey,
                              icon: SvgPicture.asset(
                                AppIcons.galleryLogo,
                                height: 18.h,
                                width: 18.w,
                                color:
                                    _selectedTabIndex == 0
                                        ? Colors.white
                                        : AppColors.primary,
                              ),
                            ),
                            buildTab(
                              AppString.reviews,
                              1,
                              _reviewsKey,
                              icon: SvgPicture.asset(
                                AppIcons.reviewIconTab,
                                height: 18.h,
                                width: 18.w,
                                color:
                                    _selectedTabIndex == 1
                                        ? Colors.white
                                        : AppColors.primary,
                              ),
                            ),
                            buildTab(
                              AppString.location,
                              2,
                              _locationKey,
                              icon: SvgPicture.asset(
                                AppIcons.locationIcon2,
                                height: 18.h,
                                width: 18.w,
                                color:
                                    _selectedTabIndex == 2
                                        ? Colors.white
                                        : AppColors.primary,
                              ),
                            ),
                            buildTab(
                              AppString.faq,
                              3,
                              _faqKey,
                              icon: SvgPicture.asset(
                                AppIcons.faqTabIcon,
                                height: 18.h,
                                width: 18.w,
                                color:
                                    _selectedTabIndex == 3
                                        ? Colors.white
                                        : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Gallery Section
                    Padding(
                      key: _galleryKey,
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller
                              .businessDetail
                              .value!
                              .gallery
                              .isNotEmpty)
                            Text(
                              AppString.gallery,
                              style: styleForBoldText.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 24.sp,
                              ),
                            ),
                          SizedBox(height: 10.h),
                          if (controller
                              .businessDetail
                              .value!
                              .gallery
                              .isNotEmpty)
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller
                                              .businessDetail
                                              .value!
                                              .gallery
                                              .length >
                                          4
                                      ? 4
                                      : controller
                                          .businessDetail
                                          .value!
                                          .gallery
                                          .length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 180,
                                  ),
                              itemBuilder: (context, index) {
                                final gallery =
                                    controller.businessDetail.value!.gallery;
                                final imageUrl = gallery[index];

                                final bool isLastThumbnail =
                                    gallery.length > 4 &&
                                    index == 3; // 4th item

                                return GestureDetector(
                                  onTap: () {
                                    showFullImageGallery(
                                      context,
                                      imageUrls:
                                          controller
                                              .businessDetail
                                              .value!
                                              .gallery,
                                      initialIndex: index,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                        if (isLastThumbnail)
                                          Container(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "+${gallery.length - 4}", // number of extra images
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    // Reviews Section
                    Padding(
                      key: _reviewsKey,
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller
                              .businessDetail
                              .value!
                              .reviews
                              .isNotEmpty)
                            Text(
                              AppString.reviews,
                              style: styleForBoldText.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 24.sp,
                              ),
                            ),
                          if (controller.businessDetail.value!.reviews.isEmpty)
                            SizedBox(height: 10.h),
                          SizedBox(
                            height:
                                (controller
                                        .businessDetail
                                        .value!
                                        .reviews
                                        .isEmpty)
                                    ? 0
                                    : 160.h,
                            child: ListView.builder(
                              itemCount:
                                  controller
                                      .businessDetail
                                      .value!
                                      .reviews
                                      .length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ReviewShowWidget(
                                    comment:
                                        controller
                                            .businessDetail
                                            .value!
                                            .reviews[index]
                                            .comment,
                                    name:
                                        controller
                                            .businessDetail
                                            .value!
                                            .reviews[index]
                                            .userId
                                            .name,
                                    profileImage:
                                        controller
                                            .businessDetail
                                            .value!
                                            .reviews[index]
                                            .userId
                                            .profileImage,
                                    ratting:
                                        controller
                                            .businessDetail
                                            .value!
                                            .reviews[index]
                                            .rating,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomButton(
                            onTap: () {
                              Get.toNamed(
                                RoutesName.giveReview,
                                arguments: {
                                  'type': 'business',
                                  'id': controller.businessDetail.value!.id,
                                },
                              )!.then((value) {
                                controller.fetchBusinessesDetailsById(
                                  id: controller.businessDetail.value!.id,
                                );
                              });
                            },
                            text: AppString.giveReview,
                            fontSize: 20.sp,
                            paddingVertical: 12,
                            borderColor: AppColors.primary,
                            textColor: AppColors.primary,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    // Location Section
                    Padding(
                      key: _locationKey,
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.location,
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            height: 218.h,
                            width: double.infinity,
                            child: MapPreview(
                              lat:
                                  controller
                                      .businessDetail
                                      .value!
                                      .location
                                      .coordinates
                                      .last,
                              lng:
                                  controller
                                      .businessDetail
                                      .value!
                                      .location
                                      .coordinates
                                      .first,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    if (controller
                        .businessDetail
                        .value!
                        .supportedServices
                        .isNotEmpty)
                      Text(
                        AppString.supportedEvents,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                    if (controller
                        .businessDetail
                        .value!
                        .supportedServices
                        .isNotEmpty)
                      SizedBox(height: 10.h),
                    if (controller
                        .businessDetail
                        .value!
                        .supportedServices
                        .isNotEmpty)
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount:
                            controller
                                .businessDetail
                                .value!
                                .supportedServices
                                .length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "- ${controller.businessDetail.value!.supportedServices[index]}",
                              style: styleForNormalText.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2.h,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 10.h),
                    if (controller
                        .businessDetail
                        .value!
                        .additionalServices
                        .isNotEmpty)
                      Text(
                        AppString.extraServices,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                    if (controller
                        .businessDetail
                        .value!
                        .additionalServices
                        .isNotEmpty)
                      SizedBox(height: 10.h),
                    if (controller
                        .businessDetail
                        .value!
                        .additionalServices
                        .isNotEmpty)
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount:
                            controller
                                .businessDetail
                                .value!
                                .additionalServices
                                .length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "- ${controller.businessDetail.value!.additionalServices[index]}",
                              style: styleForNormalText.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2.h,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 20.h),

                    // FAQ Section
                    if (controller.businessDetail.value!.faq.isNotEmpty)
                      Padding(
                        key: _faqKey,
                        padding: EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.faq,
                              style: styleForBoldText.copyWith(
                                fontSize: 24.sp,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            Column(
                              children: List.generate(
                                controller.businessDetail.value!.faq.length,
                                (index) {
                                  return FAQItem(
                                    number: (index + 1).toString(),
                                    question:
                                        controller
                                            .businessDetail
                                            .value!
                                            .faq[index]
                                            .question,
                                    answer:
                                        controller
                                            .businessDetail
                                            .value!
                                            .faq[index]
                                            .answer,
                                    isExpanded: false,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),

                    if (controller.businessDetail.value!.faq.isNotEmpty)
                      SizedBox(height: 20.h),
                    // Promotions Section
                    if (controller
                        .businessDetail
                        .value!
                        .promotionImage
                        .isNotEmpty)
                      Text(
                        AppString.promotions,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                    if (controller
                        .businessDetail
                        .value!
                        .promotionImage
                        .isNotEmpty)
                      SizedBox(height: 10.h),
                    if (controller
                        .businessDetail
                        .value!
                        .promotionImage
                        .isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 250.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              controller
                                  .businessDetail
                                  .value!
                                  .promotionImage
                                  .first,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    // Events Section
                    if (controller
                        .businessDetail
                        .value!
                        .promotionImage
                        .isNotEmpty)
                      SizedBox(height: 20.h),
                    if (controller
                        .extraBusinessDetail
                        .value
                        .currentEvents
                        .isNotEmpty) ...[
                      Text(
                        "${AppString.eventsOf} ${controller.businessDetail.value!.name}",
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 360,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              controller
                                  .extraBusinessDetail
                                  .value
                                  .currentEvents
                                  .length,
                          itemBuilder: (context, index) {
                            var data =
                                controller
                                    .extraBusinessDetail
                                    .value
                                    .currentEvents[index];
                            return SizedBox(
                              width: 288,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CustomFeatureEventContainer(
                                  bookType: "eventId",
                                  type: data.category,
                                  isLiked: data.isLiked,
                                  id: data.id,
                                  onTap: () {
                                    Get.toNamed(
                                      RoutesName.eventDetailScreen,
                                      arguments: data.id,
                                    );
                                  },

                                  typeImage: AppIcons.businessIcon,
                                  name: data.name,
                                  location: data.address,
                                  peopleCount: "${data.maxParticipants}",
                                  rating: "${data.totalReviews}",
                                  doller: "${data.entranceFee}",
                                  padding: 5,
                                  borderRadius: 8,
                                  verificationIcon: Icons.verified,
                                  likeCount: "${data.totalLikes}",
                                  commentCount: "${data.totalComments}",
                                  verification: data.blueVerifiedBadge,
                                  imageSrc: data.coverImage,
                                  peopleCountIcon: SvgPicture.asset(
                                    AppIcons.calenderIcon,
                                  ),
                                  likeOnPressed: () {
                                    eventLikeUnlike(
                                      isLike:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .isLiked,
                                      eventId:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .id,
                                    ).then((value) {
                                      if (value) {
                                        if (controller
                                            .extraBusinessDetail
                                            .value
                                            .currentEvents[index]
                                            .isLiked) {
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .isLiked = false;
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .totalLikes -= 1;
                                        } else {
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .isLiked = true;
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .totalLikes += 1;
                                        }
                                        setState(() {});
                                      }
                                    });
                                  },
                                  commentOnPressed: () {
                                    log("message");
                                    showHomePageCommentBottomSheet(
                                      id:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .currentEvents[index]
                                              .id,
                                      isBussiness: false,
                                      context,
                                      commentController:
                                          TextEditingController(),
                                    ).then((value) {
                                      controller
                                          .fetchExtraBusinessesDetailsById(
                                            id:
                                                controller
                                                    .businessDetail
                                                    .value!
                                                    .id,
                                          );
                                    });
                                  },
                                  isWishlisted: data.isWishlisted,

                                  bookmarkOnPressed: (result) {
                                    // _showWishlistPopUp(
                                    //   context,
                                    //   data.id,
                                    //   "eventId",
                                    // );
                                    if (result) {
                                      controller
                                          .extraBusinessDetail
                                          .value
                                          .currentEvents[index]
                                          .isWishlisted = true;
                                      controller.extraBusinessDetail.refresh();
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                    // Past Events Section
                    if (controller
                        .extraBusinessDetail
                        .value
                        .pastEvents
                        .isNotEmpty) ...[
                      Text(
                        "${AppString.pastEvents} ${controller.businessDetail.value!.name}",
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 360,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              controller
                                  .extraBusinessDetail
                                  .value
                                  .pastEvents
                                  .length,
                          itemBuilder: (context, index) {
                            var data =
                                controller
                                    .extraBusinessDetail
                                    .value
                                    .pastEvents[index];
                            return SizedBox(
                              width: 288,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CustomFeatureEventContainer(
                                  bookType: "eventId",
                                  id: data.id,

                                  type:
                                      controller
                                          .extraBusinessDetail
                                          .value
                                          .pastEvents[index]
                                          .category,

                                  isLiked:
                                      controller
                                          .extraBusinessDetail
                                          .value
                                          .pastEvents[index]
                                          .isLiked,
                                  onTap: () {
                                    Get.toNamed(
                                      RoutesName.eventDetailScreen,
                                      arguments: data.id,
                                    );
                                  },

                                  typeImage: AppIcons.businessIcon,
                                  name: data.name,
                                  location: data.address,
                                  peopleCount: "${data.maxParticipants}",
                                  verification:
                                      controller
                                          .extraBusinessDetail
                                          .value
                                          .pastEvents[index]
                                          .blueVerifiedBadge,
                                  padding: 5,
                                  borderRadius: 8,
                                  peopleCountIcon: SvgPicture.asset(
                                    AppIcons.calenderIcon,
                                  ),
                                  rating: "${data.totalReviews}",
                                  doller: "${data.entranceFee}",
                                  verificationIcon: Icons.verified,
                                  likeCount: "${data.totalLikes}",
                                  commentCount: "${data.totalComments}",
                                  imageSrc: data.coverImage,

                                  likeOnPressed: () {
                                    eventLikeUnlike(
                                      isLike:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .isLiked,
                                      eventId:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .id,
                                    ).then((value) {
                                      if (value) {
                                        if (controller
                                            .extraBusinessDetail
                                            .value
                                            .pastEvents[index]
                                            .isLiked) {
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .isLiked = false;
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .totalLikes -= 1;
                                        } else {
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .isLiked = true;
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .totalLikes += 1;
                                        }
                                        setState(() {});
                                      }
                                    });
                                  },
                                  commentOnPressed: () {
                                    log("message");
                                    showHomePageCommentBottomSheet(
                                      id:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .pastEvents[index]
                                              .id,
                                      isBussiness: false,
                                      context,
                                      commentController:
                                          TextEditingController(),
                                    ).then((value) {
                                      controller
                                          .fetchExtraBusinessesDetailsById(
                                            id:
                                                controller
                                                    .businessDetail
                                                    .value!
                                                    .id,
                                          );
                                    });
                                  },
                                  isWishlisted:
                                      controller
                                          .extraBusinessDetail
                                          .value
                                          .pastEvents[index]
                                          .isWishlisted,

                                  bookmarkOnPressed: (result) {
                                    controller
                                        .extraBusinessDetail
                                        .value
                                        .pastEvents[index]
                                        .isWishlisted = true;
                                    controller.extraBusinessDetail.refresh();
                                  },

                                  // () => _showWishlistPopUp(
                                  //   context,
                                  //   data.id,
                                  //   "eventId",
                                  // ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Articles Section
                      SizedBox(height: 10.h),
                    ],
                    if (controller
                        .extraBusinessDetail
                        .value
                        .inspirationBlogs
                        .isNotEmpty) ...[
                      Text(
                        "${AppString.articlesOf} ${controller.businessDetail.value!.name}",
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      SizedBox(
                        height: 350,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              controller
                                  .extraBusinessDetail
                                  .value
                                  .inspirationBlogs
                                  .length,
                          itemBuilder: (context, index) {
                            var data =
                                controller
                                    .extraBusinessDetail
                                    .value
                                    .inspirationBlogs[index];
                            return SizedBox(
                              width: 320,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CustomIdeaContainer(
                                  image: "${data.coverImage}",
                                  title: data.title,
                                  description: data.description,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Job Opportunity Button
                      SizedBox(height: 10.h),
                    ],
                    CustomButton(
                      text: AppString.jobOpportunity,
                      paddingVertical: 10,
                      fontSize: 18,
                      borderRadius: 12,
                      onTap: () {
                        Get.toNamed(RoutesName.job);
                      },
                    ),

                    // Comments Section
                    SizedBox(height: 10.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BusinessCommentsSection(
                          businessId: controller.businessDetail.value!.id,
                          isBusiness: true,
                        ),

                        if (controller
                            .extraBusinessDetail
                            .value
                            .relatedBusinesses
                            .isNotEmpty)
                          Text(
                            AppString.relatedBusiness,
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 24.sp,
                            ),
                          ),
                        if (controller
                            .extraBusinessDetail
                            .value
                            .relatedBusinesses
                            .isNotEmpty)
                          SizedBox(
                            height: 360,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  controller
                                      .extraBusinessDetail
                                      .value
                                      .relatedBusinesses
                                      .length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 288,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CustomFeatureEventContainer(
                                      bookType: "businessId",
                                      id:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .id,
                                      isLiked:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .isLiked,
                                      onTap: () {
                                        setState(() {
                                          controller.fetchBusinessesDetailsById(
                                            id:
                                                controller
                                                    .extraBusinessDetail
                                                    .value
                                                    .relatedBusinesses[index]
                                                    .id,
                                          );
                                        });
                                      },
                                      imageSrc:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .coverImage,
                                      typeImage: AppIcons.businessIcon,
                                      name:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .name,
                                      padding: 5,
                                      borderRadius: 8,
                                      location:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .address,
                                      peopleCount:
                                          "${controller.extraBusinessDetail.value.relatedBusinesses[index].maxGuest}",
                                      rating:
                                          "${controller.extraBusinessDetail.value.relatedBusinesses[index].totalReviews}",

                                      doller:
                                          controller
                                                      .extraBusinessDetail
                                                      .value
                                                      .relatedBusinesses[index]
                                                      .priceRange
                                                      .toLowerCase() ==
                                                  "budget"
                                              ? "€"
                                              : controller
                                                      .extraBusinessDetail
                                                      .value
                                                      .relatedBusinesses[index]
                                                      .priceRange
                                                      .toLowerCase() ==
                                                  "medium"
                                              ? "€€"
                                              : controller
                                                      .extraBusinessDetail
                                                      .value
                                                      .relatedBusinesses[index]
                                                      .priceRange
                                                      .toLowerCase() ==
                                                  "high"
                                              ? "€€€"
                                              : "€€€€",
                                      type:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .subscriptionType,
                                      verification:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .blueVerifiedBadge,
                                      verificationIcon: Icons.verified,
                                      likeCount:
                                          "${controller.extraBusinessDetail.value.relatedBusinesses[index].totalLikes}",
                                      commentCount:
                                          "${controller.extraBusinessDetail.value.relatedBusinesses[index].totalComments}",
                                      likeOnPressed: () {
                                        likeUnlike(
                                          isLike:
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .isLiked,
                                          businessId:
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .id,
                                        ).then((value) {
                                          if (value) {
                                            if (controller
                                                .extraBusinessDetail
                                                .value
                                                .relatedBusinesses[index]
                                                .isLiked) {
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .isLiked = false;
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .totalLikes -= 1;
                                            } else {
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .isLiked = true;
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .totalLikes += 1;
                                            }
                                            setState(() {});
                                          }
                                        });
                                      },
                                      commentOnPressed: () {
                                        log("message");
                                        showHomePageCommentBottomSheet(
                                          id:
                                              controller
                                                  .extraBusinessDetail
                                                  .value
                                                  .relatedBusinesses[index]
                                                  .id,
                                          isBussiness: true,
                                          context,
                                          commentController:
                                              TextEditingController(),
                                        ).then((value) {
                                          controller
                                              .fetchExtraBusinessesDetailsById(
                                                id:
                                                    controller
                                                        .businessDetail
                                                        .value!
                                                        .id,
                                              );
                                        });
                                      },
                                      isWishlisted:
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .isWishlisted,

                                      bookmarkOnPressed: (result) {
                                        if (result) {
                                          controller
                                              .extraBusinessDetail
                                              .value
                                              .relatedBusinesses[index]
                                              .isWishlisted = true;
                                          controller.extraBusinessDetail
                                              .refresh();
                                        }
                                      },

                                      // () => _showWishlistPopUp(
                                      //   context,
                                      //   controller
                                      //       .extraBusinessDetail
                                      //       .value
                                      //       .relatedBusinesses[index]
                                      //       .id,
                                      //   "businessId",
                                      // ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 90.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BusinessCommentsSection extends StatelessWidget {
  final CommentController controller = Get.put(CommentController());

  final String businessId;
  final bool isBusiness;

  BusinessCommentsSection({
    required this.businessId,
    required this.isBusiness,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Controller for the input field
    final TextEditingController commentController = TextEditingController();

    // Map to manage showing replies for each comment
    final RxMap<String, bool> showReplies = <String, bool>{}.obs;

    // Fetch comments on build
    controller.fetchComments(id: businessId, isBusiness: isBusiness);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Grab Handle
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            ),

            // 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.comments,
                  style: styleForBoldText.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 🔹 Comments list
            controller.comments.isEmpty
                ? Center(
                  child: Text(
                    AppString.noCommentsYet,
                    style: styleForNormalText.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemCount: controller.comments.length,
                  itemBuilder: (context, index) {
                    final comment = controller.comments[index];

                    if (!showReplies.containsKey(comment.id)) {
                      showReplies[comment.id] = false;
                    }

                    final date = DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(comment.createdAt));
                    final time = DateFormat(
                      'HH:mm',
                    ).format(DateTime.parse(comment.createdAt));

                    return Obx(
                      () => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 User row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonImage(
                                  imageSrc: comment.user.profileImage,
                                  imageType: ImageType.network,
                                  borderRadius: 40.r,
                                  height: 36.h,
                                  width: 36.w,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.user.name,
                                            style: styleForBoldText.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Text(
                                            "$date • $time",
                                            style: styleForNormalText.copyWith(
                                              fontSize: 11.sp,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        comment.text,
                                        style: styleForNormalText.copyWith(
                                          fontSize: 14.sp,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          if (comment.replies.isNotEmpty)
                                            TextButton(
                                              onPressed: () {
                                                showReplies[comment.id] =
                                                    !showReplies[comment.id]!;
                                              },
                                              child: Text(
                                                showReplies[comment.id]!
                                                    ? "Hide Replies".tr
                                                    : "${"View Replies".tr} (${comment.replies.length})",
                                                style: styleForNormalText
                                                    .copyWith(
                                                      fontSize: 12.sp,
                                                      color: AppColors.primary,
                                                    ),
                                              ),
                                            ),
                                          TextButton(
                                            onPressed: () {
                                              controller.replyingTo.value =
                                                  comment.id;
                                              controller.replyToName.value =
                                                  comment.user.name;
                                            },
                                            child: Text(
                                              "Reply".tr,
                                              style: styleForNormalText
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // 🔹 Replies
                            if (showReplies[comment.id]! &&
                                comment.replies.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 48.w, top: 8.h),
                                child: Column(
                                  children:
                                      comment.replies.map((reply) {
                                        final replyDate = DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(
                                          DateTime.parse(reply.createdAt),
                                        );
                                        final replyTime = DateFormat(
                                          'HH:mm',
                                        ).format(
                                          DateTime.parse(reply.createdAt),
                                        );

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 8.h),
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            border: Border.all(
                                              color: AppColors.grey.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonImage(
                                                imageSrc:
                                                    reply.user.profileImage,
                                                imageType: ImageType.network,
                                                borderRadius: 30.r,
                                                height: 28.h,
                                                width: 28.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          reply.user.name,
                                                          style: styleForBoldText
                                                              .copyWith(
                                                                fontSize: 13.sp,
                                                                color:
                                                                    AppColors
                                                                        .primary,
                                                              ),
                                                        ),
                                                        Text(
                                                          "$replyDate • $replyTime",
                                                          style: styleForNormalText
                                                              .copyWith(
                                                                fontSize: 11.sp,
                                                                color:
                                                                    AppColors
                                                                        .grey,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      reply.text,
                                                      style: styleForNormalText
                                                          .copyWith(
                                                            fontSize: 13.sp,
                                                            color:
                                                                AppColors
                                                                    .darkGrey,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

            // 🔹 Replying indicator
            Obx(() {
              if (controller.replyToName.value.isEmpty)
                return SizedBox.shrink();
              return Container(
                margin: EdgeInsets.only(bottom: 8.h, top: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.textFieldBg,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${"Replying to".tr} ${controller.replyToName.value}",
                        style: styleForNormalText.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.replyToName.value = "";
                        controller.replyingTo.value = "";
                      },
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // 🔹 Comment input field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...".tr,
                        hintStyle: styleForNormalText.copyWith(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.primary),
                    onPressed: () async {
                      if (commentController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Empty Comment".tr,
                          "Please write something before sending.".tr,
                        );
                        return;
                      }

                      bool success;
                      if (controller.replyingTo.value.isEmpty) {
                        success = await controller.postComment(
                          id: businessId,
                          text: commentController.text.trim(),
                          isBussiness: isBusiness,
                        );
                      } else {
                        success = await controller.postCommentReply(
                          id: businessId,
                          text: commentController.text.trim(),
                          isBussiness: isBusiness,
                        );
                      }

                      if (success) {
                        await controller.fetchComments(
                          id: businessId,
                          isBusiness: isBusiness,
                        );
                        commentController.clear();
                        controller.replyToName.value = "";
                        controller.replyingTo.value = "";
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
