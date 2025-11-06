// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/controller/bussiness%20controller/BusinessHomePageController.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/styles.dart';
import '../../../widgets/common_image.dart';
import '../../../widgets/custom_feature_event_container.dart';

class LearnMoreScreen extends StatefulWidget {
  LearnMoreScreen({
    Key? key,
    TextEditingController? searchController,
    this.activeIndex = 0,
  }) : searchController = searchController ?? TextEditingController(),
       super(key: key);
  int activeIndex;

  final TextEditingController searchController;

  @override
  State<LearnMoreScreen> createState() => _LearnMoreScreenState();
}

class _LearnMoreScreenState extends State<LearnMoreScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final BusinessController controller = Get.put(BusinessController());

  @override
  void initState() {
    super.initState();
    // Don’t set a fixed 1 length
    Future.microtask(() {
      otherMethod();
    });
  }

  otherMethod() {
    controller.fetchProviderCategories();

    if (mounted) {
      _tabController = TabController(
        length: controller.providerCategories.length,
        vsync: this,
      );
      _tabController?.addListener(() {
        if (_tabController!.indexIsChanging) {
          setState(() {
            widget.activeIndex = _tabController!.index;
          });
        }
      });
      
      _tabController!.index = widget.activeIndex;
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Search Results".tr,
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: Obx(() {
        final categories = controller.providerCategories;
        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Create TabController when categories loaded
        _tabController ??= TabController(
          length: categories.length,
          vsync: this,
          initialIndex: widget.activeIndex,
        );
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomSearchField(
                hintText: AppString.searchEventsLocalBusiness,
                prefixIcon: SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.searchIcon,
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                ),
                suffixIcon: CommonImage(
                  imageSrc: AppIcons.filterIcon,
                  imageType: ImageType.svg,
                  height: 18.h,
                  width: 18.w,
                ),
                controller: widget.searchController,
                readOnly: true,
                onTap: () {
                  Get.toNamed(RoutesName.search);
                },
                onPressedSuffix: () {
                  Get.toNamed(RoutesName.filter);
                },
              ),
            ),
            SizedBox(height: 10),

            TabBar(
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              dividerColor: Colors.grey.shade100,
              labelColor: AppColors.primary,
              labelStyle: styleForBoldText.copyWith(fontSize: 14.sp),
              unselectedLabelColor: Colors.grey,
              onTap: (value) {
                setState(() {
                  widget.activeIndex = value;

                  controller.fetchAllBusinesses(
                    controller.providerCategories[value].name,
                  );
                });
              },



              tabs: List.generate(controller.providerCategories.length, (
                index,
              ) {
                log(
                  controller.providerCategories[index].banner +
                      ".................",
                );
                return buildTab(
                  controller.providerCategories[index].name,
                  controller.providerCategories[index].banner,
                  index,
                );
              }),
            ),

            // Expanded to fill remaining space with TabBarView
            Expanded(
              child:
                  controller.isBusinessLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : (controller.businessList.isEmpty)
                      ? Center(
                        child: Text(
                          "No Business Found",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: List.generate(controller.providerCategories.length, (
                            index,
                          ) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  // Text(
                                  //   AppString.exclusivePopular,
                                  //   style: styleForBoldText.copyWith(
                                  //     color: Colors.black,
                                  //     fontSize: 24,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // SizedBox(height: 6),
                                  // Text(
                                  //   AppString.featuredEventSpecialist,
                                  //   style: styleForNormalText.copyWith(
                                  //     color: AppColors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontSize: 16,
                                  //   ),
                                  //   maxLines: 2,
                                  // ),
                                  // SizedBox(height: 14),
                                  SizedBox(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.businessList.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 288,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:
                                                (controller
                                                        .businessList
                                                        .isEmpty)
                                                    ? Center(
                                                      child: Text(
                                                        "No Business Found",
                                                      ),
                                                    )
                                                    : CustomFeatureEventContainer(
                                                      bookType: "businessId",
                                                      id:
                                                          controller
                                                              .businessList[index]
                                                              .id,
                                                      onTap: () {
                                                        Get.toNamed(
                                                          RoutesName
                                                              .businessDetail,
                                                          arguments:
                                                              controller
                                                                  .businessList[index]
                                                                  .id,
                                                        );
                                                      },
                                                      isLiked:
                                                          controller
                                                              .businessList[index]
                                                              .isLiked,
                                                      type:
                                                          controller
                                                              .businessList[index]
                                                              .providerType
                                                              .name,
                                                      imageType:
                                                          ImageType.network,
                                                      imageSrc:
                                                          controller
                                                              .businessList[index]
                                                              .coverImage,
                                                      typeImage:
                                                          AppIcons.businessIcon,
                                                      name:
                                                          controller
                                                              .businessList[index]
                                                              .name,
                                                      location:
                                                          controller
                                                              .businessList[index]
                                                              .address,
                                                      isSponsorShipTrue:
                                                          controller
                                                              .businessList[index]
                                                              .subscriptionType !=
                                                          "none",
                                                      peopleCount:
                                                          controller
                                                              .businessList[index]
                                                              .totalReviews
                                                              .toString(),

                                                      rating:
                                                          controller
                                                              .businessList[index]
                                                              .averageRating
                                                              .toString(),
                                                      doller:
                                                          controller
                                                                      .businessList[index]
                                                                      .priceRange
                                                                      .toLowerCase() ==
                                                                  "budget"
                                                              ? "€"
                                                              : controller
                                                                      .businessList[index]
                                                                      .priceRange
                                                                      .toLowerCase() ==
                                                                  "medium"
                                                              ? "€€"
                                                              : controller
                                                                      .businessList[index]
                                                                      .priceRange
                                                                      .toLowerCase() ==
                                                                  "high"
                                                              ? "€€€"
                                                              : "€€€€",

                                                      imageHeight: 190,
                                                      borderRadius: 8,
                                                      verificationIcon:
                                                          Icons.verified,
                                                      verification:
                                                          controller
                                                              .businessList[index]
                                                              .blueVerifiedBadge,
                                                      likeCount:
                                                          controller
                                                              .businessList[index]
                                                              .totalLikes
                                                              .toString(),
                                                      commentCount:
                                                          (controller
                                                                      .businessList[index]
                                                                      .totalComments >
                                                                  30)
                                                              ? "30+"
                                                              : controller
                                                                  .businessList[index]
                                                                  .totalComments
                                                                  .toString(),
                                                      padding: 5,
                                                      likeOnPressed: () {
                                                        likeUnlike(
                                                          isLike:
                                                              controller
                                                                  .businessList[index]
                                                                  .isLiked,
                                                          businessId:
                                                              controller
                                                                  .businessList[index]
                                                                  .id,
                                                        ).then((value) {
                                                          if (value) {
                                                            if (controller
                                                                .businessList[index]
                                                                .isLiked) {
                                                              controller
                                                                  .businessList[index]
                                                                  .isLiked = false;
                                                              controller
                                                                  .businessList[index]
                                                                  .totalLikes -= 1;
                                                            } else {
                                                              controller
                                                                  .businessList[index]
                                                                  .isLiked = true;
                                                              controller
                                                                  .businessList[index]
                                                                  .totalLikes += 1;
                                                            }
                                                            controller
                                                                .businessList
                                                                .refresh();

                                                            controller
                                                                .businessList
                                                                .refresh();
                                                          }
                                                        });
                                                      },
                                                      commentOnPressed: () {
                                                        log("message");
                                                        showHomePageCommentBottomSheet(
                                                          id:
                                                              controller
                                                                  .businessList[index]
                                                                  .id,
                                                          isBussiness: true,
                                                          context,
                                                          commentController:
                                                              TextEditingController(),
                                                        ).then((value) {
                                                          controller.fetchAllBusinesses(
                                                            controller
                                                                .providerCategories[widget
                                                                    .activeIndex]
                                                                .id,
                                                          );
                                                        });
                                                      },
                                                      bookmarkOnPressed: (
                                                        result,
                                                      ) {
                                                        if (result) {
                                                          controller
                                                              .businessList[index]
                                                              .isWishlisted = true;
                                                          controller
                                                              .businessList
                                                              .refresh();
                                                        }
                                                      },
                                                      isWishlisted:
                                                          controller
                                                              .businessList[index]
                                                              .isWishlisted,
                                                      
                                                    ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildTab(String text, String iconSrc, int index) {
    return Tab(
      height: 65,
      // iconMargin: EdgeInsets.only(bottom: 10.h, top: 5.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            imageSrc: iconSrc,
            imageType: ImageType.svg,
            width: 24.h,
            height: 24.h,
            imageColor:
                widget.activeIndex == index
                    ? AppColors.primary
                    : AppColors.greTab,
          ),

          SizedBox(height: 5.h),
          Flexible(
            child: Text(
              text.replaceAll(
                '\u2028',
                '\n',
              ), // Replace unicode line breaks if any
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styleForBoldText.copyWith(
                fontSize: 14.sp,
                color:
                    widget.activeIndex == index
                        ? AppColors.primary
                        : Colors.grey,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
