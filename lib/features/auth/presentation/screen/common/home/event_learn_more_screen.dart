
// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/models/subscription_event_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_feature_event_container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/styles.dart';
import '../../../widgets/common_image.dart';


class EventLearnMoreScreen extends StatefulWidget {
  EventLearnMoreScreen({super.key,required this.subscriptionList});
RxList<EventModel> subscriptionList;


  @override
  State<EventLearnMoreScreen> createState() => _EventLearnMoreScreenState();
}

class _EventLearnMoreScreenState extends State<EventLearnMoreScreen>
    with SingleTickerProviderStateMixin {

final TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Event",
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
        bottom: PreferredSize(preferredSize: Size.fromHeight(80), child:    Padding(
                padding: const EdgeInsets.only(bottom: 24,left: 16,right: 16),
                child: CustomSearchField(
                  hintText: AppString.searchEventsLocalBusiness,
                  prefixIcon: SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: Center(child: SvgPicture.asset(AppIcons.searchIcon, height: 18.h, width: 18.w)),
                  ),
                  suffixIcon: CommonImage(imageSrc: AppIcons.filterIcon, imageType: ImageType.svg, height: 18.h, width: 18.w),
                  controller: searchController,
                  readOnly: true,
                  onTap: () {
                    Get.toNamed(RoutesName.search);
                  },
                  onPressedSuffix: () {
                    Get.toNamed(RoutesName.filter);
                  },
                ),
              ),
              ),
      ),
      body:ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 16,),
                 padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.subscriptionList.length,
                      itemBuilder: (context, index) {
                        String formatDate(String isoDate) {
                          final date = DateTime.parse(isoDate);
                          return "${date.day}-${date.month}-${date.year % 100}";
                        }

                        return SizedBox(
                          width: 288,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomFeatureEventContainer(
                              bookType: "businessId",
                              verification: widget.subscriptionList[index].blueVerifiedBadge,
                              id: widget.subscriptionList[index].id,
                              type: widget.subscriptionList[index].category,
                              imageType: ImageType.network,
                              imageSrc:
                                  widget.subscriptionList[index].coverImage,
                              onTap:
                                  () => Get.toNamed(
                                    RoutesName.eventDetailScreen,

                                    arguments:
                                        widget.subscriptionList[index].id,
                                  ),
                              typeImage: AppIcons.eventIcon,
                              name: widget.subscriptionList[index].name,
                              location:
                                  widget.subscriptionList[index].address,
                              peopleCount: formatDate(
                                widget.subscriptionList[index].startDate
                                    .toString(),
                              ),

                              rating:
                                  "${widget.subscriptionList[index].averageRating}(${widget.subscriptionList[index].totalReviews})"
                                      .toString(),
                              doller:
                                  "€${widget.subscriptionList[index].entranceFee}",

                              imageHeight: 190,
                              isSponsorShipTrue:             
                                                          widget.subscriptionList[index]
                                                              .subscriptionType !=
                                                          "none",
                              borderRadius: 8,
                              peopleCountIcon: CommonImage(
                                imageSrc: AppIcons.calenderIcon,
                                imageType: ImageType.svg,
                                size: 16,
                              ),
                              verificationIcon: Icons.verified,
                              likeCount:
                                  widget.subscriptionList[index].totalLikes
                                      .toString(),
                              isLiked:
                                  widget.subscriptionList[index].isLiked,
                              commentCount:
                                  (widget
                                              .subscriptionList[index]
                                              .totalComments >
                                          30)
                                      ? "30+"
                                      : widget
                                          .subscriptionList[index]
                                          .totalComments
                                          .toString(),
                              padding: 5,
                             likeOnPressed: () {
                                    eventLikeUnlike(
                                      isLike:
                                          widget
                                              .subscriptionList[index]
                                              .isLiked,
                                      eventId:
                                          widget.subscriptionList[index].id,
                                    ).then((value) {
                                      if (value) {
                                        if (widget
                                            .subscriptionList[index]
                                            .isLiked) {
                                          widget
                                              .subscriptionList[index]
                                              .isLiked = false;
                                          widget
                                              .subscriptionList[index]
                                              .totalLikes -= 1;
                                        } else {
                                          widget
                                              .subscriptionList[index]
                                              .isLiked = true;
                                          widget
                                              .subscriptionList[index]
                                              .totalLikes += 1;
                                        }
                                        
                                        widget.subscriptionList.refresh();
                                        setState(() {
                                          
                                        });
                                      }
                                    });
                                  },
                                  commentOnPressed: () {
                                    log("message");
                                    showHomePageCommentBottomSheet(
                                      id: widget.subscriptionList[index].id,
                                      isBussiness: false,
                                      context,
                                      commentController:
                                          TextEditingController(),
                                          // index: index
                                    );

                                  },
                           bookmarkOnPressed: (result) {
                                                         if(result){
                                                               widget
                                                                  .subscriptionList[index]
                                                                  .isWishlisted = true;
                                                                    widget
                                                                .subscriptionList
                                                                .refresh();
                                                         }
                                                         },
                                                         isWishlisted: widget.subscriptionList[index].isWishlisted,
                              
                            ),
                          ),
                        );
                      },
                    )
      
    );
  }

  // Future<void> _showHomePageCommentBottomSheet(
  //   BuildContext context, {
  //   required TextEditingController commentController,
  //   required String id,
  //   required bool isBussiness,
  //   required int index
  // }) async {
  //   final CommentController controller = Get.put(CommentController());

  //   // Fetch comments based on type
  //   if (isBussiness) {
  //     await controller.fetchComments(id: id, isBusiness: true);
  //   } else {
  //     await controller.fetchComments(id: id, isBusiness: false);
  //   }

  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16,
  //           right: 16,
  //           top: 20,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //         ),
  //         child: Obx(() {
  //           if (controller.isLoading.value) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           return Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 AppString.comments,
  //                 style: styleForBoldText.copyWith(
  //                   fontSize: 24.sp,
  //                   color: AppColors.darkGrey,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 height: 200,
  //                 child:
  //                     controller.comments.isEmpty
  //                         ? Center(
  //                           child: Text(
  //                             "No comments yet.",
  //                             style: styleForNormalText.copyWith(
  //                               fontSize: 14.sp,
  //                             ),
  //                           ),
  //                         )
  //                         : ListView.builder(
  //                           itemCount: controller.comments.length,
  //                           itemBuilder: (context, index) {
  //                             final comment = controller.comments[index];
  //                             return ListTile(
  //                               leading: CommonImage(
  //                                   imageSrc: comment.comments[index].userImage,
  //                                 imageType: ImageType.network,
  //                                 borderRadius: 40.r,
  //                                 height: 40.h,
  //                                 width: 40.w,
  //                               ),
  //                               title: Text(
  //                                 comment.comments[index].user,
  //                                 style: styleForBoldText.copyWith(
  //                                   fontSize: 14.sp,
  //                                   color: AppColors.primary,
  //                                 ),
  //                               ),
  //                               subtitle: Text(
  //                                comment.comments[index].text,
  //                                 style: styleForNormalText.copyWith(
  //                                   fontSize: 16.sp,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: AppColors.darkGrey,
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //               ),
  //               const Divider(),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextField(
  //                       controller: commentController,
  //                       decoration: InputDecoration(
  //                         hintText: "Write a comment...",
  //                         hintStyle: styleForNormalText.copyWith(
  //                           color: AppColors.grey,
  //                           fontSize: 14.sp,
  //                         ),
  //                         fillColor: AppColors.textFieldBg,
  //                         filled: true,
  //                         enabledBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.all(
  //                             Radius.circular(50.r),
  //                           ),
  //                           borderSide: BorderSide(color: AppColors.primary),
  //                         ),
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.all(
  //                             Radius.circular(50.r),
  //                           ),
  //                           borderSide: BorderSide(color: AppColors.primary),
  //                         ),
  //                         contentPadding: EdgeInsets.symmetric(
  //                           horizontal: 12.h,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   IconButton(
  //                     icon: Icon(Icons.send, color: AppColors.primary),
  //                     onPressed: () async {
  //                       if (commentController.text.trim().isNotEmpty) {
  //                         final success = await controller.postComment(
  //                           id: id,
  //                           text: commentController.text.trim(),
  //                           isBussiness: isBussiness,
  //                         );
  //                         if (success) {
  //                           widget.subscriptionList[index].totalComments+=1;
  //                           controller.fetchComments(
  //                             id: id,
  //                             isBusiness: isBussiness,
  //                           );
  //                           commentController.text = '';
  //                           setState(() {
                              
  //                           });
  //                         }
  //                       } else {
  //                         Get.snackbar(
  //                           "Empty Comment",
  //                           "Please write something before sending.",
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 30),
  //             ],
  //           );
  //         }),
  //       );
  //     },
  //   );
  // }



}
