// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/widgets/fullimage.dart';
import 'package:event_ease/features/auth/presentation/screen/common/inspiration/business/edit_post_block_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/inspiration/inspiration_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/common_image.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});

  InspirationController controller = Get.find<InspirationController>();

  @override
  Widget build(BuildContext context) {
    final String type = Get.arguments['type'];
    final String id = Get.arguments['id'];
    final bool isMyPost = Get.arguments['isMyPost'] ?? false;
    log(">>>>>> Type: $type");
    controller.getCategoryDetails(id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.post,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (String value) async{
              if (value == 'report') {
                Get.toNamed(
                  RoutesName.report,
                  arguments: {'id': id, 'type': type},
                );
              }
              if (value == "Edit") {
                Get.to(
                  EditBlockPostScreen(postData: controller.inspirationDetailModel.value,),
              
                )!.then((value) {
                  controller.getCategoryDetails(id);
                });
              }
              if (value == "Delete") {
                final response=await ApiService.to.deleteApi(AppUrl.deleteMyPost(id));
                log(response.data.toString());
                if (true) {
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  if (!isMyPost)
                    PopupMenuItem<String>(
                      value: "report",
                      child: Row(
                        children: [
                          Text(AppString.report, style: styleForNormalText),
                        ],
                      ),
                    ),

                  if (isMyPost)
                    PopupMenuItem<String>(
                      value: "Edit",
                      child: Text(
                        AppString.edit,
                        style: styleForBoldText.copyWith(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (isMyPost)
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: Text(
                        "Delete",
                        style: styleForBoldText.copyWith(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Obx(
          () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImage(
                  imageSrc: controller.inspirationDetailModel.value.coverImage,
                  imageType: ImageType.network,
                  height: 200.h,
                  width: double.infinity,
                ),
                SizedBox(height: 10.h),
                Text(
                  controller.inspirationDetailModel.value.title,
                  style: styleForBoldText.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 5.h),
            
                Row(
                  children: [
                    if (controller.inspirationDetailModel.value.authorImage.isNotEmpty)
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          controller.inspirationDetailModel.value.authorImage,
                        ),
                        radius: 12, // responsive radius
                      ),
                    if (controller.inspirationDetailModel.value.authorImage.isNotEmpty)
                      SizedBox(width: 6),
            
                    // Author Name
                    if (controller.inspirationDetailModel.value.authorImage.isNotEmpty)
                      Flexible(
                        child: Text(
                          controller.inspirationDetailModel.value.authorName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // responsive font
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // prevent overflow
                        ),
                      ),
            
                    if (controller.inspirationDetailModel.value.authorName.isNotEmpty)
                      SizedBox(width: 8),
                    if (controller.inspirationDetailModel.value.authorName.isNotEmpty)
                      Text(
                        "•",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
            
                          fontSize: 18, // responsive dot
                          color: Colors.black, // subtle dot like social apps
                        ),
                      ),
                    if (controller.inspirationDetailModel.value.authorName.isNotEmpty)
                      SizedBox(width: 8),
            
                    // Date
                    if (controller.inspirationDetailModel.value.createdDate.isNotEmpty)
                      Text(
                        controller.inspirationDetailModel.value.createdDate,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
            
                    SizedBox(width: 8),
                    if (controller.inspirationDetailModel.value.createdDate.isNotEmpty)
                      Text(
                        "•",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    if (controller.inspirationDetailModel.value.createdDate.isNotEmpty)
                      SizedBox(width: 8),
            
                    // Time
                    if (controller.inspirationDetailModel.value.createdTime.isNotEmpty)
                      Text(
                        controller.inspirationDetailModel.value.createdTime,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                  ],
                ),
            
                Text(
                  controller.inspirationDetailModel.value.description,
                  style: styleForNormalText.copyWith(
                    color: AppColors.darkGrey,
                    height: 1.3.h,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                if (controller.inspirationDetailModel.value.imageGallery.isNotEmpty)
                  Text(
                    "Gallery",
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 20.sp,
                    ),
                  ),
                SizedBox(height: 10.h),
            
                GridView.builder(
                  itemCount: controller.inspirationDetailModel.value.imageGallery.length,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                  shrinkWrap: true, // Let it size itself inside a scrollable parent
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // ✅ Two columns
                    crossAxisSpacing: 10, // spacing between columns
                    mainAxisSpacing: 10, // spacing between rows
                  ),
                  itemBuilder: (context, index) {
                    var data =
                        controller.inspirationDetailModel.value.imageGallery[index];
                    return GestureDetector(
                      onTap: () {
                        showFullImageGallery(
                          context,
                          imageUrls: controller.inspirationDetailModel.value.imageGallery,
                          initialIndex: index,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CommonImage(
                          imageSrc: data,
                          imageType: ImageType.network,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 90.h),
              ],
            );
          }
        ),
      ),
    );
  }
}
