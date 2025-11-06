// ignore_for_file: must_be_immutable

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/profile/change_password_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  ChangePasswordController controller = ChangePasswordController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){Get.back();},
              icon: Icon(Icons.arrow_back, color: Colors.black,)
          ),
          title: Text(
            AppString.changePassword,
              style: styleForBoldText.copyWith(fontSize: 24.sp)
          ),

        ),
        body: Form(
          key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
              SizedBox(height: 20,),
              CustomTextField(
                  backgroundColor: AppColors.textFieldBg,
                  prefixIcon: AppIcons.passwordIcon,
                  hintText: AppString.enterOldPassword,
                  isSuffix: true,
                  controller: controller.oldPasswordController),
              const SizedBox(height: 14),
              CustomTextField(
                  backgroundColor: AppColors.textFieldBg,
                  prefixIcon: AppIcons.passwordIcon,
                  hintText: AppString.enterNewPassword,
                  isSuffix: true,
                  validator: (value) => OtherHelper.passwordValidator(value),
                  controller: controller.newPasswordController),
              const SizedBox(height: 14),
              CustomTextField(
                  validator: (value) => OtherHelper.confirmPasswordValidator(value, controller.newPasswordController),
                  backgroundColor: AppColors.textFieldBg,
                  prefixIcon: AppIcons.passwordIcon,
                  hintText: AppString.confirmNewPassword,
                  isSuffix: true,
                  controller: controller.confirmPasswordController),
              const SizedBox(height: 20),
              Spacer(),
              Obx(() => CustomButton(
                onTap: (){
                  if (_formKey.currentState!.validate()) {
                    controller.changePassword();
                  }
                },
                isLoading: controller.isLoading.value,
                text: AppString.changePassword,
                borderRadius: 12,
              ),),

              const SizedBox(height: 30),
                          ],
                        ),
            )
        )
    );
  }
}
