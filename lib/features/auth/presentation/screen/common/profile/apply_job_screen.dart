import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/job/job_controller.dart';
import '../../../utils/app_string.dart';
class ApplyJobScreen extends StatelessWidget {
  ApplyJobScreen({super.key});

  final JobController controller = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Get.back();
          controller.cvImage.value = "";
          }, icon: Icon(Icons.arrow_back)),
        title: Text(
          AppString.applyJob,
          style: styleForBoldText.copyWith(fontSize: 23),
        ),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Resume",
              style: styleForBoldText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: controller.pickCv,
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      controller.cvImage.value.isEmpty ? "Upload" : "Change",
                      style: styleForBoldText.copyWith(
                          color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (controller.cvImage.value.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected File:",
                    style: styleForNormalText.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  CommonImage(
                    imageSrc: controller.cvImage.value,
                    imageType: ImageType.file,
                    height: 200,
                    width: 200,
                  ),
                ],
              ),

            const Spacer(),

            CustomButton(
              isLoading: controller.isLoading.value,
              text: AppString.apply,
              borderRadius: 12,
              fontSize: 16,
              onTap: () {
                if (controller.cvImage.value.isEmpty) {
                  Get.snackbar("Missing Resume", "Please upload your resume before applying.");
                } else {
                  log(">>>>>>>>>>>> Job id : ${controller.jobDetailModel.value!.id}");
                  if(controller.jobDetailModel.value!=null)controller.applyJob(controller.jobDetailModel.value!.id);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
