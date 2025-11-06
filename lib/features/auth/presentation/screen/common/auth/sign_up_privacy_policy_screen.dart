import 'package:event_ease/features/auth/presentation/controller/auth/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
class SignUpPrivacyPolicyScreen extends StatefulWidget {
  const SignUpPrivacyPolicyScreen({super.key});

  @override
  State<SignUpPrivacyPolicyScreen> createState() => _SignUpPrivacyPolicyScreenState();
}

class _SignUpPrivacyPolicyScreenState extends State<SignUpPrivacyPolicyScreen> {
  final SignUpController controller = Get.find<SignUpController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPrivacyPolicySignUp();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppString.privacyPolicy,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (controller.privacyPolicySignUp.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "Privacy Policy Empty",
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 20.sp,
                      height: 1.20.h,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return Html(data: controller.privacyPolicySignUp.value);
        }),
      ),
    );
  }
}
