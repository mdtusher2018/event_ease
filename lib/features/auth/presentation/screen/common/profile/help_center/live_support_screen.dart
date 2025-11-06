import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/profile/help_center_controller.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/styles.dart';

class LiveSupportScreen extends StatelessWidget {
  LiveSupportScreen({super.key});

  final HelpCenterController controller = Get.find<HelpCenterController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ Correctly typed

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
          AppString.liveSupport,
          style: styleForBoldText.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Issue Title Field
              Text(
                AppString.typeOfIssue,
                style: styleForBoldText.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                validator: (value) => OtherHelper.validator(value),
                hintText: AppString.typeOfIssue,
                isSuffix: false,
                controller: controller.issueController,
              ),

              const SizedBox(height: 20),

              /// Description Field
              Text(
                AppString.descriptionOfTheProblem,
                style: styleForBoldText.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                validator: (value) => OtherHelper.validator(value),
                hintText: AppString.descriptionOfTheProblem,
                isSuffix: false,
                controller: controller.describeController,
                maxLine: 3,
              ),

              const Spacer(),

              /// Submit Button
              Obx(
                    () => CustomButton(
                  isLoading: controller.isLoading.value,
                  text: AppString.send,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.postTicket();
                    }
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
