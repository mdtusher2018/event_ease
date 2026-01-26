import 'dart:developer';
import 'dart:io';
import 'package:event_ease/features/auth/presentation/black_for_ios/block_controlller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/widgets/fullimage.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/edit_post_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../controller/comment_post_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import '../../../widgets/common_image.dart';

class CommentPost extends StatelessWidget {
  CommentPost({super.key});

  final CommentPostController controller = Get.find<CommentPostController>();

  @override
  Widget build(BuildContext context) {
    final String type = Get.arguments['type'];
    final String id = Get.arguments['id'];
    final bool isMyPost = Get.arguments['isMyPost'] ?? false;
    log(">>>>>> Type: $type");

    controller.getPostDetail(id);

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
            onSelected: (value) async {
              if (value == 'report') {
                Get.toNamed(
                  RoutesName.report,
                  arguments: {'id': id, 'type': type},
                );
              }
              if (value == "Edit") {
                Get.to(EditPostScreen(details: controller.details))!.then((
                  value,
                ) {
                  controller.getPostDetail(id);
                });
              }
              if (value == "Delete") {
                final response = await ApiService.to.deleteApi(
                  AppUrl.deleteCommunityPost(id),
                );
                if (response.success) {
                  Navigator.pop(context);
                }
              }
              if (value == 'block') {
                await blockAnything(
                  id: controller.details.value.id,
                  type: "postCommunity",
                );
              }
            },
            itemBuilder:
                (_) => [
                  if (!isMyPost)
                    PopupMenuItem<String>(
                      value: "report",
                      child: Text(
                        AppString.report,
                        style: styleForBoldText.copyWith(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
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

                  if (!isMyPost && (Platform.isIOS || kDebugMode))
                    PopupMenuItem<String>(value: 'block', child: Text('Block')),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = controller.details.value;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      post.description,
                      style: styleForNormalText.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 10.h),

                    if (post.image.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(post.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    Text(
                      "${post.totalLikes} Likes",
                      style: styleForBoldText.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    Text(
                      "Gallery",
                      style: styleForBoldText.copyWith(
                        color: AppColors.darkGrey,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    GridView.builder(
                      itemCount: post.galleryImagePath.length,
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                      shrinkWrap:
                          true, // Let it size itself inside a scrollable parent
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // ✅ Two columns
                            crossAxisSpacing: 10, // spacing between columns
                            mainAxisSpacing: 10, // spacing between rows
                          ),
                      itemBuilder: (context, index) {
                        var data = post.galleryImagePath[index];
                        return GestureDetector(
                          onTap: () {
                            showFullImageGallery(
                              context,
                              imageUrls: post.galleryImagePath,
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

                    Text(
                      AppString.comments,
                      style: styleForBoldText.copyWith(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    post.comments.isEmpty
                        ? Text("No comments yet".tr, style: styleForNormalText)
                        : ListView.builder(
                          itemCount: post.comments.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            log(
                              post.comments.length.toString() +
                                  "========>>>>>>",
                            );
                            RxBool showReplies = false.obs;

                            final date = DateFormat('dd-MM-yyyy').format(
                              DateTime.tryParse(comment.createdAt) ??
                                  DateTime.now(),
                            );
                            final time = DateFormat('HH:mm').format(
                              DateTime.tryParse(comment.createdAt) ??
                                  DateTime.now(),
                            );

                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.textFieldBg,
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: CommonImage(
                                              imageSrc:
                                                  comment.user.profileImage,
                                              imageType: ImageType.network,
                                              borderRadius: 100,
                                              size: 40,
                                            ),
                                            title: Text(
                                              comment.user.name,
                                              style: styleForBoldText.copyWith(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Text("$date • $time"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            child: Text(
                                              comment.text,
                                              style: styleForNormalText
                                                  .copyWith(fontSize: 15),
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              if (comment.replies.isNotEmpty)
                                                TextButton(
                                                  onPressed: () {
                                                    showReplies.value =
                                                        !showReplies.value;
                                                  },
                                                  child: Text(
                                                    showReplies.value
                                                        ? "Hide Replies".tr
                                                        : "${"View Replies".tr} (${comment.replies.length})",
                                                    style: styleForNormalText
                                                        .copyWith(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                  ),
                                                ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.replyToName.value =
                                                      comment.user.name;
                                                  controller.replyingTo.value =
                                                      comment.id;
                                                  log(
                                                    controller
                                                            .replyingTo
                                                            .value +
                                                        "------" +
                                                        controller
                                                            .replyingTo
                                                            .value +
                                                        ".................",
                                                  );
                                                },
                                                child: Text(
                                                  "Reply",
                                                  style: styleForNormalText
                                                      .copyWith(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          if (showReplies.value)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 50.0,
                                                top: 4.0,
                                              ),
                                              child: Column(
                                                children:
                                                    comment.replies.map((
                                                      reply,
                                                    ) {
                                                      final replyDate =
                                                          DateFormat(
                                                            'dd-MM-yyyy',
                                                          ).format(
                                                            DateTime.tryParse(
                                                                  reply
                                                                      .createdAt,
                                                                ) ??
                                                                DateTime.now(),
                                                          );
                                                      final replyTime =
                                                          DateFormat(
                                                            'HH:mm',
                                                          ).format(
                                                            DateTime.tryParse(
                                                                  reply
                                                                      .createdAt,
                                                                ) ??
                                                                DateTime.now(),
                                                          );

                                                      return Stack(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  8,
                                                                ),
                                                            margin:
                                                                EdgeInsets.only(
                                                                  bottom: 8,
                                                                ),

                                                            decoration: BoxDecoration(
                                                              color:
                                                                  AppColors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        4.0,
                                                                  ),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonImage(
                                                                    imageSrc:
                                                                        reply
                                                                            .user
                                                                            .profileImage,
                                                                    imageType:
                                                                        ImageType
                                                                            .network,
                                                                    borderRadius:
                                                                        50,
                                                                    size: 30,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8,
                                                                          ),

                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            reply.user.name,
                                                                            style: styleForBoldText.copyWith(
                                                                              fontSize:
                                                                                  14,
                                                                              color:
                                                                                  AppColors.primary,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            reply.text,
                                                                            style: styleForNormalText.copyWith(
                                                                              fontSize:
                                                                                  14,
                                                                              color:
                                                                                  Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          Positioned(
                                                            top: 8,
                                                            right: 8,
                                                            child: Text(
                                                              "$replyDate • $replyTime",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Replies list
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                    // Reply indicator

                    // Add comment field
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.replyToName.value.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${"Replying to".tr} ${controller.replyToName.value}",
                          style: styleForNormalText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.replyToName.value = "";
                          controller.replyingTo.value = "";
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: styleForNormalText.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        fillColor: AppColors.textFieldBg,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      if (controller.commentController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Empty Comment",
                          "Please write something before sending.",
                        );
                        return;
                      }

                      controller.commentPost(post.id, context).then((value) {
                        controller.getPostDetail(id);
                      });

                      controller.commentController.clear();
                      controller.replyToName.value = "";
                      controller.replyingTo.value = "";
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        );
      }),
    );
  }
}
