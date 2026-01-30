// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/regular/community/widget/custom_poll_widget.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/community_controller.dart';

class SeeAllPollScreen extends StatelessWidget {
  SeeAllPollScreen({super.key});
  CommunityController controller = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
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
          "All Poll",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Obx(
        () =>
            controller.latestPollList.isNotEmpty
                ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  itemCount: controller.latestPollList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = controller.latestPollList[index];
                    final selectedIndex =
                        controller.selectedPollOptions[data.id];
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
                      child: CustomPollWidget(
                        question: data.title,
                        id: data.id,
                        description: data.description,
                        time: "$createDate  •  $createTime",
                        name: data.creator.name,
                        image: "${data.creator.profileImage}",
                        options: data.options,
                        selectedIndex: selectedIndex,
                        onOptionTap: (optionIndex) {
                          if (selectedIndex == null) {
                            controller.patchLatestPoll(data.id, optionIndex);
                          } else {
                            Get.snackbar(
                              "Notice",
                              "You have already voted on this poll.",
                            );
                          }
                        },
                      ),
                    );
                  },
                )
                : Center(
                  child: Text("No data found".tr, style: styleForNormalText),
                ),
      ),
    );
  }
}
