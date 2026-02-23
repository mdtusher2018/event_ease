import 'package:event_ease/features/auth/presentation/widgets/explore_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../controller/community_controller.dart';
import '../../../models/my_model/my_post_model.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_post_container.dart';
import '../../../widgets/regular/home_screen/show_comment_bottom_sheet.dart';

class SeeAllPostScreen extends StatefulWidget {
  SeeAllPostScreen({super.key});

  @override
  State<SeeAllPostScreen> createState() => _SeeAllPostScreenState();
}

class _SeeAllPostScreenState extends State<SeeAllPostScreen> {
  CommunityController controller = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments['data'];
    var name = Get.arguments['name'];
    var iAmNotGuest = Get.arguments['iAmNotGuest'] ?? true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          name ?? "All Post",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            List<MyPostModel> posts = [];

            if (data == "group") {
              posts = controller.groupList;
            } else if (data == "region") {
              posts = controller.regionList;
            } else if (data == "myPost") {
              posts = controller.myPostList;
            } else if (data == "latestPost") {
              posts = controller.latestPostList;
            } else if (data == "mostCommentPost") {
              posts = controller.mostCommentPostList;
            } else if (data == "mostViewedPost") {
              posts = controller.mostViewedPostList;
            }

            if (posts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("No data found".tr, style: styleForNormalText),
                ),
              );
            }

            return Column(
              children: List.generate(posts.length, (index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomPostContainer(
                    profileImage: post.creator.profileImage,
                    title: post.title,
                    description: post.description,
                    name: post.creator.name,
                    time: "",
                    commentCount: post.totalComments.toString(),
                    likeCount: post.totalLikes.toString(),
                    onTap: (!iAmNotGuest)
                        ? () => showExploreDialog(context)
                        : () {
                            Get.toNamed(
                              RoutesName.commentPost,
                              arguments: {
                                'id': post.id,
                                'type': "PostCommunity",
                                'isMyPost': data == "myPost",
                              },
                            )!.then((value) {
                              controller.getMyPost();
                            });
                          },
                    isLiked: post.isLiked,
                    onTapLike: (!iAmNotGuest)
                        ? () => showExploreDialog(context)
                        : () {
                            post.isLiked
                                ? controller
                                      .unLikePost(post.id, data: post)
                                      .then((_) => setState(() {}))
                                : controller
                                      .likePost(post.id, data: post)
                                      .then((_) => setState(() {}));
                          },
                    onTapComment: (!iAmNotGuest)
                        ? () => showExploreDialog(context)
                        : () {
                            controller.getComment(id: post.id);

                            showCommentBottomSheet(
                              context,
                              commentController: controller.commentController,
                              onPressed: () {
                                controller
                                    .commentPost(
                                      post.id,
                                      context,
                                      postData: post,
                                    )
                                    .then((_) {
                                      setState(() {});
                                    });
                              },
                            );
                          },
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
