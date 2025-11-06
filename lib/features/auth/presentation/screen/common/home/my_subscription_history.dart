import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/my_subscription_model.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/api/mysubscription_history_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MySubscriptionHistoryScreen extends StatelessWidget {
  MySubscriptionHistoryScreen({super.key});

  final SubscriptionHistoryController controller =
      Get.put(SubscriptionHistoryController());

  Color getStatusColor(String status) {
    return AppColors.primary;
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat.yMMMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchSubscriptions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription History'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        if (controller.subscriptions.isEmpty) {
          return const Center(
            child: Text(
              'No subscriptions found.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.subscriptions.length,
          itemBuilder: (context, index) {
            final MySponsorSubscriptionData item =
                controller.subscriptions[index];
            final option =
                item.subscription.options[item.subscriptionOptionIndex];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  return ExpansionTile(
                      shape: const RoundedRectangleBorder(
    side: BorderSide(color: Colors.transparent), // transparent border
  ),
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Title + Business
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.subscription.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subscriptionFor.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                  
                        // Right side: Price + Status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "€${option.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: getStatusColor(item.status).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: getStatusColor(item.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  
                    // Expanded content
                    children: [
                      // Subscription subtitle
                      if (item.subscription.subTitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            item.subscription.subTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                  
                      Divider(color: Colors.grey.shade300),
                  
                      // Dates
                      _buildInfoRow("Created", formatDate(item.createdAt)),
                      _buildInfoRow("Activated", formatDate(item.activateDate)),
                      _buildInfoRow("Stop Date", formatDate(item.stopDate)),
                      _buildInfoRow("Activation Expiry",
                          formatDate(item.activateExpireDate)),
                  
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300),
                  
                      // Payment
                      _buildInfoRow("Payment Method",(item.paymentMethod.isNotEmpty)? item.paymentMethod:item.paymentType),
                      _buildInfoRow("Payment Status",(item.paymentStatus.isNotEmpty)? item.paymentStatus:'-'),
                  
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300),
                  
                      // Plan
                      _buildInfoRow("Plan", option.time),
                      _buildInfoRow("Expiration Days",
                          "${option.expirationDays} days"),
                      _buildInfoRow("Refund Days", "${option.refoundDays} days"),
                  
                      if (item.gotCredits > 0)
                        _buildInfoRow("Credits Received",
                            "${item.gotCredits} Credits"),
                  
                      // Features
                      if (item.subscription.feature.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Features:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...item.subscription.feature.map(
                          (f) => Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }
              ),
            );
          },
        );
      }),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
