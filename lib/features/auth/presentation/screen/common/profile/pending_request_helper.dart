import 'package:event_ease/features/auth/presentation/controller/profile/model/user_pending_credit_request.dart';
import 'package:flutter/material.dart';

Widget buildRequestCard(PendingCreditRequestOfUser req) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Business logo or fallback image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              req.businessId.logo.isNotEmpty ? req.businessId.logo : req.image,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) =>
                      const Icon(Icons.business, size: 50, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),

          /// Main info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.businessId.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  req.businessOwner.name,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.credit_card,
                      size: 16,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${req.usedCredits} credits used',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  req.text,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                /// Status & date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(req.status),
                    Text(
                      _formatDate(req.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Build colored chip for status
Widget _buildStatusChip(String status) {
  Color bg;
  switch (status.toLowerCase()) {
    case 'approved':
      bg = Colors.green.shade100;
      break;
    case 'rejected':
      bg = Colors.red.shade100;
      break;
    default:
      bg = Colors.orange.shade100;
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
        fontSize: 12,
        color:
            status == 'pending'
                ? Colors.orange.shade800
                : status == 'approved'
                ? Colors.green.shade800
                : Colors.red.shade800,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// Date formatting helper
String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}
