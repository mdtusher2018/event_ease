import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/inspiration/all_inspiration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/inspiration/inspiration_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';
import '../../common_image.dart';
import 'custom_idea_container.dart';

class RegularInspirationContent extends StatelessWidget {
  RegularInspirationContent({super.key});

  final InspirationController controller = Get.find<InspirationController>();

  // Define your static titles and subtitles for each subcategory (without 'latest')
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: controller.inspirationCategoryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var data = controller.inspirationCategoryList[index];

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
                        controller.allSpecificCategory(
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
                          SizedBox(height: 5.h),
                          SizedBox(
                            width: 100.w,
                            child: Center(
                              child: Text(
                                data['name'],
                                maxLines: 2,
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

            // Regular subcategories
            ListView.builder(
              itemCount: subcategories.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final sub = subcategories[index];
                final staticTitle = sub['title']!;
                final staticSubtitle = sub['subtitle']!;
                final subKey = sub['key'];

                final matchedData = controller.inspirationCategoryGroupList
                    .firstWhere(
                      (e) => e['subCategory'] == subKey,
                      orElse: () => {'inspirations': []},
                    );
                final inspirations = matchedData['inspirations'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + View All
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          staticTitle.tr,
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
                                      title: staticTitle.tr,
                                      subtitle: staticSubtitle.tr,
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
                      staticSubtitle.tr,
                      style: styleForNormalText.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    inspirations.isNotEmpty
                        ? SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: inspirations.length,
                            itemBuilder: (context, i) {
                              final item = inspirations[i];
                              DateTime dateTime = DateTime.parse(
                                item['createdAt'],
                              );
                              String createDate = DateFormat(
                                'dd-MM-yyyy',
                              ).format(dateTime);
                              String createTime = DateFormat(
                                'HH:mm',
                              ).format(dateTime);

                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CustomIdeaContainer(
                                  image: item['coverImage'] ?? "",
                                  title: item['title'] ?? "",
                                  description: item['description'] ?? "",
                                  authorImage: item['author']['profileImage'],
                                  authorName: item['author']['name'],
                                  createDate: createDate,
                                  createTime: createTime,
                                  imageWidth: 356,
                                  onTap: () {
                                    controller.getCategoryDetails(item['_id']);
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
                              "No data found",
                              style: styleForNormalText.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),

            /// ---------- Latest Inspirations Section ----------
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
                        DateTime dateTime = DateTime.parse(item.createdAt);
                        String createDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(dateTime);
                        String createTime = DateFormat(
                          'HH:mm',
                        ).format(dateTime);

                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CustomIdeaContainer(
                            image: item.coverImage,
                            title: item.title,
                            description: item.description,
                            authorImage: item.author.profileImage,
                            authorName: item.author.name,
                            createDate: createDate,
                            createTime: createTime,
                            imageWidth: 356,
                            onTap: () {
                              controller.getCategoryDetails(item.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      }),
    );
  }
}
