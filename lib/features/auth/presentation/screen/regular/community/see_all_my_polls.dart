// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/regular/community/edit_polls.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/widget/custom_poll_widget.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/community_controller.dart';

class SeeAllMyPollScreen extends StatelessWidget {
  SeeAllMyPollScreen({super.key});
  final CommunityController controller = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          "My Polls",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Obx(
        () =>
            controller.myPollList.isNotEmpty
                ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.myPollList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = controller.myPollList[index];
                    final selectedIndex =
                        controller.selectedMyPollOptions[data.id];

                    String isoTime = data.createdAt;
                    DateTime dateTime = DateTime.parse(isoTime);

                    // Format date + time
                    String createDate = DateFormat(
                      'dd-MM-yyyy',
                    ).format(dateTime);
                    String createTime = DateFormat('HH:mm').format(dateTime);

                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CustomPollWidget(
                            question: data.title,
                            id: data.id,
                            isMyPolls: true,
                            description: data.description,
                            time: "$createDate  •  $createTime",
                            name: data.creator.name,
                            image: "${data.creator.profileImage}",
                            options: data.options,
                            selectedIndex: selectedIndex,
                            onOptionTap: (optionIndex) {
                              if (selectedIndex == null) {
                                controller.patchMyPoll(data.id, optionIndex);
                              } else {
                                Get.snackbar(
                                  "Notice",
                                  "You have already voted on this poll.",
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 5,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                // 📝 Handle edit
                                Get.to(EditPollScreen(poll: data));
                              } else if (value == 'delete') {
                                ApiService.to
                                    .deleteApi(AppUrl.deletePolls(data.id))
                                    .then((value) {
                                      if (value.success) {
                                        controller.getMyPoll();
                                        Get.snackbar(
                                          "Success",
                                          "Poll deleted successfully.",
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Failed to delete the poll.",
                                        );
                                      }
                                    });
                              }
                            },
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.black54),
                                        SizedBox(width: 8),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                            icon: const Icon(
                              Icons.more_vert_outlined,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                : Center(
                  child: Text("No data found", style: styleForNormalText),
                ),
      ),
    );
  }
}
