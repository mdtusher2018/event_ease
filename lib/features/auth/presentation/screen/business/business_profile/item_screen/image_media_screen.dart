
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';

import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/profile/business_profile_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/common_image.dart';

class ImageMediaScreen extends StatelessWidget {
  ImageMediaScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final BusinessProfileController controller = Get.find<BusinessProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.stepImagesMedia,
                      style: styleForBoldText.copyWith(fontSize: 24.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      AppString.showcaseYourBusinessWithVisualContent,
                      style: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Business Logo Section
                    Row(
                      children: [
                        Text(
                          "${AppString.businessLogo}*",
                          style: styleForBoldText.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Obx(() => controller.logoUploaded.value
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : SizedBox()),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Obx(() => Row(
                      children: [
                        InkWell(
                          onTap: () => controller.businessImage(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload, color: Colors.white, size: 20.r),
                                SizedBox(width: 8.r),
                                Text(
                                  controller.logoUploaded.value
                                      ? AppString.changeImage
                                      : AppString.uploadImage,
                                  style: styleForBoldText.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        controller.businessLogo.value.isNotEmpty
                            ? CommonImage(
                          imageSrc: controller.businessLogo.value,
                          height: 30,
                          width: 30,
                          imageType: ImageType.file,
                        )
                            : controller.businessLogoNetwork.value.isNotEmpty
                            ? CommonImage(
                          imageSrc: controller.businessLogoNetwork.value,
                          height: 30,
                          width: 30,
                          imageType: ImageType.network,
                        )
                            : SizedBox(),
                      ],
                    )),
                    SizedBox(height: 20.h),

                    // Cover Image Section
                    Text(
                      AppString.coverImage,
                      style: styleForBoldText.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(() => Row(
                      children: [
                        InkWell(
                          onTap: () => controller.coverImage(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload, color: Colors.white, size: 20.r),
                                SizedBox(width: 8),
                                Text(
                                  controller.coverLogo.value.isNotEmpty
                                      ? AppString.changeImage
                                      : AppString.uploadImage,
                                  style: styleForBoldText.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        controller.coverLogo.value.isNotEmpty
                            ? CommonImage(
                          imageSrc: controller.coverLogo.value,
                          height: 30,
                          width: 30,
                          imageType: ImageType.file,
                        )
                            : controller.coverLogoNetwork.value.isNotEmpty
                            ? CommonImage(
                          imageSrc: controller.coverLogoNetwork.value,
                          height: 30,
                          width: 30,
                          imageType: ImageType.network,
                        )
                            : SizedBox(),
                      ],
                    )),
                    SizedBox(height: 20.h),

                    // Gallery Images Section
                    Text(
                      AppString.galleryImages,
                      style: styleForBoldText.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(() => Row(
                      children: [
                        InkWell(
                          onTap: () => controller.galleryImage(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload, color: Colors.white, size: 20.r),
                                SizedBox(width: 8.w),
                                Text(
                                  AppString.uploadImage,
                                  style: styleForBoldText.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        if (controller.galleryLogoNetwork.isNotEmpty || controller.galleryLogoLocal.isNotEmpty)
                          Flexible(
                            child: SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...controller.galleryLogoNetwork.map((url) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: CommonImage(
                                        imageSrc: url,
                                        height: 30,
                                        width: 30,
                                        imageType: ImageType.network,
                                      ),
                                    );
                                  }),
                                  ...controller.galleryLogoLocal.map((file) => Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: CommonImage(
                                      imageSrc: file.path,
                                      height: 30,
                                      width: 30,
                                      imageType: ImageType.file,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Fixed Bottom Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(
              text: AppString.save,
              isLoading: controller.isLoading.value,
              onTap: () => controller.updateImageMediaInfo(
                controller.businessProfileModel.value.id,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
