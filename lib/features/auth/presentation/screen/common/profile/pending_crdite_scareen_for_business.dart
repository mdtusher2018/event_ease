import 'package:event_ease/features/auth/presentation/controller/profile/BusinessPendingRequestsController.dart';
import 'package:event_ease/features/auth/presentation/controller/profile/model/PendingCreditRequestForBusiness.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessPendingRequestsPage extends StatelessWidget {
  final BusinessPendingRequestsController controller = Get.put(
    BusinessPendingRequestsController(),
  );

  BusinessPendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Pending Credit Requests',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingRequests.isEmpty) {
          return const Center(
            child: Text(
              "No pending requests found.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.pendingRequests.length,
          itemBuilder: (context, index) {
            final req = controller.pendingRequests[index];
            return _buildRequestCard(req, controller);
          },
        );
      }),
    );
  }

  /// ==================== CARD BUILDER ============================
  Widget _buildRequestCard(
    PendingCreditRequestForBusiness req,
    BusinessPendingRequestsController controller,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: user info and business logo
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    req.business.logo,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.business,
                          size: 50,
                          color: Colors.grey,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        req.user.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Business: ${req.business.name}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade300),

            /// Used credits and message
            Row(
              children: [
                const Icon(
                  Icons.credit_card,
                  color: Colors.deepPurple,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "${req.usedCredits} credits used",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              req.text,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 12),

            /// Status + Created date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(req.status),
                Text(
                  _formatDate(req.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),

            /// Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  label: "Reject",
                  color: Colors.red.shade400,
                  icon: Icons.close,
                  onTap:
                      () => _confirmAction(
                        title: "Reject Request?",
                        message:
                            "Are you sure you want to reject this pending request from ${req.user.name}?",
                        confirmText: "Reject",
                        confirmColor: Colors.red,
                        onConfirm: () => controller.rejectRequest(req.id),
                      ),
                ),
                const SizedBox(width: 10),
                _buildActionButton(
                  label: "Approve",
                  color: Colors.green.shade500,
                  icon: Icons.check,
                  onTap:
                      () => _confirmAction(
                        title: "Approve Request?",
                        message:
                            "Are you sure you want to approve ${req.user.name}'s request?",
                        confirmText: "Approve",
                        confirmColor: Colors.green,
                        onConfirm: () => controller.approveRequest(req.id),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Status chip (pending, approved, rejected)
  Widget _buildStatusChip(String status) {
    Color bg;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        bg = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'rejected':
        bg = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        bg = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Simple custom button
  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Confirmation Dialog for Approve/Reject
  void _confirmAction({
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Date formatter (dd/mm/yyyy)
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
