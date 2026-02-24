// Dialog to show on tapping "Explore Now"
import 'package:event_ease/features/auth/presentation/screen/common/role_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showExploreDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Explore More Content"),
        content: Text(
          "It looks like you're interested in accessing more features or content. "
          "To continue, please log in to your account. You can also explore more options or cancel if you're not ready.",
        ),
        actions: <Widget>[
          // Log in button
          TextButton(
            onPressed: () {
              Get.to(RoleScreen()); // Navigate to the RoleScreen
            },
            child: Text("Log in", style: TextStyle(color: AppColors.primary)),
          ),

          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}
