import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_feature_event_container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/search/wizard_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WizardDataScreen extends StatefulWidget {
  final bool isBussiness;
  const WizardDataScreen({super.key,this.isBussiness=false});

  @override
  State<WizardDataScreen> createState() => _WizardDataScreenState();
}

class _WizardDataScreenState extends State<WizardDataScreen> {
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
          return wizardController.isFilter.value
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : wizardController.filterData.isEmpty
              ? Center(
                child: Text(
                  AppString.personalizedResultsIsEmpty,
                  style: styleForNormalText.copyWith(fontSize: 18, color: Colors.black)
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
                          ...List.generate(wizardController.filterData.length, (
                            index,
                          ) {
                       
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: CustomFeatureEventContainer(
                                bookType: "eventId",
                                type: wizardController.filterData[index].providerType.name,
                                isWishlisted: wizardController.filterData[index].isWishlisted,
                                bookmarkOnPressed: (p0) {
                                  if(p0){
                                    wizardController.filterData[index].isWishlisted=true;
                                    wizardController.filterData.refresh();
                                  }
                                },
                                isSponsorShipTrue: wizardController.filterData[index]. subscriptionType !=
                                                          "none",
                                verification: wizardController.filterData[index].blueVerifiedBadge,
                                id: wizardController.filterData[index].id,
                                typeImage:(wizardController.filterData[index].type=="business")?AppIcons.businessIcon: AppIcons.eventIcon,
                                imageSrc: wizardController.filterData[index].coverImage,
                                likeCount: wizardController.filterData[index].totalLikes.toString(),
                                commentCount: wizardController.filterData[index].totalComments.toString(),
                                name: wizardController.filterData[index].name,
                                location: wizardController.filterData[index].address,
                                peopleCount: wizardController.filterData[index].maxGuest.toString(),
                                doller:  wizardController.filterData[index].priceRange.toLowerCase() == "budget"
    ? "€"
    : wizardController.filterData[index].priceRange.toLowerCase() == "medium"
        ? "€€"
        : wizardController.filterData[index].priceRange.toLowerCase() == "high"
            ? "€€€"
            : "€€€€",

                                rating: wizardController.filterData[index].rating.toString(),
                                isLiked: wizardController.filterData[index].isLiked,
                                likeOnPressed: (){

                                  wizardController.filterData[index].isLiked
                                      ? wizardController.unLikePostPersonalized(wizardController.filterData[index].id, context, wizardController.filterData[index]).then((value){
                                        setState(() {

                                        });
                                  })
                                      : wizardController.likePostPersonalized(wizardController.filterData[index].id,context, wizardController.filterData[index]).then((value){
                                        setState(() {

                                        });
                                  });
                                },
                                commentOnPressed: (){
                                  wizardController.getComment(id: wizardController.filterData[index].id);
                                  WizardBottomSheet(context, commentController: wizardController.commentController.value, onPressed: (){
                                    wizardController.commentPost(wizardController.filterData[index].id, context);
                                  });
                                },
                              ),
                            );
                          }),
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
