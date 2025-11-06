import 'package:event_ease/engagment%20handle/comment_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> showHomePageCommentBottomSheet(
  BuildContext context, {
  required TextEditingController commentController,
  required String id,
  required bool isBussiness,
}) async {
  final CommentController controller = Get.put(CommentController());

  // Fetch comments
  await controller.fetchComments(id: id, isBusiness: isBussiness);

  // Reset reply state
  controller.replyToName.value = "";
  controller.replyingTo.value = "";

  // Map to manage showing replies for each comment
  final RxMap<String, bool> showReplies = <String, bool>{}.obs;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return  SizedBox(
        height: MediaQuery.sizeOf(context).height*0.6,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
            }
        
            return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Grab Handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        
          // 🔹 Header
          Text(
            AppString.comments,
            style: styleForBoldText.copyWith(
              fontSize: 20.sp,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 16.h),
        
          // 🔹 Comments list
          Expanded(
            child: controller.comments.isEmpty
                ? Center(
                    child: Text(
                      AppString.noCommentsYet,
                      style: styleForNormalText.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      if (!showReplies.containsKey(comment.id)) {
                        showReplies[comment.id] = false;
                      }
        
                      final date = DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(comment.createdAt));
                      final time = DateFormat('HH:mm')
                          .format(DateTime.parse(comment.createdAt));
        
                      return Obx(() => Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.textFieldBg,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonImage(
                                      imageSrc: comment.user.profileImage,
                                      imageType: ImageType.network,
                                      borderRadius: 40.r,
                                      height: 36.h,
                                      width: 36.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                comment.user.name,
                                                style: styleForBoldText.copyWith(
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
                                          SizedBox(height: 6.h),
                                          Text(
                                            comment.text,
                                            style:
                                                styleForNormalText.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.darkGrey,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
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
                                                    style: styleForNormalText
                                                        .copyWith(
                                                      fontSize: 12.sp,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                 TextButton(
                                                onPressed: () {
                                                  controller.replyingTo.value =
                                                      comment.id;
                                                  controller.replyToName.value =
                                                      comment.user.name;
                                                },
                                                child: Text("Reply".tr,
                                                    style: styleForNormalText
                                                        .copyWith(
                                                      fontSize: 12.sp,
                                                      color: AppColors.primary,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
        
                                // 🔹 Replies
                                if (showReplies[comment.id]! &&
                                    comment.replies.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(left: 48.w, top: 8.h),
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
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: AppColors.grey
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonImage(
                                                imageSrc: reply.user.profileImage,
                                                imageType: ImageType.network,
                                                borderRadius: 30.r,
                                                height: 28.h,
                                                width: 28.w,
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
                                                          reply.user.name,
                                                          style: styleForBoldText
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
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      reply.text,
                                                      style: styleForNormalText
                                                          .copyWith(
                                                        fontSize: 13.sp,
                                                        color:
                                                            AppColors.darkGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
        
          // 🔹 Replying indicator
          Obx(() => controller.replyToName.value.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(bottom: 8.h, top: 8.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Replying to ${controller.replyToName.value}",
                          style: styleForNormalText.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.replyToName.value = "";
                          controller.replyingTo.value = "";
                        },
                        child: Icon(Icons.close,
                            size: 18.sp, color: AppColors.grey),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
        
          // 🔹 Comment input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, ),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                  
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...".tr,
                      hintStyle: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: () async {
                    if (commentController.text.trim().isEmpty) {
                      Get.snackbar("Empty Comment".tr,
                          "Please write something before sending.".tr);
                      return;
                    }
        
                    bool success;
                    if (controller.replyingTo.value.isEmpty) {
                      success = await controller.postComment(
                        id: id,
                        text: commentController.text.trim(),
                        isBussiness: isBussiness,
                      );
                    } else {
                      success = await controller.postCommentReply(
                        id: id,
                        text: commentController.text.trim(),
                        isBussiness: isBussiness,
                      );
                    }
        
                    if (success) {
                      await controller.fetchComments(
                          id: id, isBusiness: isBussiness);
                      commentController.clear();
                      controller.replyToName.value = "";
                      controller.replyingTo.value = "";
                    }
                  },
                ),
              ],
            ),
          ),
        ],
            );
          }),
        ),
      );

   
    },
  );
}
