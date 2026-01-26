// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/custom_chip_tab.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/inspiration/all_inspiration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/inspiration/inspiration_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';
import '../../common_image.dart';
import 'custom_idea_container.dart';

class BusinessInspirationContent extends StatefulWidget {
  BusinessInspirationContent({super.key});

  @override
  State<BusinessInspirationContent> createState() =>
      _BusinessInspirationContentState();
}

class _BusinessInspirationContentState
    extends State<BusinessInspirationContent> {
  bool showInspiration = true;

  final InspirationController controller = Get.find<InspirationController>();

  // Static titles & subtitles for subcategories (without latest)
  final List<Map<String, String>> subcategories = [
    {
      "key": "ideas",
      "title": "Getting Started Ideas",
      "subtitle":
          "Not sure where to start? Discover guides, checklists, and practical tips to plan your event step by step.",
    },
    {
      "key": "sessional",
      "title": "Seasonal Trends",
      "subtitle":
          "New season, new ideas! Get inspired by the colors, styles, and setups that are trending this season.",
    },
    {
      "key": "inspire",
      "title": "Real Events That Inspire",
      "subtitle":
          "Events that truly speak to you. See how others organized their celebrations: real photos, ideas, and personal stories.",
    },
    {
      "key": "styleMood",
      "title": "Style & Mood",
      "subtitle":
          "Choose the mood for your event. Boho, luxury, jungle, or romantic? Find the style that reflects your personality.",
    },
  ];

  Widget buildInspirationContent() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regular subcategories
          ...subcategories.map((sub) {
            final subKey = sub['key']!;
            final staticTitle = sub['title']!.tr;
            final staticSubtitle = sub['subtitle']!;

            final matchedData = controller.inspirationCategoryGroupList
                .firstWhere(
                  (e) => e['subCategory'] == subKey,
                  orElse: () => {'inspirations': []},
                );
            final inspirations = matchedData['inspirations'] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$staticTitle:",
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 24.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ViewAllInspirationPage(
                                  title: staticTitle,
                                  subtitle: staticSubtitle,
                                  inspirations: inspirations,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        AppString.viewAll,
                        style: styleForNormalText.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  staticSubtitle,
                  style: styleForNormalText.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                inspirations.isNotEmpty
                    ? SizedBox(
                      height: 310,
                      child: ListView.builder(
                        itemCount: inspirations.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final item = inspirations[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CustomIdeaContainer(
                              image: "${item['coverImage']}",
                              title: item['title'] ?? "",
                              description: item['description'] ?? "",
                              imageWidth: 356,
                              onTap: () {
                                controller.getCategoryDetails(item["_id"]);
                              },
                            ),
                          );
                        },
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "No data found".tr,
                          style: styleForNormalText.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                SizedBox(height: 20.h),
              ],
            );
          }).toList(),

          /// ---------- Latest Publications Section ----------
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.latestList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "No latest inspirations found",
                    style: styleForNormalText.copyWith(fontSize: 14),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Latest Publications".tr,
                  style: styleForBoldText.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Freshly added content. Stay up to date with the latest inspiration uploaded by vendors and our team."
                      .tr,
                  style: styleForNormalText.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.latestList.length,
                    itemBuilder: (context, index) {
                      final item = controller.latestList[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CustomIdeaContainer(
                          image: item.coverImage,
                          title: item.title,
                          description: item.description,
                          authorImage: item.author.profileImage,
                          authorName: item.author.name,
                          imageWidth: 356,
                          onTap: () {
                            controller.getCategoryDetails(item.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            );
          }),
        ],
      );
    });
  }

  Widget buildMyPostContent() {
    return Obx(() {
      final posts = controller.inspirationMyPost;
      if (posts.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "No posts found",
              style: styleForNormalText.copyWith(fontSize: 14),
            ),
          ),
        );
      }

      return Column(
        children:
            posts.map((data) {
              return Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: CustomIdeaContainer(
                  image: "${data["coverImage"]}",
                  title: data["title"] ?? "",
                  description: data["description"] ?? "",
                  imageWidth: 356,
                  onTap: () {
                    controller.getCategoryDetails(data["_id"], isMyPost: true);
                  },
                ),
              );
            }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            AppString.inspiration,
            style: styleForBoldText.copyWith(
              color: AppColors.darkGrey,
              fontSize: 28.sp,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: Text(
            AppString.getInspiredAndDefineYourStyle,
            style: styleForBoldText.copyWith(
              color: AppColors.darkGrey,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10.h),

        // Category horizontal list
        Obx(() {
          final categories = controller.inspirationCategoryList;
          return SizedBox(
            height: 160,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final data = categories[index];
                // ✅ Skip if the name matches any subcategory title
                bool isSubcategory = subcategories.any(
                  (sub) => sub['title'] == data['name'],
                );

                if (isSubcategory) {
                  return const SizedBox.shrink(); // Don't render
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 10.h,
                  ),
                  child: InkWell(
                    onTap: () {
                      controller.allSpecificCategory(data['_id'], data['name']);
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
                        SizedBox(height: 5.h),
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
          );
        }),

        SizedBox(height: 10.h),

        // Tabs
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomChipTab(
              title: AppString.inspiration,
              backgroundColor:
                  showInspiration ? AppColors.primary : Colors.white,
              textColor: showInspiration ? Colors.white : Colors.black,
              onTap: () {
                setState(() {
                  showInspiration = true;
                });
              },
            ),
            SizedBox(width: 10.w),
            CustomChipTab(
              title: AppString.myPost,
              backgroundColor:
                  !showInspiration ? AppColors.primary : Colors.white,
              textColor: !showInspiration ? Colors.white : Colors.black,
              onTap: () {
                setState(() {
                  showInspiration = false;
                  controller.getInspirationMyPost();
                });
              },
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 90.h),
            child:
                showInspiration
                    ? buildInspirationContent()
                    : buildMyPostContent(),
          ),
        ),
      ],
    );
  }
}
