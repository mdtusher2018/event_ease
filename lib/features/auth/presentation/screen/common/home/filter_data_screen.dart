// ignore_for_file: must_be_immutable
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_feature_event_container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/routers/routes_name.dart';

class FilterDataScreen extends StatelessWidget {
  FilterDataScreen({super.key});
  WizardController wizardController = Get.find<WizardController>();
    TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.personalizedResults),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(() {
          return wizardController.isBuissnessFilter.value
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : wizardController.bussnessFilter.isEmpty
              ? Center(
                child: Text(
                  AppString.personalizedResultsIsEmpty,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              )
              : Column(
                children: [
                  // SizedBox(height: 10),
                  // Text(
                  //   AppString.personalizedResults,
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.primary,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Text(
                  //   AppString.weHaveFoundThePerfect,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w500,
                  //     color: const Color(0xFF262621),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
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
                            wizardController.bussnessFilter.length,
                            (index) {
                     
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: CustomFeatureEventContainer(
                                  type: wizardController.bussnessFilter[index].providerType.name,
                                  bookType: "eventId",isLiked: wizardController.bussnessFilter[index].isLiked,
                                  verification: wizardController.bussnessFilter[index].blueVerifiedBadge,
                                  id: wizardController.bussnessFilter[index].id,
                                  onTap: () {
                                    Get.toNamed(RoutesName.eventDetailScreen, arguments: wizardController.bussnessFilter[index].id);
                                  },
                                  typeImage: AppIcons.eventIcon,
                                  imageSrc: wizardController.bussnessFilter[index].coverImage,
                                  likeCount: wizardController.bussnessFilter[index].totalLikes.toString(),
                                  commentCount: wizardController.bussnessFilter[index].totalComments.toString(),
                                  isWishlisted: wizardController.bussnessFilter[index].isWishlisted,
                                  bookmarkOnPressed: (result) {
                                    if(result){
                                      wizardController.bussnessFilter[index].isWishlisted=true;
                                      wizardController.bussnessFilter.refresh();
                                    }
                                  },
                                  name: wizardController.bussnessFilter[index].name,
                                  location: wizardController.bussnessFilter[index].address,
                                  peopleCount: wizardController.bussnessFilter[index].maxGuest.toString(),
                       doller: wizardController.bussnessFilter[index].priceRange.toLowerCase() == "budget"
    ? "€"
    : wizardController.bussnessFilter[index].priceRange.toLowerCase() == "medium"
        ? "€€"
        : wizardController.bussnessFilter[index].priceRange.toLowerCase() == "high"
            ? "€€€"
            : "€€€€",

                                  rating: wizardController.bussnessFilter[index].rating.toString(),
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
