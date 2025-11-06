import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';

import '../../../../utils/styles.dart';
import '../../../../widgets/common_image.dart';
import '../../../../widgets/custom_button.dart';
class PromotionScreen extends StatelessWidget {
  PromotionScreen({super.key});

  final BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
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
                      AppString.stepAddPromotion,
                      style: styleForBoldText.copyWith(fontSize: 24.sp),
                    ),
                    SizedBox(height: 20.h),

                    /// Upload button + Image preview
                    Obx(() => Row(
                      children: [
                        InkWell(
                          onTap: controller.promotionImage,
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
                                const SizedBox(width: 8),
                                Text(
                                  (controller.promotionLogo.value.isEmpty &&
                                      controller.promotionLogoNetwork.value.isEmpty)
                                      ? AppString.uploadImage
                                      : AppString.changeImage,
                                  style: styleForBoldText.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        /// Show both images side by side if they exist
                        if(controller.promotionLogo.value.isEmpty)
                          if (controller.promotionLogoNetwork.value.isNotEmpty)
                            CommonImage(
                              imageSrc: "${controller.promotionLogoNetwork.value}",
                              height: 40,
                              width: 40,
                              imageType: ImageType.network,
                            ),
                        const SizedBox(width: 10),
                        if (controller.promotionLogo.value.isNotEmpty)
                          CommonImage(
                            imageSrc: controller.promotionLogo.value,
                            height: 40,
                            width: 40,
                            imageType: ImageType.file,
                          ),
                      ],
                    )),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(
              text: AppString.save,
              isLoading: controller.isLoading.value,
              onTap: () {
                controller.updatePromotionInfo(controller.businessProfileModel.value.id);
              },
            ),),
          ),
        ],
      ),
    );
  }
}
