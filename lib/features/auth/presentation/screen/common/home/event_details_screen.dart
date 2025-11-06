import 'dart:developer';

import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/controller/bussiness%20controller/event_details_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/bussiness%20map/map_page.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/widgets/fullimage.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
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
import '../../../widgets/regular/business_detail/custom_comment.dart';
import '../../../widgets/regular/business_detail/custom_info_list_tile.dart';
import '../../../widgets/regular/business_detail/custom_input_field.dart';
import '../../../widgets/regular/business_detail/faq_item_widget.dart';
import '../../../widgets/regular/business_detail/review_show_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventDetailsController controller = Get.put(EventDetailsController());

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    final DateFormat formatter = DateFormat('MMMM d, y'); // e.g., July 15, 2025
    return formatter.format(parsedDate);
  }

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

  String getRatingText(num rating) {
    if (rating >= 4.5 && rating <= 5.0) {
      return "Top Event";
    } else if (rating >= 3.5 && rating < 4.5) {
      return "Recommended";
    } else if (rating >= 2.5 && rating < 3.5) {
      return "Standard";
    } else if (rating > 0.0 && rating < 2.5) {
      return "Needs Improvement";
    }
    return "New";
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var id = Get.arguments;
    controller.fetchEventDetailsById(id: id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final String? detailShow =
        Get.arguments is Map ? Get.arguments['detailShow'] as String? : null;

    return Scaffold(
      floatingActionButton:
          detailShow == "event"
              ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: CustomButton(text: AppString.edit),
              )
              : Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await launchURL(
                              controller.eventDetail.value!.phoneNumber,
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
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Obx(
                            () => CustomButton(
                              text: AppString.sendMessage,
                              fontSize: 18.sp,
                              isLoading: controller.isLoadingMsg.value,
                              onTap: () {
                                controller.createChat();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Obx(() {
                            return (controller.extraEventData.value == null)
                                ? SizedBox()
                                : CustomButton(
                                  text:
                                      controller
                                              .extraEventData
                                              .value!
                                              .isInterested
                                          ? "Interested".tr
                                          : AppString.iMInterested,
                                  isLoading: controller.isLoadingInterest.value,
                                  fontSize: 18.sp,
                                  onTap: () {
                                    controller.createInterest();
                                    controller
                                        .extraEventData
                                        .value!
                                        .isInterested = true;
                                    controller.extraEventData.refresh();
                                  },
                                );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

      body: Obx(() {
        log(controller.extraEventData.value.toString());
        if (controller.eventDetail.value == null ||
            controller.extraEventData.value == null ||
            controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Image
                  GestureDetector(
                    onTap: () {
                      showFullImage(
                        context,
                        controller.eventDetail.value!.coverImage,
                      );
                    },
                    child: Container(
                      height: 350.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //   bottomRight: Radius.circular(20.w),
                        //   bottomLeft: Radius.circular(20.w),
                        // ),
                        image: DecorationImage(
                          image: NetworkImage(
                            controller.eventDetail.value!.coverImage,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  // Bookmark Icon
                  // Positioned(
                  //   bottom: -50,
                  //   right: 10,
                  //   child: IconButton(
                  //     icon: SvgPicture.asset(AppIcons.bookmarkIcon),
                  //     onPressed: () => _showWishlistPopUp(context, controller.eventDetail.value!.id, "businessId"),
                  //   ),
                  // ),
                  // Profile Image with Decorative Overlay
                  Positioned(
                    bottom: -40,
                    left: 16,
                    child: Stack(
                      children: [
                        // Profile Image
                        GestureDetector(
                          onTap: () {
                            showFullImage(
                              context,
                              controller.eventDetail.value!.logo,
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
                                controller.eventDetail.value!.logo,
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
              SizedBox(height: 50.h),
              // Profile Name and Bio Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            controller.eventDetail.value!.name,
                            style: styleForBoldText.copyWith(
                              fontSize: 30.sp,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
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
                            controller.eventDetail.value!.category,
                            style: styleForNormalText.copyWith(
                              color: AppColors.primary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Text(
                    //   'Music Festival',
                    //   style: styleForBoldText.copyWith(
                    //     fontSize: 24,
                    //     color: AppColors.darkGrey,
                    //   ),
                    // ),
                    const SizedBox(height: 10),

                    // Action Buttons (Follow, Like, Comment)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            buildActionButton(
                              icon: Icon(
                                controller.eventDetail.value!.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              label: AppString.like,
                              color: AppColors.primary,
                              onPressed: () {
                                eventLikeUnlike(
                                  isLike: controller.eventDetail.value!.isLiked,
                                  eventId: controller.eventDetail.value!.id,
                                ).then((value) {
                                  if (value) {
                                    if (controller.eventDetail.value!.isLiked) {
                                      controller.eventDetail.value!.isLiked =
                                          false;
                                      controller
                                          .eventDetail
                                          .value!
                                          .totalLikes -= 1;
                                    } else {
                                      controller.eventDetail.value!.isLiked =
                                          true;
                                      controller
                                          .eventDetail
                                          .value!
                                          .totalLikes += 1;
                                    }

                                    controller.eventDetail.refresh();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 10),

                        Column(
                          children: [
                            buildActionButton(
                              icon: SvgPicture.asset(
                                AppIcons.commentIcon,
                                color: Colors.white,
                                height: 20,
                                width: 20,
                              ),
                              label: AppString.comment,
                              color: AppColors.primary,
                              onPressed: () {
                                showHomePageCommentBottomSheet(
                                  id: controller.eventDetail.value!.id,
                                  isBussiness: false,
                                  context,
                                  commentController: TextEditingController(),
                                ).then((value) {
                                  controller.fetchEventDetailsById();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStatColumn(
                          controller.eventDetail.value!.totalLikes.toString(),
                          AppString.likes,
                        ),
                        Container(
                          height: 30.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: AppColors.grey),
                        ),
                        buildStatColumn(
                          controller.eventDetail.value!.totalComments
                              .toString(),
                          AppString.comments,
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Text(
                      controller.eventDetail.value!.description,
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
                      subTitle: controller.eventDetail.value!.address,
                    ),
                    CustomInfoListTile(
                      icon: Icon(Icons.phone, color: AppColors.primary),
                      title: 'Phone',
                      subTitle: controller.eventDetail.value!.phoneNumber,
                    ),
                    CustomInfoListTile(
                      icon: Icon(Icons.email, color: AppColors.primary),
                      title: 'Email',
                      subTitle: controller.eventDetail.value!.email,
                    ),
                    CustomInfoListTile(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                      ),
                      title: 'Date',
                      subTitle:
                          "${formatDate(controller.eventDetail.value!.startDate)} - ${formatDate(controller.eventDetail.value!.endDate)}",
                    ),
                    CustomInfoListTile(
                      icon: Icon(
                        Icons.timer_outlined,
                        color: AppColors.primary,
                      ),
                      title: 'Time',
                      subTitle: controller.eventDetail.value!.startTime,
                    ),
                    CustomInfoListTile(
                      icon: SvgPicture.asset(
                        AppIcons.eventIcon,
                        color: AppColors.primary,
                      ),
                      title: 'Event Type',
                      subTitle: controller.eventDetail.value!.type,
                    ),
                    CustomInfoListTile(
                      icon: Icon(
                        Icons.currency_exchange,
                        color: AppColors.primary,
                      ),
                      title: 'Entrance Fee',
                      subTitle:
                          '\$${controller.eventDetail.value!.entranceFee}',
                    ),

                    SizedBox(height: 10),

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
                          Column(
                            children: [
                              Text(
                                controller.eventDetail.value!.averageRating
                                    .toString(),
                                style: styleForNormalText.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                children: List.generate(5, (index) {
                                  if (index <
                                      controller
                                          .eventDetail
                                          .value!
                                          .averageRating
                                          .floor()) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.black,
                                      size: 20.r,
                                    );
                                  } else if (index <
                                          controller
                                              .eventDetail
                                              .value!
                                              .averageRating &&
                                      controller
                                                  .eventDetail
                                                  .value!
                                                  .averageRating %
                                              1 !=
                                          0) {
                                    return Icon(
                                      Icons.star_half,
                                      color: Colors.black,
                                      size: 20.r,
                                    );
                                  } else {
                                    return Icon(
                                      Icons.star_border,
                                      color: Colors.grey,
                                      size: 20.r,
                                    );
                                  }
                                }),
                              ),
                            ],
                          ),
                          SizedBox(width: 5.w),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          SizedBox(width: 5.w),
                          Row(
                            children: [
                              if (controller.eventDetail.value!.averageRating >=
                                  4.5)
                                SvgPicture.asset(AppIcons.leafLeft),
                              if (controller.eventDetail.value!.averageRating >=
                                  4.5)
                                SizedBox(width: 2),
                              SizedBox(
                                width: 70.w,
                                child: Text(
                                  getRatingText(
                                    controller.eventDetail.value!.averageRating,
                                  ),
                                  style: styleForNormalText.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (controller.eventDetail.value!.averageRating >=
                                  4.5)
                                SizedBox(width: 2),
                              if (controller.eventDetail.value!.averageRating >=
                                  4.5)
                                SvgPicture.asset(AppIcons.leafRight),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          SizedBox(width: 5.w),
                          Column(
                            children: [
                              Text(
                                controller.eventDetail.value!.totalReviews
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
                      controller.eventDetail.value!.detailDescription,
                      style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        height: 1.2.h,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    ///
                    ///
                    ///  |

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
                          Text(
                            AppString.gallery,
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                controller.eventDetail.value!.gallery.length > 4
                                    ? 4
                                    : controller
                                        .eventDetail
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
                                  controller.eventDetail.value!.gallery;
                              final imageUrl = gallery[index];

                              final bool isLastThumbnail =
                                  gallery.length > 4 && index == 3; // 4th item

                              return GestureDetector(
                                onTap: () {
                                  showFullImageGallery(
                                    context,
                                    imageUrls:
                                        controller.eventDetail.value!.gallery,
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
                                          color: Colors.black.withOpacity(0.5),
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
                          Text(
                            AppString.reviews,
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 160.h,
                            child: ListView.builder(
                              itemCount:
                                  controller.eventDetail.value!.reviews.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ReviewShowWidget(
                                    comment:
                                        controller
                                            .eventDetail
                                            .value!
                                            .reviews[index]
                                            .comment,
                                    name:
                                        controller
                                            .eventDetail
                                            .value!
                                            .reviews[index]
                                            .userId
                                            .name,
                                    profileImage:
                                        controller
                                            .eventDetail
                                            .value!
                                            .reviews[index]
                                            .userId
                                            .profileImage,
                                    ratting:
                                        controller
                                            .eventDetail
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
                                  'type': 'event',
                                  'id': controller.eventDetail.value!.id,
                                },
                              )!.then((value) {
                                controller.fetchEventDetailsById(
                                  id: controller.eventDetail.value!.id,
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
                            width:
                                double
                                    .infinity, //MapPreview(lat: 37.7749, lng: -122.4194)
                            child: MapPreview(
                              lat:
                                  (controller
                                          .eventDetail
                                          .value!
                                          .location
                                          .coordinates
                                          .isNotEmpty)
                                      ? controller
                                          .eventDetail
                                          .value!
                                          .location
                                          .coordinates
                                          .last
                                      : 23.8103,

                              lng:
                                  (controller
                                          .eventDetail
                                          .value!
                                          .location
                                          .coordinates
                                          .isNotEmpty)
                                      ? controller
                                          .eventDetail
                                          .value!
                                          .location
                                          .coordinates
                                          .first
                                      : 90.4125,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    if (controller
                        .eventDetail
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
                    SizedBox(height: 10.h),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount:
                          controller
                              .eventDetail
                              .value!
                              .additionalServices
                              .length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "- ${controller.eventDetail.value!.additionalServices[index]}",
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
                              controller.eventDetail.value!.faq.length,
                              (index) {
                                return FAQItem(
                                  number: (index + 1).toString(),
                                  question:
                                      controller
                                          .eventDetail
                                          .value!
                                          .faq[index]
                                          .question,
                                  answer:
                                      controller
                                          .eventDetail
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
                    SizedBox(height: 10.h),
                    //promotions
                    if (controller.eventDetail.value!.promotions.isNotEmpty)
                      Text(
                        AppString.promotions,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                    SizedBox(height: 10.h),
                    if (controller.eventDetail.value!.promotions.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 250.h,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              controller.eventDetail.value!.promotions.first
                                  .toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child: Center(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         "🌸 Blossoms of Love: Celebrate Valentine’s Day with Us! 🌸",
                        //         style: styleForBoldText.copyWith(
                        //           fontSize: 36.sp,
                        //           color: Colors.white,
                        //         ),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //       SizedBox(height: 10.h),
                        //       Text(
                        //         "💘 Enjoy 20% Off on All Romantic Arrangements! 💘",
                        //         style: styleForBoldText.copyWith(
                        //           color: Colors.white,
                        //           fontSize: 20.sp,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔻 Events Of Title
                        Text(
                          "${AppString.eventsOf} ${controller.extraEventData.value!.author.name}",
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 24.sp,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// 🔻 Current Events List
                        controller
                                .extraEventData
                                .value!
                                .currentEvents
                                .isNotEmpty
                            ? SizedBox(
                              height: 360,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    controller
                                        .extraEventData
                                        .value!
                                        .currentEvents
                                        .length,
                                itemBuilder: (context, index) {
                                  final currentEvent =
                                      controller
                                          .extraEventData
                                          .value!
                                          .currentEvents[index];
                                  return SizedBox(
                                    width: 288,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CustomFeatureEventContainer(
                                        bookType: "eventId",
                                        type: currentEvent.category,
                                        id: currentEvent.id,
                                        isLiked: currentEvent.isLiked,
                                        onTap: () {
                                          // Get.to(
                                          //   EventDetailsScreen(),
                                          //   arguments: currentEvent.id,
                                          // );
                                          controller.fetchEventDetailsById(
                                            id: currentEvent.id,
                                          );
                                          setState(() {});
                                        },
                                        imageSrc: currentEvent.coverImage,
                                        typeImage: AppIcons.businessIcon,
                                        name: currentEvent.name,
                                        location: currentEvent.address,
                                        peopleCount:
                                            "${currentEvent.startDate.toLocal().toIso8601String().substring(0, 10)}",
                                        rating:
                                            currentEvent.averageRating
                                                .toString(),
                                        padding: 5,
                                        doller:
                                            currentEvent.entranceFee == 0
                                                ? "Free"
                                                : "\$${currentEvent.entranceFee}",
                                        verificationIcon: Icons.verified,
                                        likeCount:
                                            currentEvent.totalLikes.toString(),
                                        commentCount:
                                            currentEvent.totalComments
                                                .toString(),
                                        verification:
                                            currentEvent.blueVerifiedBadge,
                                        peopleCountIcon: SvgPicture.asset(
                                          AppIcons.calenderIcon,
                                        ),
                                        likeOnPressed: () {
                                          likeUnlike(
                                            isLike:
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .isLiked,
                                            businessId:
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .id,
                                          ).then((value) {
                                            if (value) {
                                              if (controller
                                                  .extraEventData
                                                  .value!
                                                  .currentEvents[index]
                                                  .isLiked) {
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .isLiked = false;
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .totalLikes -= 1;
                                              } else {
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .isLiked = true;
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .totalLikes += 1;
                                              }
                                              controller.extraEventData
                                                  .refresh();
                                            }
                                          });
                                        },
                                        commentOnPressed: () {
                                          showHomePageCommentBottomSheet(
                                            id:
                                                controller
                                                    .extraEventData
                                                    .value!
                                                    .currentEvents[index]
                                                    .id,
                                            isBussiness: false,
                                            context,
                                            commentController:
                                                TextEditingController(),
                                          );
                                        },
                                        bookmarkOnPressed: (result) {
                                          if (result) {
                                            controller
                                                .extraEventData
                                                .value!
                                                .currentEvents[index]
                                                .isWishlisted = true;

                                            controller.extraEventData.refresh();
                                          }
                                        },
                                        isWishlisted:
                                            controller
                                                .extraEventData
                                                .value!
                                                .currentEvents[index]
                                                .isWishlisted,
                                        
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            : Center(
                              child: Text(
                                "No data found",
                                style: styleForNormalText,
                              ),
                            ),

                        SizedBox(height: 10.h),

                        /// 🔻 Organized By Section
                        Text(
                          AppString.organizedBy,
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 24.sp,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        ListTile(
                          leading: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 30.r,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                controller.extraEventData.value!.author.name,
                                style: styleForNormalText.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              SvgPicture.asset(
                                AppIcons.verificationIcon,
                                height: 20.h,
                                width: 20.w,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            controller.extraEventData.value!.author.surename,
                            style: styleForNormalText.copyWith(fontSize: 16.sp),
                          ),
                        ),

                        /// 🔻 Comments Section
                        SizedBox(height: 10.h),
                        Text(
                          AppString.comments,
                          style: styleForBoldText.copyWith(fontSize: 22),
                        ),
                        SizedBox(height: 10.h),

                        /// 🔁 Map comments to CustomComment()
                        ...controller.extraEventData.value!.comments
                            .take(5) // Take up to 4 items
                            .map((comment) {
                              return Column(
                                children: [
                                  CustomComment(
                                    name: comment.user.name,
                                    comment: comment.text,
                                    profilePicture: comment.user.profileImage,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            })
                            .toList(),

                        CustomInputField(
                          onSendCommentClick: (value) {
                            controller.postComment(
                              id: controller.eventDetail.value!.id,
                              text: value,
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        /// 🔻 Related Businesses / Events
                        Text(
                          AppString.relatedEvent,
                          style: styleForBoldText.copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 10),

                        SizedBox(
                          height: 360,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                controller
                                    .extraEventData
                                    .value!
                                    .relatedEvents
                                    .length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 288,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CustomFeatureEventContainer(
                                    bookType: "eventId",
type: controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .category,
                                    id:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .id,
                                    verification:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .blueVerifiedBadge,
                                    onTap: () {
                                      controller.fetchEventDetailsById(
                                        id:
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .id,
                                      );
                                      // BusinessDetailsController.instance.fetchBusinessesDetailsById(id: related.id);
                                      // Get.to(BusinessDetailScreen(),arguments: related.id);
                                    },
                                    imageSrc:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .coverImage,
                                    typeImage: AppIcons.businessIcon,
                                    name:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .name,
                                    location:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .category,
                                    isLiked:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .isLiked,
                                    imageType: ImageType.network,
                                    peopleCount: controller
                                        .extraEventData
                                        .value!
                                        .relatedEvents[index]
                                        .startDate
                                        .toLocal()
                                        .toIso8601String()
                                        .substring(0, 10),
                                    rating:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .averageRating
                                            .toString(),
                                    doller: controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index].entranceFee.toString(),
                                    padding: 5,
                                    verificationIcon: Icons.verified,
                                    likeCount:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .totalLikes
                                            .toString(),
                                    commentCount:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .totalComments
                                            .toString(),
                                    likeOnPressed: () {
                                      likeUnlike(
                                        isLike:
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .isLiked,
                                        businessId:
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .id,
                                      ).then((value) {
                                        if (value) {
                                          if (controller
                                              .extraEventData
                                              .value!
                                              .relatedEvents[index]
                                              .isLiked) {
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .isLiked = false;
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .totalLikes -= 1;
                                          } else {
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .isLiked = true;
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .totalLikes += 1;
                                          }
                                          controller.extraEventData.refresh();
                                        }
                                      });
                                    },
                                    commentOnPressed: () {
                                      showHomePageCommentBottomSheet(
                                        id:
                                            controller
                                                .extraEventData
                                                .value!
                                                .relatedEvents[index]
                                                .id,
                                        isBussiness: false,
                                        context,
                                        commentController:
                                            TextEditingController(),
                                      );
                                    },
                                    isWishlisted:
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .isWishlisted,
                                    bookmarkOnPressed: (result) {
                                      if (result) {
                                        controller
                                            .extraEventData
                                            .value!
                                            .relatedEvents[index]
                                            .isWishlisted = true;
                                        controller.extraEventData.refresh();
                                      }
                                    },
                                    
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 190.h),
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
