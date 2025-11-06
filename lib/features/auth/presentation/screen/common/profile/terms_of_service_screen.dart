// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/profile/term_of_condition_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';

class TermsOfServiceScreen extends StatelessWidget {
  TermsOfServiceScreen({super.key});

  TermOfConditionController controller = Get.find<TermOfConditionController>();

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
            AppString.termsOfService,
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
                : controller.termCondition.isEmpty
                ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Terms Of Service Empty",  style: styleForBoldText.copyWith(color: AppColors.darkGrey, fontWeight: FontWeight.w400,fontSize: 16.sp, height: 1.20.h)),
                    const SizedBox(height: 20)
                  ],
                ))
                : Html(data: controller.termCondition.value);
          }),
        ));
  }
}
