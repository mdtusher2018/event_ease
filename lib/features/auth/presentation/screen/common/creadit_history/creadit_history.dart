import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/common/creadit_history/creadit_history_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/creadit_history/creadit_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreditHistoryPage extends StatelessWidget {
  final CreditHistoryPageController controller = Get.put(
    CreditHistoryPageController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'creditHistory'.tr, // Using GetX translation here
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.creditHistory.isEmpty) {
          return Center(child: Text('noCreditHistory'.tr)); // Translated string
        }

        return ListView.builder(
          itemCount: controller.creditHistory.length,
          itemBuilder: (context, index) {
            final credit = controller.creditHistory[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CreditHistoryCard(creditData: credit),
            );
          },
        );
      }),
    );
  }
}

class CreditHistoryCard extends StatelessWidget {
  final CreditData creditData;

  const CreditHistoryCard({super.key, required this.creditData});

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted =
        creditData.createdAt != null
            ? DateFormat('yyyy-MM-dd').format(creditData.createdAt!)
            : 'N/A';

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    (PrefsHelper.myRole == "user")
                        ? creditData.businessId?.logo ?? ""
                        : creditData.userId?.profileImage ?? "",
                  ), // Profile image
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (PrefsHelper.myRole == "user")
                            ? creditData.businessId?.name ?? 'Unknown User'
                            : creditData.userId?.name ?? 'Unknown User',
                        maxLines: (PrefsHelper.myRole == "user") ? 2 : 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      if (PrefsHelper.myRole != "user")
                        Text(
                          creditData.businessId?.name ?? 'Unknown Email',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Credit Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'type'.tr}: ${creditData.type}', // Using `tr` for "Type"
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
                ),
                Text(
                  '${'status'.tr}: ${creditData.status}', // Using `tr` for "Status"
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        creditData.status == 'accepted'
                            ? Colors.green.shade800
                            : creditData.status == 'rejected'
                            ? Colors.red.shade900
                            : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Credit Usage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(PrefsHelper.myRole == "user") ? 'usedCredits'.tr : 'receivedCredits'.tr}: ${creditData.usedCredits}', // Using `tr` for "Used Credits" or "Received Credits"
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Divider(),

            // Date Information (Italicized)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${'transactionDate'.tr}', // Using `tr` for "Transaction Date"
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        createdAtFormatted, // This will display the formatted date
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic, // Italicized date
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
