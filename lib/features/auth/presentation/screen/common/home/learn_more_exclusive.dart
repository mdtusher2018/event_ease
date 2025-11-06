// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/models/business_model.dart';
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
import '../../../controller/bussiness controller/BusinessHomePageController.dart';

class LearnMoreExclusivePage extends StatelessWidget {
  final RxList<Business> businesses;
  final String title;

  LearnMoreExclusivePage({
    super.key,
    required this.businesses,
    this.title = "Exclusive Businesses",
  });

  final BusinessController controller = Get.find<BusinessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: Obx(() {

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
                controller: TextEditingController(),
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

            Expanded(
              child:
                  controller.eventsList.isEmpty
                      ? Center(
                        child: Text(
                          "No Planner Event Found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.eventsList.length,
                        itemBuilder: (context, index) {
                          final business = controller.eventsList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CustomFeatureEventContainer(
                              bookType: "businessId",
                              id: business.id,
                              onTap: () {
                                Get.toNamed(
                                  RoutesName.businessDetail,
                                  arguments: business.id,
                                );
                              },
                              isLiked: business.isLiked,
                              type: business.providerType.name,
                              imageType: ImageType.network,
                              imageSrc: business.coverImage,
                              typeImage: AppIcons.businessIcon,
                              isSponsorShipTrue:
                                  business.subscriptionType != "none",
                              name: business.name,
                              location: business.address,
                              peopleCount: business.totalReviews.toString(),
                              rating: business.averageRating.toString(),
                              doller:
                                  business.priceRange.toLowerCase() == "budget"
                                      ? "€"
                                      : business.priceRange.toLowerCase() ==
                                          "medium"
                                      ? "€€"
                                      : business.priceRange.toLowerCase() ==
                                          "high"
                                      ? "€€€"
                                      : "€€€€",
                              imageHeight: 190,
                              borderRadius: 8,
                              verificationIcon: Icons.verified,
                              verification: business.blueVerifiedBadge,
                              likeCount: business.totalLikes.toString(),
                              commentCount:
                                  (business.totalComments > 30)
                                      ? "30+"
                                      : business.totalComments.toString(),
                              padding: 5,
                              likeOnPressed: () {
                                likeUnlike(
                                  isLike: business.isLiked,
                                  businessId: business.id,
                                ).then((value) {
                                  if (value) {
                                    if (business.isLiked) {
                                      business.isLiked = false;
                                      business.totalLikes -= 1;
                                    } else {
                                      business.isLiked = true;
                                      business.totalLikes += 1;
                                    }
                                    businesses.refresh();
                                  }
                                });
                              },
                              commentOnPressed: () {
                                showHomePageCommentBottomSheet(
                                  id: business.id,
                                  isBussiness: true,
                                  context,
                                  commentController: TextEditingController(),
                                ).then((value) {
                                  log("Comment refreshed");
                                });
                              },
                              bookmarkOnPressed: (result) {
                                if (result) {
                                  business.isWishlisted = true;
                                  businesses.refresh(); // if it's an RxList
                                }
                              },
                              isWishlisted: business.isWishlisted,
                              
                            ),
                          );
                        },
                      ),
            ),
          ],
        );
      }),
    );
  }
}
