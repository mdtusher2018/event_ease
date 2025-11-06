
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/community_controller.dart';

Future<void> showCommentBottomSheet(
  BuildContext context, {
  required TextEditingController commentController,
  required onPressed
}) async {
  final CommunityController controller = Get.find<CommunityController>();

  // Reset reply state
  controller.replyToName.value = "";
  controller.replyingTo.value = "";

  final RxMap<String, bool> showReplies = <String, bool>{}.obs;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                AppString.comments,
                style: styleForBoldText.copyWith(
                  fontSize: 24.sp,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 10),

              // Comments list
              SizedBox(
                height: 300,
                child: controller.commentList.isEmpty
                    ? Center(
                        child: Text(
                          AppString.noCommentsYet,
                          style: styleForNormalText.copyWith(fontSize: 14.sp),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.commentList.length,
                        itemBuilder: (context, index) {
                          final comment = controller.commentList[index];
                          if (!showReplies.containsKey(comment.id)) {
                            showReplies[comment.id] = false;
                          }
               final date = DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(comment.createdAt));
                      final time = DateFormat('HH:mm')
                          .format(DateTime.parse(comment.createdAt));
        
        
                          return Obx(() => Container(
                              margin: EdgeInsets.only(bottom: 8.h, top: 8.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                                
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Comment Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonImage(
                                          imageSrc: comment.user.profileImage,
                                          imageType: ImageType.network,
                                          borderRadius: 40.r,
                                          height: 40.h,
                                          width: 40.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    comment.user.name,
                                                    style:
                                                        styleForBoldText.copyWith(
                                                      fontSize: 14.sp,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                       Text(
                                                "$date • $time",
                                                style:
                                                    styleForNormalText.copyWith(
                                                  fontSize: 11.sp,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                                  
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                comment.text,
                                                style:
                                                    styleForNormalText.copyWith(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.darkGrey,
                                                ),
                                              ),
                                              
                                                Row(
                                                  children: [
                                                    if (comment.replies.isNotEmpty)
                                                    TextButton(
                                                      onPressed: () {
                                                        showReplies[comment.id] =
                                                            !showReplies[
                                                                comment.id]!;
                                                      },
                                                      child: Text(
                                                        showReplies[comment.id]!
                                                            ? "Hide Replies"
                                                            : "View Replies (${comment.replies.length})",
                                                        style:
                                                            styleForNormalText.copyWith(
                                                          fontSize: 12.sp,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                    onPressed: () {
                                                      controller.replyingTo
                                                          .value = comment.id;
                                                      controller.replyToName
                                                          .value =
                                                          comment.user.name;
                                                    },
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      minimumSize:
                                                          Size(50, 20),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Text(
                                                      "Reply",
                                                      style:
                                                          styleForNormalText.copyWith(
                                                        fontSize: 12.sp,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Replies
                                    if (showReplies[comment.id]! &&
                                        comment.replies.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 48.w, top: 4.h),
                                        child: Column(
                                          children: comment.replies.map((reply) {

      final replyDate =
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(reply.createdAt));
                                        final replyTime =
                                            DateFormat('HH:mm').format(
                                                DateTime.parse(reply.createdAt));


                                            return Container(
                                                   margin: EdgeInsets.only(bottom: 8.h),
                                          padding: EdgeInsets.symmetric(horizontal:  10.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: AppColors.grey
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.h),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonImage(
                                                      imageSrc:
                                                          reply.user.profileImage,
                                                      imageType: ImageType.network,
                                                      borderRadius: 30.r,
                                                      height: 30.h,
                                                      width: 30.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: double.infinity,
                                                            
                                                            padding: EdgeInsets.all(8.h),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      12.r),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      reply.user.name,
                                                                      style:
                                                                          styleForBoldText
                                                                              .copyWith(
                                                                        fontSize: 13.sp,
                                                                        color:
                                                                            AppColors.primary,
                                                                      ),
                                                                      
                                                                    ),
                                                                         Text(
                                                            "$replyDate • $replyTime",
                                                            style: styleForNormalText
                                                                .copyWith(
                                                              fontSize: 11.sp,
                                                              color: AppColors.grey,
                                                            ),
                                                          ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 2.h),
                                                                Text(
                                                                  reply.text,
                                                                  style:
                                                                      styleForNormalText
                                                                          .copyWith(
                                                                    fontSize: 14.sp,
                                                                    color:
                                                                        AppColors.darkGrey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                             
                                  ],
                                ),
                              ));
                        },
                      ),
              ),

              // Reply indicator
              Obx(() {
                if (controller.replyToName.value.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Replying to ${controller.replyToName.value}",
                            style: styleForNormalText.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.replyToName.value = "";
                            controller.replyingTo.value = "";
                          },
                          child: Icon(
                            Icons.cancel,
                            size: 20.sp,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),

              // Comment input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: styleForNormalText.copyWith(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                        fillColor: AppColors.textFieldBg,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.h),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.primary),
                    onPressed: () async {
                      if (commentController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Empty Comment",
                          "Please write something before sending.",
                        );
                        return;
                      }
onPressed();
                
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          );
        }),
      );
    },
  );
}
