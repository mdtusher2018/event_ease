// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/job_applicants_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/cv_image_view.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import '../../../widgets/common_image.dart';

class JobApplicationScreen extends StatelessWidget {
  JobApplicationScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments['id'];
    JobApplicantsController controller = Get.put(
      JobApplicantsController(id: id),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          AppString.jobApplicants,
          style: styleForBoldText.copyWith(fontSize: 23),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomSearchField(
              hintText: AppString.searchEventsLocalBusiness,
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
              suffixIcon: CommonImage(
                imageSrc: AppIcons.filterIcon,
                imageType: ImageType.svg,
                height: 18.h,
                width: 18.w,
              ),
              controller: searchController,
              readOnly: true,
              onTap: () {
                Get.toNamed(RoutesName.search);
              },
              onPressedSuffix: () {
                Get.toNamed(RoutesName.filter);
              },
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Expanded(
                child: controller.applicants.isNotEmpty
                    ?SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    itemCount: controller.applicants.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CommonImage(
                            imageSrc:
                                controller.applicants[index].user.profileImage,
                            imageType: ImageType.network,
                            borderRadius: 100,
                            size: 45,
                          ),
                          title: Text(
                            controller.applicants[index].user.name,
                            style: styleForBoldText.copyWith(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              log(">>>>>>>>>> Cv : ==============${controller.applicants[index].viewCvImage} ");
                              Get.to(
                                CVImageView(
                                  imageUrl:
                                      controller.applicants[index].viewCvImage,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary,
                              ),
                              child: Text(
                                AppString.viewCv,
                                style: styleForBoldText.copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    :Center(child: Text("No data found", style: styleForNormalText,)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
