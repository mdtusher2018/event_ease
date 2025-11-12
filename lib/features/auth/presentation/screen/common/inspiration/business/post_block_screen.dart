import 'package:event_ease/features/auth/presentation/controller/inspiration/inspiration_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/Custom_description_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/inspiration/block_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';

class PostBlockScreen extends StatefulWidget {
  const PostBlockScreen({super.key});

  @override
  State<PostBlockScreen> createState() => _PostBlockScreenState();
}

class _PostBlockScreenState extends State<PostBlockScreen> {
  final List<Map<String, String>> subcategories = [
    {"label": "Getting Started Ideas".tr, "value": "ideas"},
    {"label": "Seasonal Trends".tr, "value": "sessional"},
    {"label": "Real Events That Inspire".tr, "value": "inspire"},
    {"label": "Stile & Mood".tr, "value": "styleMood"},
  ];

  BlockController controller = Get.find<BlockController>();
  InspirationController inspirationController =
      Get.find<InspirationController>();
  @override
  Widget build(BuildContext context) {
    inspirationController.getInspirationCategory();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.blog,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.title,
                style: styleForBoldText.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                hintText: AppString.eventTitle,
                isSuffix: false,
                controller: controller.eventTitleController,
              ),
              SizedBox(height: 10.h),
              Text(
                AppString.category,
                style: styleForBoldText.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 5.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: AppColors.textFieldBg,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ), // Purple border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ), // Purple border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ), // Purple border thicker when focused
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ), // Purple border
                  ),
                ),
                hint: Text(
                  AppString.category,
                  style: styleForNormalText.copyWith(
                    color: AppColors.grey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value:
                    inspirationController.inspirationCategoryList.any(
                          (cat) =>
                              cat['_id'] == controller.selectedCategory.value,
                        )
                        ? controller.selectedCategory.value
                        : null,
                items:
                    inspirationController.inspirationCategoryList
                        .map(
                          (cat) => DropdownMenuItem<String>(
                            value: cat['_id'], // value is a string ID now
                            child: Text(
                              cat['name'],
                              style: styleForNormalText.copyWith(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  controller.selectedCategory.value = value!;
                },
              ),

              SizedBox(height: 10.h),

              // Text(
              //   "Sub Category".tr,
              //   style: styleForBoldText.copyWith(fontSize: 18.sp),
              // ),
              // SizedBox(height: 5.h),
              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     fillColor: AppColors.textFieldBg,
              //     filled: true,
              //     contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //       borderSide: BorderSide(color: AppColors.primary, width: 2),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //       borderSide: BorderSide(color: AppColors.primary, width: 2),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //       borderSide: BorderSide(color: AppColors.primary, width: 2),
              //     ),
              //   ),
              //   hint: Text(
              //     "Select Subcategory",
              //     style: styleForNormalText.copyWith(
              //       color: AppColors.grey,
              //       fontSize: 14.sp,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),

              //   // ✅ set value by checking against "value" not "label"
              //   value: controller.selectedSubCategory.value.isNotEmpty
              //       ? controller.selectedSubCategory.value
              //       : null,

              //   // ✅ items: show label, keep value
              //   items: subcategories.map((sub) {
              //     return DropdownMenuItem<String>(
              //       value: sub['value'], // internal value
              //       child: Text(
              //         sub['label']!, // display label
              //         style: styleForNormalText.copyWith(
              //           color: Colors.black,
              //           fontSize: 15.sp,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     );
              //   }).toList(),

              //   // ✅ store value in controller
              //   onChanged: (value) {
              //     controller.selectedSubCategory.value = value!;
              //   },
              // ),

              // SizedBox(height: 10.h),
              Text(
                AppString.description,
                style: styleForBoldText.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 5.h),
              CustomDescriptionTextField(
                hintText: AppString.detailedDescription,
                controller: controller.eventDetailedDescriptionController,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    "${AppString.coverImage} *",
                    style: styleForBoldText.copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(width: 5.w),
                  controller.coverImage.value.isNotEmpty
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Container(),
                ],
              ),
              SizedBox(height: 5.h),
              InkWell(
                onTap: () => controller.pickImage(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.upload, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        controller.coverImage.value.isNotEmpty
                            ? AppString.changeImage
                            : AppString.uploadImage,
                        style: styleForBoldText.copyWith(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (controller.coverImage.isNotEmpty)
                Stack(
                  children: [
                    CommonImage(
                      imageSrc: controller.coverImage.value,
                      imageType: ImageType.file,
                      height: 100,
                    ),
                    Positioned(
                      top: 5,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          controller.coverImage.value = "";
                        },
                        child: Icon(Icons.cancel, color: Colors.white),
                      ),
                    ),
                  ],
                ),

              // ----------------- Gallery Section -----------------
              Row(
                children: [
                  Text(
                    "${AppString.galleryImages} *",
                    style: styleForBoldText.copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(width: 5.w),
                  controller.galleryImages.isNotEmpty
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Container(),
                ],
              ),
              SizedBox(height: 5.h),
              InkWell(
                onTap: () => controller.pickGalleryImages(), // multiple picker
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.upload, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        controller.galleryImages.isNotEmpty
                            ? "Add More Images".tr
                            : "Upload Images".tr,
                        style: styleForBoldText.copyWith(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Preview selected gallery images in a grid
              if (controller.galleryImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      controller.galleryImages.map((path) {
                        return Stack(
                          children: [
                            CommonImage(
                              imageSrc: path,
                              imageType: ImageType.file,
                              height: 70,
                              width: 70,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap:
                                    () => controller.removeGalleryImage(path),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),

              Spacer(),

              CustomButton(
                text: AppString.post,
                borderRadius: 16,
                isLoading: controller.isLoading.value,
                onTap: () => controller.postBlog(),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
