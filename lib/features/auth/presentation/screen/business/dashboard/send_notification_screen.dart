// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/getSendNotificationPage.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import 'api/deshboard_controller.dart';

class SendNotificationScreen extends StatefulWidget {
  final String type;
  final String notificationFor;
  final String totalFollower;
  final String name;
  final String image;

  SendNotificationScreen({
    super.key,
    required this.type,
    required this.notificationFor,
    required this.totalFollower,
    required this.name,
    required this.image,
  });

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final DeshBoardController controller = Get.put(DeshBoardController());

  final TextEditingController notificationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.notificationCount(widget.type, widget.notificationFor);
  }

  @override
  Widget build(BuildContext context) {
    log("Notification Count: ${controller.notificationCountNum.value}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          AppString.sendNotification,
          style: styleForBoldText.copyWith(fontSize: 23),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(
                GetSendNotificationPage(
                  type: widget.type,
                  id: widget.notificationFor,
                ),
              );
            },
            child: Icon(Icons.notifications, color: AppColors.primary),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              }

              return Text(
                "${AppString.notificationSentToday}: ${controller.notificationCountNum.value}/3",
                style: styleForBoldText.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              );
            }),
            Text(
              "${AppString.nextAvailable}: Now",
              style: styleForNormalText.copyWith(
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notificationController,
              decoration: InputDecoration(
                hintText: "${AppString.writeText}..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 4,
            ),
            Spacer(),
            CustomButton(
              text: AppString.preview,
              onTap: () {
                if (notificationController.text.isEmpty) {
                  return Get.snackbar(
                    "Empty",
                    "Notification is empty. Please give a message",
                  );
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                AppString.preview,
                                style: styleForBoldText.copyWith(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        notificationController.text,
                        style: styleForNormalText.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      actions: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButton(
                              text: AppString.sendNow,
                              paddingVertical: 10,
                              onTap: () {
                                if (controller.notificationCountNum.value >=
                                    3) {
                                  Get.snackbar(
                                    "Limit Reached",
                                    "You have already sent 3 notifications today.",
                                  );
                                } else {
                                  log("Sending Notification...");
                                  sendNowMessage(
                                    text: notificationController.text,
                                    types: widget.type,
                                    notificationFor: widget.notificationFor,
                                    image: widget.image,
                                    name: widget.name,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> sendNowMessage({
    required String text,
    required String types,
    required String notificationFor,
    required String image,
    required String name,
  }) async {
    String endpoint;

    if (types == "event") {
      endpoint = "${AppUrl.baseUrl}/notification/event/sent-notification";
    } else if (types == "job") {
      endpoint = "${AppUrl.baseUrl}/notification/job/sent-notification";
    } else {
      endpoint = "${AppUrl.baseUrl}/notification/business/sent-notification";
    }

    log("Sending notification to: $endpoint");

    try {
      final Map<String, dynamic> body = {
        "message": {
          "text": text,
          "types": types,
          "notificationFor": notificationFor,
          "image": image,
          "name": name,
        },
      };

      final ApiResponse response = await ApiService.to.postApi(endpoint, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success".tr, "Message sent successfully!");
        notificationController.clear();
        controller.notificationCount(
          widget.type,
          widget.notificationFor,
        ); // refresh count
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e) {
      Get.snackbar("Error".tr,"Something went wrong: $e");
    }
  }
}
