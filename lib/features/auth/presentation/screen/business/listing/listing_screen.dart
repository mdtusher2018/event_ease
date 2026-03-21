import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/engagment%20handle/activity.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/listings_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/create_new_business.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/create_new_event.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/create_new_job.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/edit_new_business.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/edit_new_event.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/edit_new_job.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../core/routers/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';
import '../../../widgets/Sign_up_step/custom_listing_feature_event_container.dart';
import '../../../widgets/business/listing/custom_job_list_widget.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  void _handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'business':
        // Get.toNamed(RoutesName.createNewOption, arguments: {'create': "business"});
        Get.to(() => CreateNewBusiness())!.then((value) {
          loadParentBusinessId();
          listingController.fetchMyBusinesses();
        });
        break;
      case 'event':
        if (PrefsHelper.parentBusinessId.isEmpty) {
          showBusinessRequiredDialog(context, "event");
          return;
        }

        Get.to(() => CreateNewEvent())!.then((value) {
          listingController.fetchMyEvents();
        });
        break;
      case 'job':
        if (PrefsHelper.parentBusinessId.isEmpty) {
          showBusinessRequiredDialog(context, "job");
          return;
        }
        Get.to(() => CreateNewJob())!.then((value) {
          listingController.fetchMyJobs();
        });
        break;
    }
  }

  void showBusinessRequiredDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.business_center, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('business_required'.tr),
            ],
          ),
          content: Text(
            'create_listing_message'.trParams({'type': type}),
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop();

                Get.to(() => CreateNewBusiness())!.then((value) {
                  loadParentBusinessId();
                  listingController.fetchMyBusinesses();
                });
              },
              child: Text(
                'create_business'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  ListingController listingController = Get.put(ListingController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadParentBusinessId();
  }

  RxString parentBusinessId = "".obs;

  void loadParentBusinessId() async {
    parentBusinessId.value = await PrefsHelper.getParentBusinessId() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.listings,
          style: styleForBoldText.copyWith(
            color: AppColors.darkGrey,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        heroTag: 'inspirationScreenFAB',
        shape: const CircleBorder(),
        child: PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (value) => _handleMenuSelection(value, context),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'business',
              child: Text(
                AppString.business,
                style: styleForBoldText.copyWith(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'event',
              child: Text(
                AppString.event,
                style: styleForBoldText.copyWith(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'job',
              child: Text(
                'Job',
                style: styleForBoldText.copyWith(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ],
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            if (parentBusinessId.value.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Create Your 1st business to access the Dashboard".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 220,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          Get.toNamed(RoutesName.signUpStep);
                        },
                        child: Text(
                          "Complete Profile".tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (listingController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                if (listingController.businessList.isNotEmpty)
                  Text(
                    AppString.businessListings,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),
                if (listingController.businessList.isNotEmpty)
                  SizedBox(height: 5.h),
                if (listingController.businessList.isNotEmpty)
                  SizedBox(
                    height: 365,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listingController.businessList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 288,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomListingFeatureEventContainer(
                              onTap: () {
                                Get.toNamed(
                                  RoutesName.businessDetail,
                                  arguments:
                                      listingController.businessList[index].id,
                                );
                              },
                              type: listingController
                                  .businessList[index]
                                  .categoryName,
                              typeImage: AppIcons.businessIcon,
                              name: listingController.businessList[index].name,
                              location:
                                  listingController.businessList[index].address,
                              image: listingController
                                  .businessList[index]
                                  .coverImage,
                              peopleCount: listingController
                                  .businessList[index]
                                  .maxGuest
                                  .toString(),
                              rating:
                                  "${listingController.businessList[index].averageRating}(${listingController.businessList[index].totalReviews})",
                              doller:
                                  listingController
                                          .businessList[index]
                                          .priceRange
                                          .toLowerCase() ==
                                      "budget"
                                  ? "€"
                                  : listingController
                                            .businessList[index]
                                            .priceRange
                                            .toLowerCase() ==
                                        "medium"
                                  ? "€€"
                                  : listingController
                                            .businessList[index]
                                            .priceRange
                                            .toLowerCase() ==
                                        "high"
                                  ? "€€€"
                                  : "€€€€",
                              verificationIcon: Icons.verified,
                              likeCount: listingController
                                  .businessList[index]
                                  .totalLikes
                                  .toString(),
                              commentCount: listingController
                                  .businessList[index]
                                  .totalComments
                                  .toString(),
                              switchValue:
                                  listingController
                                      .businessList[index]
                                      .isActive ??
                                  false,
                              switchOnChanged: (val) {
                                switchBusinessActivity(
                                  businessId:
                                      listingController.businessList[index].id,
                                ).then((value) {
                                  listingController
                                          .businessList[index]
                                          .isActive =
                                      val;
                                  listingController.businessList.refresh();
                                });
                              },
                              onDelete: () {
                                deleteItem(
                                  type: "business",
                                  id: listingController.businessList[index].id,
                                ).then((value) {
                                  listingController.fetchMyBusinesses();
                                });
                              },
                              onAnnouncementTap: () {
                                Get.toNamed(RoutesName.sponsorshipScreen);
                              },
                              onEdit: () {
                                // Get.toNamed(RoutesName.createNewOption, arguments: {'create': "business"});
                                Get.to(
                                  EditNewBusiness(
                                    data: listingController.businessList[index],
                                  ),
                                )!.then((value) {
                                  listingController.fetchMyBusinesses();
                                });
                              },

                              likeOnPressed: () {
                                // Your like logic here
                              },
                              commentOnPressed: () {},
                              bookmarkOnPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20.h),
                if (listingController.eventList.isNotEmpty)
                  Text(
                    AppString.eventListings,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),
                if (listingController.eventList.isNotEmpty)
                  SizedBox(height: 5.h),
                if (listingController.eventList.isNotEmpty)
                  SizedBox(
                    height: 365,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listingController.eventList.length,
                      itemBuilder: (context, index) {
                        String formatDate(String isoDate) {
                          final date = DateTime.parse(isoDate);
                          return "${date.day}-${date.month}-${date.year % 100}";
                        }

                        return SizedBox(
                          width: 288,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomListingFeatureEventContainer(
                              image:
                                  listingController.eventList[index].coverImage,
                              onTap: () {
                                Get.toNamed(
                                  RoutesName.eventDetailScreen,
                                  arguments:
                                      listingController.eventList[index].id,
                                );
                              },
                              type: listingController.eventList[index].category,
                              typeImage: AppIcons.eventIcon,
                              name: listingController.eventList[index].name,
                              location:
                                  listingController.eventList[index].address,
                              peopleCount: formatDate(
                                listingController.eventList[index].startDate
                                    .toString(),
                              ),
                              rating:
                                  "${listingController.eventList[index].averageRating}(${listingController.eventList[index].totalReviews})",
                              doller: "€€€",
                              verificationIcon: Icons.verified,
                              verification: listingController
                                  .eventList[index]
                                  .blueVerifiedBadge,
                              likeCount: listingController
                                  .eventList[index]
                                  .totalLikes
                                  .toString(),
                              commentCount: listingController
                                  .eventList[index]
                                  .totalComments
                                  .toString(),
                              peopleCountIcon: SvgPicture.asset(
                                AppIcons.calenderIcon,
                              ),
                              likeOnPressed: () {},
                              commentOnPressed: () {},
                              bookmarkOnPressed: () {},

                              switchValue:
                                  listingController.eventList[index].isActive ??
                                  false,
                              switchOnChanged: (val) {
                                switchEventActivity(
                                  businessId:
                                      listingController.eventList[index].id,
                                ).then((value) {
                                  listingController.eventList[index].isActive =
                                      val;
                                  listingController.eventList.refresh();
                                });
                              },
                              onDelete: () async {
                                // final response = await ApiService.to.deleteApi(
                                //   AppUrl.geEventDetailsById(listingController.eventList[index].id),
                                // );
                                // if(response.success){
                                //   Get.snackbar("Successfull", response.message);
                                //   listingController.fetchMyEvents();
                                // }else{
                                //   Get.snackbar("Failed".tr,response.message);
                                // }

                                deleteItem(
                                  type: "event",
                                  id: listingController.eventList[index].id,
                                ).then((value) {
                                  listingController.fetchMyEvents();
                                });
                              },

                              onEdit: () {
                                Get.to(
                                  EditEvent(
                                    data: listingController.eventList[index],
                                  ),
                                  arguments:
                                      listingController.eventList[index].id,
                                )!.then((value) {
                                  listingController.fetchMyEvents();
                                });
                              },
                              onAnnouncementTap: () {
                                // Get.toNamed(RoutesName.eventCardScreen);
                                Get.toNamed(RoutesName.sponsorshipScreen);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20.h),
                if (listingController.jobList.isNotEmpty)
                  Text(
                    AppString.jobListings,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 24.sp,
                    ),
                  ),
                if (listingController.jobList.isNotEmpty) SizedBox(height: 5.h),
                if (listingController.jobList.isNotEmpty)
                  SizedBox(
                    height: 380,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listingController.jobList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 288,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomJobListWidget(
                              type: listingController.jobList[index].category,
                              image:
                                  listingController.jobList[index].coverImage,
                              onTap: () {
                                Get.toNamed(
                                  RoutesName.jobDetailScreen,
                                  arguments:
                                      listingController.jobList[index].id,
                                );
                              },
                              typeImage: AppIcons.jobIcon,
                              imageType: ImageType.network,
                              name: listingController.jobList[index].title,
                              location:
                                  listingController.jobList[index].address,
                              verificationIcon: Icons.verified,

                              bookmarkOnPressed: () {},
                              shareOnPressed: () {
                                // final String shareText =
                                //   "Check out this awesome business on EventEase!";

                                Share.share(
                                  AppUrl.shareJob(
                                    listingController.jobList[index].id,
                                  ),
                                );
                              },
                              switchValue:
                                  listingController.jobList[index].isActive,
                              switchOnChanged: (val) {
                                setState(() {
                                  switchjobActivity(
                                    businessId:
                                        listingController.jobList[index].id,
                                  ).then((value) {
                                    listingController.jobList[index].isActive =
                                        val;
                                    listingController.jobList.refresh();
                                  });
                                });
                              },
                              onDelete: () {
                                deleteItem(
                                  type: "job",
                                  id: listingController.jobList[index].id,
                                ).then((value) {
                                  listingController.fetchMyJobs();
                                });
                              },
                              onAnnouncementTap: () {
                                // Get.toNamed(RoutesName.jobCardScreen);
                                Get.toNamed(RoutesName.sponsorshipScreen);
                              },
                              onEdit: () {
                                // Get.toNamed(RoutesName.createNewOption, arguments: {'create': "job"});
                                Get.to(
                                  EditJob(
                                    data: listingController.jobList[index],
                                  ),
                                  arguments:
                                      listingController.jobList[index].id,
                                )!.then((value) {
                                  listingController.fetchMyJobs();
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 10),
              ],
            );
          }),
        ),
      ),
    );
  }
}
