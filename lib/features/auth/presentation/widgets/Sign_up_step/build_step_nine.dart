// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helper/other_helper.dart';
import '../../controller/auth/sign_up_step_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/styles.dart';
import '../common_image.dart';
import '../custom_button.dart';

class BuildStepNine extends StatefulWidget {
   BuildStepNine({super.key,  this.onComplete, this.bottomButtons = true, this.titleBool = true});
   VoidCallback? onComplete;
  bool bottomButtons;
  bool titleBool;

  @override
  State<BuildStepNine> createState() => _BuildStepNineState();
}

class _BuildStepNineState extends State<BuildStepNine> {
  final _formKey = GlobalKey<FormState>();
  SignUpStepController controller = Get.find<SignUpStepController>();

  // Track if images have been uploaded
  bool promotionUploaded = false;


  void promotionImage () async {
    controller.promotionLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.titleBool==true)
              Center(
                child: Text(
                  AppString.signUpForPianoFestaBusiness,
                  style: styleForBoldText.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if(widget.titleBool==true)
               SizedBox(height: 20.h),
            if(widget.titleBool==true)
              Text(
                AppString.stepAddPromotion,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),
            if(widget.titleBool==false)
              Text(AppString.addPromotion,
                style: styleForBoldText.copyWith(fontSize: 24.sp),
              ),

             SizedBox(height: 20.h),

            Row(
              children: [
                InkWell(
                  onTap: () => promotionImage(),
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
                        controller.promotionLogo.value.isEmpty?
                        Text(
                          AppString.uploadImage,
                          style: styleForBoldText.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ): Text(
                          AppString.changeImage,
                          style: styleForBoldText.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Obx(() => controller.promotionLogo.value.isNotEmpty? CommonImage(imageSrc: controller.promotionLogo.value, height: 30, width: 30,imageType: ImageType.file,):SizedBox(),)

              ],
            ),

             SizedBox(height: 20.h),



            if (widget.bottomButtons == true)
              const Spacer(),

            if (widget.bottomButtons == true)
            Obx(() => CustomButton(
              isLoading: controller.isLoading.value,
              text: AppString.submit,
              onTap: widget.onComplete,
              icon: Icons.arrow_forward,
            ),),
          ],
        ),
      ),
    );
  }
}