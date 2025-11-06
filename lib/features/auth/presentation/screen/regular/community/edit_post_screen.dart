import 'dart:io';

import 'package:event_ease/features/auth/presentation/controller/community_controller.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/post_details_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/custom_description_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../business/listing/separatly page/widget.dart';

// ignore: must_be_immutable
class EditPostScreen extends StatefulWidget {
  EditPostScreen({super.key, required this.details});
  Rx<PostDetailsModel> details = PostDetailsModel().obs;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final CommunityController controller = Get.find<CommunityController>();

  final List<String> categories = [
    'EVENT PLANNING',
    'TYPE OF EVENT',
    'INSPIRATION & CREATIVE IDEAS',
    'DECOR & SETUP',
    'GIFTS, FAVORS & GADGETS',
    'FOOD & DRINKS',
    'ENTERTAINMENT & MUSIC',
    'OUTFITS & LOOKS',
    'BEAUTY & WELLNESS',
    'LOCATIONS & SUPPLIERS',
    'QUESTIONS, TIPS & ADVICE',
    'PROBLEMS & LAST-MINUTE ISSUES',
    'POLLS & QUIZZES',
  ];

  final List<String> regions = [
    'Abruzzo',
    'Basilicata',
    'Calabria',
    'Campania',
    'Emilia-Romagna',
    'Friuli-Venezia Giulia',
    'Lazio',
    'Liguria',
    'Lombardia',
    'Marche',
    'Molise',
    'Piemonte',
    'Puglia',
    'Sardegna',
    'Sicilia',
    'Toscana',
    'Trentino-Alto Adige',
    'Umbria',
    'Valle d’Aosta',
    'Veneto',
  ];

  List<String> galleryImagePath = [];
  List<String> deletedImagePath = [];

  void pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        galleryImagePath.addAll(pickedFiles.map((file) => file.path));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.titleController.text = widget.details.value.title;
    controller.selectedCategory.value = widget.details.value.category;
    controller.selectedRegion.value = widget.details.value.region;
    controller.eventShortDescriptionController.text =
        widget.details.value.description;
    controller.image.value = widget.details.value.image;

    /// preload gallery images if available

    galleryImagePath = widget.details.value.galleryImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.edit,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(AppString.title),
                CustomTextField(
                  hintText: AppString.eventTitle,
                  isSuffix: false,
                  controller: controller.titleController,
                ),
                SizedBox(height: 12.h),

                _buildLabel(AppString.category),
                _buildDropdown(
                  hint: AppString.category,
                  value: controller.selectedCategory.value,
                  items: categories,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedCategory.value = value;
                    }
                  },
                ),
                SizedBox(height: 12.h),

                _buildLabel("Region"),
                _buildDropdown(
                  hint: "Region",
                  value: controller.selectedRegion.value,
                  items: regions,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedRegion.value = value;
                    }
                  },
                ),
                SizedBox(height: 12.h),

                _buildLabel(AppString.shortDescription),
                CustomDescriptionTextField(
                  hintText: AppString.shortDescription,
                  controller: controller.eventShortDescriptionController,
                ),
                SizedBox(height: 12.h),

                _buildLabel(AppString.image),
                if (controller.image.value.isNotEmpty &&
                    controller.image.value.startsWith("http"))
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(controller.image.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 5,
                        right: 8,
                        child: InkWell(
                          onTap: controller.removeImage,
                          child: Icon(Icons.cancel, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (controller.image.value.isNotEmpty &&
                    !controller.image.value.startsWith("http"))
                  Stack(
                    children: [
                      CommonImage(
                        imageSrc: controller.image.value,
                        imageType: ImageType.file,
                        height: 160.h,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 5,
                        right: 8,
                        child: InkWell(
                          onTap: controller.removeImage,
                          child: Icon(Icons.cancel, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 10.h),
                _buildImagePicker(),
                SizedBox(height: 20.h),

                ReusableImagePicker(
                  title: AppString.imageGallery,
                  isGallery: true,
                  isUploaded: galleryImagePath.isNotEmpty,
                  filePaths: galleryImagePath,
                  onTap: pickGalleryImage,
                  onRemove: (path) {
                    setState(() {
                      galleryImagePath.remove(path);
                      deletedImagePath.add(path);
                    });
                  },
                ),

                SizedBox(height: 20.h),
                CustomButton(
                  isLoading: controller.isLoading.value,
                  text: AppString.post,
                  borderRadius: 16.r,
                  onTap: _handleSubmit,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: styleForBoldText.copyWith(
        color: AppColors.primary,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        fillColor: AppColors.textFieldBg,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      hint: Text(
        hint,
        style: styleForNormalText.copyWith(
          color: AppColors.grey,
          fontSize: 14.sp,
        ),
      ),
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: styleForNormalText.copyWith(
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImagePicker() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.primary,
      ),
      child: ListTile(
        leading: const Icon(Icons.upload, color: Colors.white),
        title: Text(
          controller.image.value.isEmpty
              ? AppString.uploadImage
              : AppString.changeImage,
          style: styleForBoldText.copyWith(color: Colors.white),
        ),
        onTap: () => controller.pickImage(),
      ),
    );
  }

  void _handleSubmit() {
    if (controller.titleController.text.isEmpty ||
        controller.selectedCategory.value.isEmpty ||
        controller.selectedRegion.value.isEmpty ||
        controller.eventShortDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Missing Field",
        "Please fill in all the fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } else {
      controller.editCommentPost(
        widget.details.value.id,
        deletedImage: deletedImagePath,
        galleryLogo: galleryImagePath.map((e) => File(e)).toList(),
      );
    }
  }
}
