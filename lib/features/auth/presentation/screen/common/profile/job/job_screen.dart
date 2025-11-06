import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/common/profile/job/jobsearchscreen.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../../core/routers/routes_name.dart';
import '../../../../controller/job/job_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_related_job_Container.dart';
import '../../../../widgets/custom_search_field.dart';

class JobScreen extends StatelessWidget {
  JobScreen({super.key});

  final JobController controller = Get.find<JobController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppString.applyJob,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchField(
              hintText: "Search Job",
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
              onTap: () {
                Get.to(JobSearchScreen());
              },
              controller: searchController,
              readOnly: true,
            ),
            SizedBox(height: 10.h),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.jobCategoryList.isEmpty) {
                return const Center(child: Text("No job categories found."));
              }
              return TabBar(
                controller: controller.tabController,
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
                isScrollable: true,
                indicatorColor: AppColors.primary,
                dividerColor: Colors.grey.shade100,
                labelColor: AppColors.primary,
                labelStyle: styleForBoldText.copyWith(fontSize: 14.sp),
                unselectedLabelColor: Colors.grey,
                onTap: (index) {
                  controller.activeIndex.value = index;
                  final categoryId = controller.jobCategoryList[index]['_id'];
                  log("Selected Category ID: $categoryId");
                  controller.getJobSubCategory(categoryId);
                  controller.getJobUnSubCategory(categoryId);
                },
                tabs: List.generate(controller.jobCategoryList.length, (index) {
                  final categoryData = controller.jobCategoryList[index];
                  return Tab(
                    height: 80,
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "${categoryData['icon']}",
                          height: 24.h,
                          width: 20.w,
                          color:
                              controller.activeIndex.value == index
                                  ? AppColors.primary
                                  : AppColors.greTab,
                          errorBuilder: (context, error, stackTrace) {
                            return CommonImage(
                              imageSrc: AppIcons.job,
                              height: 24.h,
                              width: 20.w,
                              imageType: ImageType.svg,
                            );
                          },
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          categoryData['name'],
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                controller.activeIndex.value == index
                                    ? AppColors.primary
                                    : Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              );
            }),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (controller.isDataLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.jobSubCategoryList.isEmpty &&
                    controller.jobUnSubCategoryList.isEmpty) {
                  return const Center(child: Text("No job listings found."));
                }
                return TabBarView(
                  controller: controller.tabController,
                  children: List.generate(controller.jobCategoryList.length, (
                    tabIndex,
                  ) {
                    final isCurrentTab =
                        controller.activeIndex.value == tabIndex;
                    return isCurrentTab
                        ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.jobSubCategoryList.isNotEmpty)
                                _buildSection(
                                  "Featured Job Offers".tr,
                                  controller.jobSubCategoryList,
                                ),
                              if (controller.jobSubCategoryList.isNotEmpty)
                                SizedBox(height: 30.h),
                              if (controller.jobUnSubCategoryList.isNotEmpty)
                                _buildSection(
                                  "Standard Job Listings".tr,
                                  controller.jobUnSubCategoryList,
                                ),
                              if (controller.jobUnSubCategoryList.isNotEmpty)
                                SizedBox(height: 90.h),
                            ],
                          ),
                        )
                        : const SizedBox();
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // void _showWishlistPopUp(BuildContext context, id, type) {
  //   showDialog(context: context, builder: (context) =>  WishlistPopUp(id: id, type: type,));
  // }

  Widget _buildSection(String title, List jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: styleForBoldText.copyWith(
            fontSize: 24.sp,
            color: AppColors.darkGrey,
          ),
        ),
        Text(
          "Job requests in your area.",
          style: styleForNormalText.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 325,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final locationData = job['location'];
              final coordinates = locationData['coordinates'];
              final lon = coordinates[0];
              final lat = coordinates[1];

              return SizedBox(
                width: 288,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FutureBuilder<String?>(
                    future: controller.getLocationName(lon, lat),
                    builder: (context, snapshot) {
                      return CustomRelatedJobContainer(
                        onTap:
                            () => Get.toNamed(
                              RoutesName.jobDetailScreen,
                              arguments: job['_id'],
                            ), //controller.getJobDetail(job['_id']),
                        id: job['_id'],
                        typeImage: AppIcons.jobIcon,
                        bookType: "jobId",
                        eventJobImage: job['coverImage'],
                        type: job['contractType'],
                        name: job['title'],
                        isSponsorShipTrue: job['subscriptionType'] != "none",
                        location: snapshot.data ?? "Loading...",
               
                        bookmarkOnPressed: () {},
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
