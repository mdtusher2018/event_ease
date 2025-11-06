// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'api/send_notification_controller.dart';

class GetSendNotificationPage extends StatelessWidget {
  String type, id;

  GetSendNotificationPage({required this.type, required this.id});
  @override
  Widget build(BuildContext context) {
    final GEtSendNotificationController controller = Get.put(
      GEtSendNotificationController(type: type, id: id),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];

              DateTime dateTime = notif.createdAt;
              String formattedDate = DateFormat(
                'dd MMM yyyy',
              ).format(dateTime); // 14 Aug 2025
              String formattedTime = DateFormat(
                'hh:mm a',
              ).format(dateTime); // 11:08 AM

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== Icon ======
                      CommonImage(
                        imageSrc:
                            (notif.message.types == "business")
                                ? AppIcons.businessIcon
                                : (notif.message.types == "event")
                                ? AppIcons.eventIcon
                                : AppIcons.jobIcon,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),

                      // ====== Notification Content ======
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              notif.message.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Message
                            Text(
                              notif.message.text,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Reach info
                            Text(
                              "Reach: ${notif.sentCount}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ====== Date & Time ======
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
