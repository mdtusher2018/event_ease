import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/controller/bussiness%20controller/BusinessHomePageController.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/event_learn_more_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/learn_more_exclusive.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/learn_more_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_post_container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/custom_chip_tab.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/build_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/helper/prefs_helper.dart';
import '../../../controller/community_controller.dart';
import '../../../controller/inspiration/inspiration_controller.dart';
import '../../../controller/notification/notification_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/custom_feature_event_container.dart';
import '../../../widgets/drawer/custom_drawer.dart';
import '../../../widgets/regular/home_screen/learn_more_button.dart';
import '../../../widgets/regular/home_screen/go_to_the_guide.dart';
import '../../../widgets/regular/home_screen/show_comment_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool)? onDrawerChanged; // Callback for drawer state changes

  HomeScreen({super.key, this.onDrawerChanged}); // Constructor
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  TabController? _tabController;
  CommunityController communityController = Get.find<CommunityController>();
  InspirationController inspirationController =
      Get.find<InspirationController>();
  int activeIndex = 0;
  int selectedIndex = 1;

  final BusinessController controller = Get.put(BusinessController());
  final NotificationController notificationController =
      Get.find<NotificationController>();

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
      setState(() {});
    }
  }

  // Method to handle drawer opening
  void _onDrawerOpened() {
    if (widget.onDrawerChanged != null) {
      widget.onDrawerChanged!(true);
    }
  }

  // Method to handle drawer closing
  void _onDrawerClosed() {
    if (widget.onDrawerChanged != null) {
      widget.onDrawerChanged!(false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildTab(String text, String iconSrc, int index) {
    return Tab(
      height: 60,
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
                activeIndex == index ? AppColors.primary : AppColors.greTab,
          ),

          SizedBox(height: 5.h),
          Flexible(
            child: Text(
              text.replaceFirst(
                ' ',
                '\n',
              ), // Replace unicode line breaks if any
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styleForBoldText.copyWith(
                fontSize: 14.sp,
                color: activeIndex == index ? AppColors.primary : Colors.grey,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: CustomDrawer(),
      drawerEnableOpenDragGesture: true, // Enable drawer open gesture
      onDrawerChanged: (isOpened) {
        // Trigger callback when drawer opens/closes
        if (isOpened) {
          _onDrawerOpened();
        } else {
          _onDrawerClosed();
        }
      },
      body: Obx(() {
        if (controller.providerCategories.isEmpty || _tabController == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        log(">>>>>> Address : ${PrefsHelper.address}");
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 60.h,
            left: 16.w,
            right: 16.w,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(
                globalKey: _globalKey,
                notificationOnPressed: () {
                  Get.toNamed(RoutesName.notification)!.then((value) {
                    notificationController.homePageNotification.value = false;
                  });
                },
              ),
              // ElevatedButton(onPressed: (){
              //   SocketServices.notificationSocketMethod();
              //   var listeners = SocketServices.socket.hasListeners("notification::${PrefsHelper.userId}");
              //   log("hase liseten===$listeners");
              // }, child: Text("click")),
              SizedBox(height: 23.h),
              CustomSearchField(
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
                controller: searchController,
                readOnly: true,
                onTap: () {
                  Get.toNamed(RoutesName.search);
                },
                onPressedSuffix: () {
                  Get.toNamed(RoutesName.filter);
                },
              ),
              SizedBox(height: 10.h),

              controller.providerCategories.isEmpty
                  ? Center(
                    child: Text(
                      AppString.noDataFound,
                      style: styleForNormalText.copyWith(color: Colors.black),
                    ),
                  )
                  : Column(
                    children: [
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
                            activeIndex = value;
                            log(
                              controller.providerCategories[activeIndex].name +
                                  "",
                            );
                            controller.fetchAllBusinesses(
                              controller.providerCategories[value].name,
                            );
                          });
                        },
                        tabs: List.generate(
                          controller.providerCategories.length,
                          (index) {
                            log(
                              "${controller.providerCategories[index].banner}.................",
                            );
                            return buildTab(
                              controller.providerCategories[index].name,
                              controller.providerCategories[index].banner,
                              index,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),

                      SizedBox(
                        height: 500,
                        child: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(controller.providerCategories.length, (
                            index,
                          ) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(
                                  AppString.exclusivePopular,
                                  style: styleForBoldText.copyWith(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  AppString.featuredEventSpecialist,
                                  style: styleForNormalText.copyWith(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 14),
                                if (controller.businessList.isNotEmpty)
                                  SizedBox(
                                    height: 357,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: controller.businessList.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 288,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:
                                                controller
                                                        .isBusinessLoading
                                                        .value
                                                    ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                    : (controller
                                                        .businessList
                                                        .isEmpty)
                                                    ? Text(
                                                      AppString.noBusinessFound,
                                                    )
                                                    : CustomFeatureEventContainer(
                                                      bookType: "businessId",
                                                      isSponsorShipTrue:
                                                          controller
                                                              .businessList[index]
                                                              .subscriptionType !=
                                                          "none",
                                                      id:
                                                          controller
                                                              .businessList[index]
                                                              .id,

                                                      isLiked:
                                                          controller
                                                              .businessList[index]
                                                              .isLiked,
                                                      isWishlisted:
                                                          controller
                                                              .businessList[index]
                                                              .isWishlisted,
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
                                                      onTap:
                                                          () => Get.toNamed(
                                                            RoutesName
                                                                .businessDetail,
                                                            arguments:
                                                                controller
                                                                    .businessList[index]
                                                                    .id,
                                                          )!.then((value) {
                                                            log(
                                                              controller
                                                                      .providerCategories[activeIndex]
                                                                      .name +
                                                                  "",
                                                            );
                                                            controller
                                                                .fetchAllBusinesses(
                                                                  controller
                                                                      .providerCategories[activeIndex]
                                                                      .name,
                                                                );
                                                          }),
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
                                                      peopleCount:
                                                          controller
                                                              .businessList[index]
                                                              .maxGuest
                                                              .toString(),

                                                      rating:
                                                          // controller
                                                          //     .businessList[index]
                                                          //     .averageRating
                                                          //     .toString(),
                                                          "${controller.businessList[index].averageRating}(${controller.businessList[index].totalReviews})",
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
                                                          log(
                                                            controller
                                                                    .providerCategories[activeIndex]
                                                                    .name +
                                                                "",
                                                          );
                                                          controller
                                                              .fetchAllBusinesses(
                                                                controller
                                                                    .providerCategories[activeIndex]
                                                                    .name,
                                                              );
                                                        });
                                                      },
                                                      bookmarkOnPressed: (
                                                        result,
                                                      ) {
                                                        log(
                                                          controller
                                                                  .businessList[index]
                                                                  .isWishlisted
                                                                  .toString() +
                                                              ".....................",
                                                        );
                                                        if (result) {
                                                          log(
                                                            controller
                                                                    .businessList[index]
                                                                    .isWishlisted
                                                                    .toString() +
                                                                ".........2............",
                                                          );
                                                          controller
                                                              .businessList[index]
                                                              .isWishlisted = true;
                                                          controller
                                                              .businessList
                                                              .refresh();
                                                          controller
                                                              .businessList
                                                              .refresh();
                                                          log(
                                                            controller
                                                                    .businessList[index]
                                                                    .isWishlisted
                                                                    .toString() +
                                                                "...........3..........",
                                                          );
                                                        }
                                                      },
                                                    ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 14),
                                LearnMoreButton(
                                  onTap: () {
                                    // Get.toNamed(RoutesName.learnMore);
                                    Get.to(
                                      LearnMoreScreen(activeIndex: activeIndex),
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 4),
                    ],
                  ),

              if (PrefsHelper.myRole == "user")
                GoToTheGuide(
                  onPressed: () {
                    Get.toNamed(RoutesName.guide);
                  },
                ),
              if (PrefsHelper.myRole == "user") SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  Text(
                    "${AppString.whatHappening}?",
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    "${AppString.discoverAllTheEventsAroundYou}!",
                    style: styleForNormalText.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                    maxLines: 2,
                  ),

                  if (controller.subscriptionList.isNotEmpty)
                    const SizedBox(height: 14),

                  // Horizontal List of Events
                  (controller.subscriptionList.isEmpty)
                      ? Text(
                        "No data found".tr,
                        style: styleForNormalText.copyWith(color: Colors.black),
                      )
                      : SizedBox(
                        height: 357,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.subscriptionList.length,
                          itemBuilder: (context, index) {
                            String formatDate(String isoDate) {
                              final date = DateTime.parse(isoDate);
                              return "${date.day}-${date.month}-${date.year % 100}";
                            }

                            return SizedBox(
                              width: 288,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CustomFeatureEventContainer(
                                  bookType: "eventId",

                                  verification:
                                      controller
                                          .subscriptionList[index]
                                          .blueVerifiedBadge,
                                  id: controller.subscriptionList[index].id,
                                  isSponsorShipTrue:
                                      controller
                                          .subscriptionList[index]
                                          .subscriptionType !=
                                      "none",
                                  type:
                                      controller
                                          .subscriptionList[index]
                                          .category,
                                  imageType: ImageType.network,
                                  imageSrc:
                                      controller
                                          .subscriptionList[index]
                                          .coverImage,
                                  onTap:
                                      () => Get.toNamed(
                                        RoutesName.eventDetailScreen,
                                        arguments:
                                            controller
                                                .subscriptionList[index]
                                                .id,
                                      ),
                                  typeImage: AppIcons.eventIcon,
                                  name: controller.subscriptionList[index].name,
                                  location:
                                      controller
                                          .subscriptionList[index]
                                          .address,
                                  peopleCount: formatDate(
                                    controller.subscriptionList[index].startDate
                                        .toString(),
                                  ),

                                  rating:
                                      "${controller.subscriptionList[index].averageRating}(${controller.subscriptionList[index].totalReviews})"
                                          .toString(),
                                  doller:
                                      "€${controller.subscriptionList[index].entranceFee}",

                                  imageHeight: 190,
                                  borderRadius: 8,
                                  peopleCountIcon: CommonImage(
                                    imageSrc: AppIcons.calenderIcon,
                                    imageType: ImageType.svg,
                                    size: 16,
                                  ),
                                  verificationIcon: Icons.verified,
                                  likeCount:
                                      controller
                                          .subscriptionList[index]
                                          .totalLikes
                                          .toString(),
                                  isLiked:
                                      controller
                                          .subscriptionList[index]
                                          .isLiked,
                                  commentCount:
                                      (controller
                                                  .subscriptionList[index]
                                                  .totalComments >
                                              30)
                                          ? "30+"
                                          : controller
                                              .subscriptionList[index]
                                              .totalComments
                                              .toString(),
                                  padding: 5,
                                  likeOnPressed: () {
                                    eventLikeUnlike(
                                      isLike:
                                          controller
                                              .subscriptionList[index]
                                              .isLiked,
                                      eventId:
                                          controller.subscriptionList[index].id,
                                    ).then((value) {
                                      if (value) {
                                        if (controller
                                            .subscriptionList[index]
                                            .isLiked) {
                                          controller
                                              .subscriptionList[index]
                                              .isLiked = false;
                                          controller
                                              .subscriptionList[index]
                                              .totalLikes -= 1;
                                        } else {
                                          controller
                                              .subscriptionList[index]
                                              .isLiked = true;
                                          controller
                                              .subscriptionList[index]
                                              .totalLikes += 1;
                                        }
                                        controller.subscriptionList.refresh();
                                      }
                                    });
                                  },
                                  commentOnPressed: () {
                                    log("message");
                                    showHomePageCommentBottomSheet(
                                      id: controller.subscriptionList[index].id,
                                      isBussiness: false,
                                      context,
                                      commentController:
                                          TextEditingController(),
                                    ).then((value) {
                                      controller.fetchAllSubscriptionEvents();
                                    });
                                  },
                                  bookmarkOnPressed: (result) {
                                    if (result) {
                                      controller
                                          .subscriptionList[index]
                                          .isWishlisted = true;
                                      controller.subscriptionList.refresh();
                                    }
                                  },
                                  isWishlisted:
                                      controller
                                          .subscriptionList[index]
                                          .isWishlisted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                  const SizedBox(height: 14),

                  // Learn More Button
                  if (controller.subscriptionList.isNotEmpty)
                    LearnMoreButton(
                      onTap: () {
                        // Get.toNamed(RoutesName.eventLearnMoreScreen);
                        Get.to(
                          EventLearnMoreScreen(
                            subscriptionList: controller.subscriptionList,
                          ),
                        );
                      },
                    ),
                ],
              ),

              if (controller.inspirationList.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 32.h),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: AppColors.primary,
                            width: 61,
                            height: 2,
                          ),
                          SizedBox(width: 2.h),
                          Text(
                            "#${AppString.inspirations}",
                            style: styleForBoldText.copyWith(
                              color: AppColors.darkGrey,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(width: 2.h),
                          Container(
                            color: AppColors.primary,
                            width: 61,
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        AppString.letYourselfBeInspiredToCreateYourPerfectEvent,
                        style: styleForNormalText.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount:
                            inspirationController
                                .inspirationCategoryList
                                .length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data =
                              inspirationController
                                  .inspirationCategoryList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 10.h,
                            ),
                            child: InkWell(
                              onTap: () {
                                inspirationController.allSpecificCategory(
                                  data['_id'],
                                  data['name'],
                                );
                              },
                              child: Column(
                                children: [
                                  CommonImage(
                                    imageSrc: "${data['banner']}",
                                    imageType: ImageType.network,
                                    borderRadius: 50.r,
                                    height: 74.h,
                                    width: 74.w,
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    width: 100.w,
                                    child: Center(
                                      child: Text(
                                        data['name'],
                                        maxLines: 3,
                                        style: styleForNormalText.copyWith(
                                          fontSize: 14,
                                          color: AppColors.darkGrey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 20.h),

              if (PrefsHelper.myRole == "user") ...[
                Center(
                  child: Text(
                    AppString.community,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    AppString.connectWithOtherUser,
                    style: styleForNormalText.copyWith(
                      color: AppColors.grey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                Row(
                  children: [
                    CustomChipTab(
                      backgroundColor: Colors.white,
                      title: AppString.newPost,
                      textColor: AppColors.primary,
                      isClick: selectedIndex == 1,
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    CustomChipTab(
                      backgroundColor: Colors.white,
                      title: AppString.mostComment,
                      textColor: AppColors.primary,
                      isClick: selectedIndex == 2,
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    CustomChipTab(
                      backgroundColor: Colors.white,
                      title: AppString.mostViewed,
                      textColor: AppColors.primary,
                      isClick: selectedIndex == 3,
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                    ),
                  ],
                ),

                if (selectedIndex == 1)
                  communityController.latestPostList.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                            communityController.latestPostList.length > 6
                                ? 5
                                : communityController
                                    .latestPostList
                                    .length, //communityController.latestPostList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = communityController.latestPostList[index];

                          String isoTime = data.createdAt;

                          DateTime dateTime = DateTime.parse(isoTime);

                          // Format as dd-MM-yyyy
                          String createDate = DateFormat(
                            'dd-MM-yyyy',
                          ).format(dateTime); // 👉 14-08-2025

                          // Format time (HH:mm)
                          String createTime = DateFormat(
                            'HH:mm',
                          ).format(dateTime); // 👉 11:08

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomPostContainer(
                              profileImage: "${data.creator.profileImage}",
                              title: data.title,
                              description: data.description,
                              name: data.creator.name,
                              time: "$createDate  •  $createTime",
                              commentCount: data.totalComments.toString(),
                              likeCount: data.totalLikes.toString(),
                              onTap: () {
                                log(
                                  ">>>>>>>>>>>>>>>> id go to next page : ${data.id}",
                                );
                                Get.toNamed(
                                  RoutesName.commentPost,
                                  arguments: {
                                    'id': data.id,
                                    'type': "PostCommunity",
                                  },
                                );
                              },
                              isLiked: data.isLiked ? true : false,
                              onTapLike: () {
                                data.isLiked
                                    ? communityController.unLikePost(data.id)
                                    : communityController.likePost(data.id);
                              },
                              onTapComment: () {
                                showCommentBottomSheet(
                                  context,
                                  commentController:
                                      communityController.commentController,
                                  onPressed: () {
                                    communityController.commentPost(
                                      data.id,
                                      context,
                                    ); // ✅ Pass context
                                  },
                                );
                              },
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          AppString.noDataFound,
                          style: styleForNormalText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),

                if (selectedIndex == 2)
                  communityController.mostCommentPostList.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                            communityController.mostCommentPostList.length > 6
                                ? 5
                                : communityController
                                    .mostCommentPostList
                                    .length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data =
                              communityController.mostCommentPostList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomPostContainer(
                              profileImage: data.creator.profileImage,
                              title: data.title,
                              description: data.description,
                              name: data.creator.name,
                              time: "",
                              commentCount: data.totalComments.toString(),
                              likeCount: data.totalLikes.toString(),
                              onTap: () {
                                log(
                                  ">>>>>>>>>>>>>>>> id go to next page : ${data.id}",
                                );
                                Get.toNamed(
                                  RoutesName.commentPost,
                                  arguments: {
                                    'id': data.id,
                                    'type': "PostCommunity",
                                  },
                                );
                              },
                              isLiked: data.isLiked ? true : false,
                              onTapLike: () {
                                data.isLiked
                                    ? communityController.unLikePost(data.id)
                                    : communityController.likePost(data.id);
                              },
                              onTapComment: () {
                                showCommentBottomSheet(
                                  context,
                                  commentController:
                                      communityController.commentController,
                                  onPressed: () {
                                    communityController.commentPost(
                                      data.id,
                                      context,
                                    ); // ✅ Pass context
                                  },
                                );
                              },
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          AppString.noDataFound,
                          style: styleForNormalText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),

                if (selectedIndex == 3)
                  communityController.mostViewedPostList.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                            communityController.mostViewedPostList.length > 6
                                ? 5
                                : communityController.mostViewedPostList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data =
                              communityController.mostViewedPostList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomPostContainer(
                              profileImage: "${data.creator.profileImage}",
                              title: data.title,
                              description: data.description,
                              name: data.creator.name,
                              time: "",
                              commentCount: data.totalComments.toString(),
                              likeCount: data.totalLikes.toString(),
                              onTap: () {
                                log(
                                  ">>>>>>>>>>>>>>>> id go to next page : ${data.id}",
                                );
                                Get.toNamed(
                                  RoutesName.commentPost,
                                  arguments: {
                                    'id': data.id,
                                    'type': "PostCommunity",
                                  },
                                );
                              },
                              isLiked: data.isLiked ? true : false,
                              onTapLike: () {
                                data.isLiked
                                    ? communityController.unLikePost(data.id)
                                    : communityController.likePost(data.id);
                              },
                              onTapComment: () {
                                showCommentBottomSheet(
                                  context,
                                  commentController:
                                      communityController.commentController,
                                  onPressed: () {
                                    communityController.commentPost(
                                      data.id,
                                      context,
                                    ); // ✅ Pass context
                                  },
                                );
                              },
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          AppString.noDataFound,
                          style: styleForNormalText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),

                SizedBox(height: 10.h),
              ],

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  Text(
                    "${AppString.eventPlanner}?",
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    "${AppString.tailorMadeSolutionsForYourEvent}!",
                    style: styleForNormalText.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 14),

                  // Horizontal List of Events
                  SizedBox(
                    height: 357,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.eventsList.length,
                      itemBuilder: (context, index) {
                        final event = controller.eventsList[index];

                        return SizedBox(
                          width: 288,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomFeatureEventContainer(
                              verification: event.blueVerifiedBadge,
                              bookType: "businessId",
                              isSponsorShipTrue:
                                  event.subscriptionType != "none",
                              id: event.id,
                              type: event.providerType.name,
                              imageType: ImageType.network,
                              imageSrc: event.coverImage,
                              onTap:
                                  () => Get.toNamed(
                                    RoutesName.businessDetail,
                                    arguments: event.id,
                                  ),
                              typeImage: AppIcons.eventIcon,
                              name: event.name,
                              location: event.address,
                              peopleCount: event.maxGuest.toString(),
                              rating:
                                  "${event.averageRating}(${event.totalReviews})"
                                      .toString(),
                              doller:
                                  event.priceRange.toLowerCase() == "budget"
                                      ? "€"
                                      : event.priceRange.toLowerCase() ==
                                          "medium"
                                      ? "€€"
                                      : event.priceRange.toLowerCase() == "high"
                                      ? "€€€"
                                      : "€€€€",
                              imageHeight: 190,
                              borderRadius: 8,
                              peopleCountIcon: CommonImage(
                                imageSrc: AppIcons.calenderIcon,
                                imageType: ImageType.svg,
                                size: 16,
                              ),
                              verificationIcon: Icons.verified,
                              isLiked: event.isLiked,
                              likeCount: event.totalLikes.toString(),
                              commentCount:
                                  (event.totalComments > 30)
                                      ? "30+"
                                      : event.totalComments.toString(),
                              padding: 5,
                              likeOnPressed: () {
                                eventLikeUnlike(
                                  isLike: event.isLiked,
                                  eventId: event.id,
                                ).then((value) {
                                  if (value) {
                                    if (event.isLiked) {
                                      event.isLiked = false;
                                      event.totalLikes -= 1;
                                    } else {
                                      event.isLiked = true;
                                      event.totalLikes += 1;
                                    }
                                    controller.eventsList.refresh();
                                  }
                                });
                              },
                              commentOnPressed: () {
                                showHomePageCommentBottomSheet(
                                  id: event.id,
                                  isBussiness: false,
                                  context,
                                  commentController: TextEditingController(),
                                ).then((value) {
                                  controller.fetchAllEvents();
                                });
                              },
                              bookmarkOnPressed: (result) {
                                if (result) {
                                  event.isWishlisted = true;
                                  controller.eventsList.refresh();
                                }
                              },
                              isWishlisted: event.isWishlisted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Learn More Button
                  if (controller.eventsList.isNotEmpty)
                    LearnMoreButton(
                      onTap: () {
                        Get.to(
                          LearnMoreExclusivePage(
                            businesses: controller.eventsList,
                          ),
                        );
                      },
                    ),
                ],
              ),

              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }
}
