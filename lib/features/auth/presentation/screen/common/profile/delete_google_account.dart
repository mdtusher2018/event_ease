import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/common/role_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeleteGoogleAccountPage extends StatefulWidget {
  const DeleteGoogleAccountPage({super.key});

  @override
  State<DeleteGoogleAccountPage> createState() =>
      _DeleteGoogleAccountPageState();
}

class _DeleteGoogleAccountPageState extends State<DeleteGoogleAccountPage> {
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    final password = otpController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Otp is required".tr)));
      return;
    }

    setState(() => _isLoading = true);

    final body = {"otp": password};

    try {
      final response = await ApiService.to.deleteApi(
        // 👈 use your ApiService
        "${AppUrl.baseUrl}/users/delete-my-account",
        body: body,
      );

      if (response.statusCode == 200) {
        await GoogleSignIn().signOut();
        await PrefsHelper.removeAllPrefData();
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> sendotp() async {
    setState(() => _isLoading = true);
    setState(() => otpSent = true);

    try {
      final response = await ApiService.to.postApi(
        // 👈 use your ApiService
        "${AppUrl.baseUrl}/otp/send-delete-account-otp",
        {},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data["message"] ?? "Otp send")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: Otp send failed")));
      }
    } catch (e) {
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Delete Account"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Warning Icon
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),

              /// Title
              Text(
                "Delete Your Account",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// Description
              Text(
                "Your account was created using Google Sign-In. "
                "To delete your account permanently, please verify your identity using OTP.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 30),

              /// Send OTP Button
              ElevatedButton.icon(
                icon: const Icon(Icons.sms),
                label: Text(otpSent ? "Resend OTP" : "Send OTP"),
                onPressed: () {
                  sendotp();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

              const SizedBox(height: 20),

              /// OTP Field
              if (otpSent)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",

                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const Spacer(),

              /// Delete Button
              ElevatedButton(
                onPressed:
                    otpSent
                        ? () {
                          _showConfirmDialog();
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.red.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),

              const SizedBox(height: 10),

              /// Disclaimer
              Text(
                "This action is irreversible. All your data will be permanently deleted.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
