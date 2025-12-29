import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/common/role_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteProfilePage extends StatefulWidget {
  const DeleteProfilePage({super.key});

  @override
  State<DeleteProfilePage> createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password is required".tr)));
      return;
    }

    setState(() => _isLoading = true);

    final body = {"password": password};

    try {
      final response = await ApiService.to.deleteApi(
        // 👈 use your ApiService
        "${AppUrl.baseUrl}/users/delete-my-account",
        body: body,
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Get.offAll(RoleScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data["message"] ?? "Delete failed".tr),
          ),
        );
      }
    } catch (e) {
      log("Delete Account Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Confirm Delete".tr),
            content: Text(
              "Are you sure you want to delete your account? This action cannot be undone."
                  .tr,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text("Cancel".tr),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _deleteAccount();
                },
                child: Text("Delete".tr, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Delete Your Account".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This action is permanent and cannot be undone.\nPlease enter your password to confirm."
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password".tr,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _showConfirmDialog,
                      label:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                "Delete Account".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
