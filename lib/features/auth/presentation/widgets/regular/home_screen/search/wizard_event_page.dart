import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_feature_event_container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WizarEventdDataScreen extends StatefulWidget {
  WizarEventdDataScreen({super.key});

  @override
  State<WizarEventdDataScreen> createState() => _WizarEventdDataScreenState();
}

class _WizarEventdDataScreenState extends State<WizarEventdDataScreen> {
  WizardController wizardController = Get.find<WizardController>();

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return "${date.day}-${date.month}-${date.year % 100}";
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.personalizedResults),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //        Get.toNamed(RoutesName.filter);
        //     },
        //     child: Text("Filter",style: TextStyle(fontSize: 16,color: Colors.red),)),SizedBox(width: 16,)
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(() {
          return wizardController.isEventFilter.value
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : wizardController.eventFilterData.isEmpty
              ? Center(
                child: Text(
                  AppString.personalizedResultsIsEmpty,
                  style: styleForNormalText.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              )
              : Column(
                children: [
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
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(
                            wizardController.eventFilterData.length,
                            (index) {
                              return SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                  child: CustomFeatureEventContainer(
                                    verification:
                                        wizardController
                                            .eventFilterData[index]
                                            .blueVerifiedBadge,
                                    bookType: "eventId",
                                    isSponsorShipTrue:
                                        wizardController
                                            .eventFilterData[index]
                                            .subscriptionType !=
                                        "none",
                                    id:
                                        wizardController
                                            .eventFilterData[index]
                                            .id,
                                    type:
                                        wizardController
                                            .eventFilterData[index]
                                            .category,
                                    imageType: ImageType.network,
                                    imageSrc:
                                        wizardController
                                            .eventFilterData[index]
                                            .coverImage,
                                    onTap:
                                        () => Get.toNamed(
                                          RoutesName.eventDetailScreen,
                                          arguments:
                                              wizardController
                                                  .eventFilterData[index]
                                                  .id,
                                        ),
                                    typeImage: AppIcons.eventIcon,
                                    name:
                                        wizardController
                                            .eventFilterData[index]
                                            .name,
                                    location:
                                        wizardController
                                            .eventFilterData[index]
                                            .address,
                                    peopleCount: formatDate(
                                      wizardController
                                          .eventFilterData[index]
                                          .startDate
                                          .toString(),
                                    ),

                                    rating:
                                        "${wizardController.eventFilterData[index].averageRating}(${wizardController.eventFilterData[index].totalReviews})"
                                            .toString(),
                                    doller:
                                        "€${wizardController.eventFilterData[index].entranceFee}",

                                    imageHeight: 190,
                                    borderRadius: 8,
                                    peopleCountIcon: CommonImage(
                                      imageSrc: AppIcons.calenderIcon,
                                      imageType: ImageType.svg,
                                      size: 16,
                                    ),
                                    verificationIcon: Icons.verified,

                                    isLiked:
                                        wizardController
                                            .eventFilterData[index]
                                            .isLiked,
                                    likeCount:
                                        wizardController
                                            .eventFilterData[index]
                                            .totalLikes
                                            .toString(),
                                    commentCount:
                                        (wizardController
                                                    .eventFilterData[index]
                                                    .totalComments >
                                                30)
                                            ? "30+"
                                            : wizardController
                                                .eventFilterData[index]
                                                .totalComments
                                                .toString(),
                                    padding: 5,
                                    likeOnPressed: () {
                                      eventLikeUnlike(
                                        isLike:
                                            wizardController
                                                .eventFilterData[index]
                                                .isLiked,
                                        eventId:
                                            wizardController
                                                .eventFilterData[index]
                                                .id,
                                      ).then((value) {
                                        if (value) {
                                          if (wizardController
                                              .eventFilterData[index]
                                              .isLiked) {
                                            wizardController
                                                .eventFilterData[index]
                                                .isLiked = false;

                                            wizardController
                                                .eventFilterData[index]
                                                .totalLikes -= 1;
                                          } else {
                                            wizardController
                                                .eventFilterData[index]
                                                .isLiked = true;

                                            wizardController
                                                .eventFilterData[index]
                                                .totalLikes += 1;
                                          }
                                          wizardController.eventFilterData
                                              .refresh();
                                        }
                                      });
                                    },
                                    commentOnPressed: () {
                                      log("message");
                                      showHomePageCommentBottomSheet(
                                        id:
                                            wizardController
                                                .eventFilterData[index]
                                                .id,
                                        isBussiness: false,
                                        context,
                                        commentController:
                                            TextEditingController(),
                                      );
                                    },
                                    bookmarkOnPressed: (result) {
                                      if (result) {
                                        wizardController
                                            .eventFilterData[index]
                                            .isWishlisted = true;
                                        wizardController.eventFilterData
                                            .refresh();
                                      }
                                    },
                                    isWishlisted:
                                        wizardController
                                            .eventFilterData[index]
                                            .isWishlisted,
                                    
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
        }),
      ),
    );
  }
}
