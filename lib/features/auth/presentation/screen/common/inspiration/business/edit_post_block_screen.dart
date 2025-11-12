// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/inspiration/inspiration_controller.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/inspiration_detail_model.dart';
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

class EditBlockPostScreen extends StatefulWidget {
  EditBlockPostScreen({super.key, required this.postData});
  InspirationDetailModel postData;
  @override
  State<EditBlockPostScreen> createState() => _EditBlockPostScreenState();
}

class _EditBlockPostScreenState extends State<EditBlockPostScreen> {
  BlockController controller = Get.find<BlockController>();
  InspirationController inspirationController =
      Get.find<InspirationController>();

  final List<Map<String, String>> subcategories = [
    {"label": "Getting Started Ideas".tr, "value": "ideas"},
    {"label": "Seasonal Trends".tr, "value": "sessional"},
    {"label": "Real Events That Inspire".tr, "value": "inspire"},
    {"label": "Stile & Mood".tr, "value": "styleMood"},
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Get arguments

    controller.eventTitleController.text = widget.postData.title;
    controller.eventDetailedDescriptionController.text =
        widget.postData.description;
    controller.selectedCategory.value = widget.postData.category.id;
    controller.coverImage.value = widget.postData.coverImage;
    controller.selectedSubCategory.value = widget.postData.subCategory;
    controller.galleryImages.assignAll(widget.postData.imageGallery);
  }

  @override
  Widget build(BuildContext context) {
    inspirationController.getInspirationCategory();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Blog".tr, // 👈 Changed title
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
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
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
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
                      inspirationController.inspirationCategoryList.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['_id'],
                          child: Text(
                            cat['name'],
                            style: styleForNormalText.copyWith(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value!;
                  },
                ),
                SizedBox(height: 10.h),
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

                // ---------- Cover Image ----------
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
                        imageType:
                            controller.coverImage.value.startsWith("http")
                                ? ImageType.network
                                : ImageType.file,
                        height: 100,
                      ),
                      Positioned(
                        top: 5,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            controller.coverImage.value = '';
                          },
                          child: Icon(Icons.cancel, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                // ---------- Gallery Images ----------
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
                  onTap: () => controller.pickGalleryImages(),
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
                                imageType:
                                    path.startsWith("http")
                                        ? ImageType.network
                                        : ImageType.file,
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
                                    child: const Icon(
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

                const SizedBox(height: 24),

                // ---------- Submit Button ----------
                CustomButton(
                  text: "Update Post", // 👈 Changed button text
                  borderRadius: 16,
                  isLoading: controller.isLoading.value,
                  onTap:
                      () => controller.updateBlog(
                        inspirationController.inspirationDetailModel.value.id,
                      ), // 👈 Call update API
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
