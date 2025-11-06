import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/profile/privacy_policy_controller.dart';
import '../../../utils/app_string.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});
  final PrivacyPolicyController controller = Get.find<PrivacyPolicyController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){Get.back();},
              icon: Icon(Icons.arrow_back)
          ),
          title: Text(
            AppString.privacyPolicy,
            style: styleForBoldText.copyWith(
                fontSize: 24.sp
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Obx(() {
            return controller.isLoading.value == true
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
                : controller.privacyPolicy.isEmpty
                ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Privacy Policy Empty",  style: styleForBoldText.copyWith(color: AppColors.darkGrey, fontSize: 20.sp, height: 1.20.h)),
                    const SizedBox(height: 20)
                  ],
                ))
                : Html(data: controller.privacyPolicy.value);
          }),
        )
    );
  }
}
