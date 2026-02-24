import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/see_all_my_polls.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/widget/custom_poll_widget.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/explore_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/community_controller.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/common_image.dart';
import '../../../widgets/custom_post_container.dart';
import '../../../widgets/regular/home_screen/custom_chip_tab.dart';
import '../../../widgets/regular/home_screen/show_comment_bottom_sheet.dart';

class CommunityScreen extends StatefulWidget {
  CommunityScreen({super.key, this.iAmNotGuest = true});
  final bool iAmNotGuest;

  final List<Map<String, dynamic>> groupList = [
    {
      'image': AppImages.eventPlanningImage,
      'name': "EVENT PLANNING",
      'route': RoutesName.seeAllPostScreen,
    },
    {
      'image': AppImages.typeEventImage,
      'name': "Type of Event",
      'route': RoutesName.seeAllPostScreen,
    },
    {
      'image': AppImages.inspirationCreativeIdeasImage,
      'name': "INSPIRATION & CREATIVE IDEAS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.decorSetUpImage,
      'name': "DECOR & SETUP",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.giftGadgetImage,
      'name': "GIFTS, FAVORS & GADGETS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.foodDrinkImage,
      'name': "FOOD & DRINKS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.entertainmentMusicImage,
      'name': "ENTERTAINMENT & MUSIC",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.outfitLooksImage,
      'name': "OUTFITS & LOOKS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.beautyWellnessImage,
      'name': "BEAUTY & WELLNESS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.locationSuppliersImage,
      'name': "LOCATIONS & SUPPLIERS",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.qusTipsImage,
      'name': "QUESTIONS, TIPS & ADVICE",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.problemissueImage,
      'name': "PROBLEMS & LAST-MINUTE ISSUES",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.lombardiaImage,
      'name': "POLLS & QUIZZES",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
  ];

  final List<Map<String, dynamic>> regionList = [
    {
      'image': AppImages.abruzzoImage,
      'name': "Abruzzo",
      'route': RoutesName.seeAllPostScreen,
    },
    {
      'image': AppImages.basilicataImage,
      'name': "Basilicata",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.calabriaImage,
      'name': "Calabria",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.campaniaImage,
      'name': "Campania",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.emiliaRomagnaImage,
      'name': "Emilia-Romagna",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.friuliVeneziaGiuliaImage,
      'name': "Friuli-Venezia Giulia",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.lazioImage,
      'name': "Lazio",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.liguriaImage,
      'name': "Liguria",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.lombardiaImage,
      'name': "Lombardia",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.marcheImage,
      'name': "Marche",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.moliseImage,
      'name': "Molise",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.piemonteImage,
      'name': "Piemonte",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.pugliaImage,
      'name': "Puglia",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.sardegnaImage,
      'name': "Sardegna",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.siciliaImage,
      'name': "Sicilia",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.toscanaImage,
      'name': "Toscana",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.trentinoAltoAdigeImage,
      'name': "Trentino-Alto Adige",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.umbriaImage,
      'name': "Umbria",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.liguriaImage,
      'name': "Valle d'Aosta",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
    {
      'image': AppImages.friuliVeneziaGiuliaImage,
      'name': "Veneto",
      'route': RoutesName.seeAllPostScreen, // replace with actual route name
    },
  ];

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  int selectedIndex = 1;

  CommunityController controller = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      floatingActionButton: (widget.iAmNotGuest)
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: AppColors.primary,
              onPressed: () async {
                final selected = await showMenu<String>(
                  context: context,
                  color: Colors.white,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 60,
                    MediaQuery.of(context).size.height - 150,
                    20,
                    100,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'new_post',
                      child: Text(
                        AppString.newPost,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'new_poll',
                      child: Text(
                        'New Poll'.tr,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                  elevation: 8.0,
                );

                if (selected == 'new_post') {
                  Get.toNamed(RoutesName.addNewPost);
                } else if (selected == 'new_poll') {
                  Get.toNamed(RoutesName.newPollScreen);
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Community",
                style: styleForBoldText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 28.sp,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Chip Tabs
            Row(
              children: [
                CustomChipTab(
                  backgroundColor: Colors.white,
                  title: AppString.newPost,
                  textColor: AppColors.primary,
                  isClick: selectedIndex == 1,
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                const SizedBox(width: 5),
                CustomChipTab(
                  backgroundColor: Colors.white,
                  title: AppString.mostComment,
                  textColor: AppColors.primary,
                  isClick: selectedIndex == 2,
                  onTap: () => setState(() => selectedIndex = 2),
                ),
                const SizedBox(width: 5),
                CustomChipTab(
                  backgroundColor: Colors.white,
                  title: AppString.mostViewed,
                  textColor: AppColors.primary,
                  isClick: selectedIndex == 3,
                  onTap: () => setState(() => selectedIndex = 3),
                ),
              ],
            ),

            SizedBox(height: 25.h),
            _buildTitleDivider(AppString.group),
            SizedBox(height: 10),

            _buildGroupList(widget.groupList, (data) {
              controller.getCommunityGroup(
                data,
                iAmNorGuest: widget.iAmNotGuest,
              );
            }),
            const SizedBox(height: 16),
            _buildTitleDivider(AppString.byRegion),
            SizedBox(height: 10),
            _buildGroupList(widget.regionList, (data) {
              controller.getCommunityRegion(
                data,
                iAmNotGuest: widget.iAmNotGuest,
              );
            }),

            const SizedBox(height: 10),
            if (widget.iAmNotGuest)
              _buildPostSection(
                "My Post",
                controller.myPostList,
                "myPost",
                "PostCommunity",
              ),
            const SizedBox(height: 10),
            if (widget.iAmNotGuest)
              _buildTitleRow(
                "My Polls",
                onSeeAll: () {
                  Get.to(SeeAllMyPollScreen());
                },
              ),

            Obx(
              () => controller.myPollList.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: controller.myPollList.length > 3
                          ? 3
                          : controller.myPollList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final pollData = controller.myPollList[index];
                        return Obx(() {
                          final selected =
                              controller.selectedMyPollOptions[pollData.id];
                          String isoTime = pollData.createdAt;

                          DateTime dateTime = DateTime.parse(isoTime);

                          // Format as dd-MM-yyyy
                          String createDate = DateFormat(
                            'dd-MM-yyyy',
                          ).format(dateTime); // 👉 14-08-2025

                          // Format time (HH:mm)
                          String createTime = DateFormat(
                            'HH:mm',
                          ).format(dateTime); // 👉 11:08

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomPollWidget(
                              question: pollData.title,
                              id: pollData.id,
                              isMyPolls: true,
                              description: pollData.description,
                              name: pollData.creator.name,
                              image: pollData.creator.profileImage,
                              options: pollData.options,
                              time: "$createDate  •  $createTime",
                              selectedIndex: selected,
                              onOptionTap: (optionIndex) {
                                if (selected == null) {
                                  controller.patchLatestPoll(
                                    pollData.id,
                                    optionIndex,
                                  );
                                } else {
                                  Get.snackbar(
                                    "Notice",
                                    "You have already voted on this poll.",
                                  );
                                }
                              },
                            ),
                          );
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        "No data found".tr,
                        style: styleForNormalText,
                      ),
                    ),
            ),

            const SizedBox(height: 10),

            if (selectedIndex == 1)
              _buildPostSection(
                "Latest Post",
                controller.latestPostList,
                "latestPost",
                "PostCommunity",
              ),

            if (selectedIndex == 2)
              _buildPostSection(
                "Most Comment",
                controller.mostCommentPostList,
                "mostCommentPost",
                "PostCommunity",
              ),

            if (selectedIndex == 3)
              _buildPostSection(
                "Most Viewed",
                controller.mostViewedPostList,
                "mostViewedPost",
                "PostCommunity",
              ),

            _buildTitleRow(
              "Latest Polls",
              onSeeAll: () {
                Get.toNamed(
                  RoutesName.seeAllPollScreen,
                  arguments: {'iAmNotGuest': widget.iAmNotGuest},
                );
              },
            ),

            Obx(
              () => controller.latestPollList.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: controller.latestPollList.length > 3
                          ? 3
                          : controller.latestPollList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final pollData = controller.latestPollList[index];
                        return Obx(() {
                          final selected =
                              controller.selectedPollOptions[pollData.id];
                          String isoTime = pollData.createdAt;

                          DateTime dateTime = DateTime.parse(isoTime);

                          // Format as dd-MM-yyyy
                          String createDate = DateFormat(
                            'dd-MM-yyyy',
                          ).format(dateTime); // 👉 14-08-2025

                          // Format time (HH:mm)
                          String createTime = DateFormat(
                            'HH:mm',
                          ).format(dateTime); // 👉 11:08

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomPollWidget(
                              question: pollData.title,
                              id: pollData.id,
                              description: pollData.description,
                              name: pollData.creator.name,
                              image: pollData.creator.profileImage,
                              options: pollData.options,
                              time: "$createDate  •  $createTime",
                              selectedIndex: selected,
                              onOptionTap: (!widget.iAmNotGuest)
                                  ? (_) => showExploreDialog(context)
                                  : (optionIndex) {
                                      if (selected == null) {
                                        controller.patchLatestPoll(
                                          pollData.id,
                                          optionIndex,
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Notice",
                                          "You have already voted on this poll.",
                                        );
                                      }
                                    },
                            ),
                          );
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        "No data found".tr,
                        style: styleForNormalText,
                      ),
                    ),
            ),

            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleDivider(String title) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(color: AppColors.primary, width: 61, height: 2),
          SizedBox(width: 3.h),
          Text(
            title,
            style: styleForBoldText.copyWith(
              color: AppColors.darkGrey,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(width: 3.h),
          Container(color: AppColors.primary, width: 61, height: 2),
        ],
      ),
    );
  }

  Widget _buildGroupList(
    List<Map<String, dynamic>> list,
    Function(String) onTap,
  ) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = list[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            child: InkWell(
              onTap: () => onTap(data['name']),
              child: Column(
                children: [
                  CommonImage(
                    imageSrc: data['image'],
                    imageType: ImageType.png,
                    borderRadius: 50.r,
                    height: 74.h,
                    width: 74.w,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 100.w,
                    child: Center(
                      child: Text(
                        data['name'],
                        maxLines: 3,
                        style: styleForNormalText.copyWith(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleRow(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr,
          style: styleForBoldText.copyWith(
            fontSize: 18.sp,
            color: AppColors.darkGrey,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            "See All".tr,
            style: styleForBoldText.copyWith(
              fontSize: 14.sp,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostSection(
    String title,
    RxList postList,
    String routeArg,
    String type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(
          title,
          onSeeAll: () {
            Get.toNamed(
              RoutesName.seeAllPostScreen,
              arguments: {
                'data': routeArg,
                'isMyPost': routeArg == "myPost",
                'iAmNotGuest': widget.iAmNotGuest,
              },
            );
          },
        ),
        SizedBox(height: 5.h),
        Obx(
          () => postList.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: postList.length > 3 ? 3 : postList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = postList[index];

                    String isoTime = data.createdAt;

                    DateTime dateTime = DateTime.parse(isoTime);

                    // Format as dd-MM-yyyy
                    String createDate = DateFormat(
                      'dd-MM-yyyy',
                    ).format(dateTime); // 👉 14-08-2025

                    // Format time (HH:mm)
                    String createTime = DateFormat(
                      'HH:mm',
                    ).format(dateTime); // 👉 11:08

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomPostContainer(
                        profileImage: "${data.creator.profileImage}",
                        title: data.title,
                        description: data.description,
                        name: data.creator.name,
                        time: "$createDate  •  $createTime",
                        commentCount: data.totalComments.toString(),
                        likeCount: data.totalLikes.toString(),
                        onTap: (!widget.iAmNotGuest)
                            ? () => showExploreDialog(context)
                            : () {
                                Get.toNamed(
                                  RoutesName.commentPost,
                                  arguments: {
                                    'id': data.id,
                                    'type': type,
                                    'isMyPost': routeArg == "myPost",
                                  },
                                );
                              },
                        isLiked: data.isLiked,
                        onTapLike: (!widget.iAmNotGuest)
                            ? () => showExploreDialog(context)
                            : () {
                                data.isLiked
                                    ? controller.unLikePost(data.id)
                                    : controller.likePost(data.id);
                              },
                        onTapComment: (!widget.iAmNotGuest)
                            ? () => showExploreDialog(context)
                            : () {
                                controller.getComment(id: data.id);

                                showCommentBottomSheet(
                                  context,
                                  commentController:
                                      controller.commentController,
                                  onPressed: () {
                                    controller.commentPost(data.id, context);
                                  },
                                );
                              },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("No data found".tr, style: styleForNormalText),
                ),
        ),
      ],
    );
  }
}
