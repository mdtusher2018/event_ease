// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/helper/other_helper.dart';
import '../../../../controller/comment_post_controller.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_button.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  CommentPostController controller = Get.find<CommentPostController>();

  @override
  Widget build(BuildContext context) {
    log("runtimetype==============${Get.arguments.runtimeType}");
    final String type = Get.arguments['type']?? "";
    final String id = Get.arguments['id']?? "";
    log(">>>>>>> Type ======== $type");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Get.back();
          },
        ),

        title: Text(AppString.report, style: styleForBoldText.copyWith(fontSize: 24.sp),),

      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                validator: (value) => OtherHelper.validator(value),
                controller: controller.reportController,
                maxLines: 3, // Maximum number of lines
                maxLength: 100,
                decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.all(10),
                    hintText: "${AppString.writeReport}...",
                    hintStyle: styleForNormalText.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(borderSide: BorderSide.none)
              ),
            ),),

            SizedBox(
              height: 20,
            ),
            Obx(() => InkWell(
                onTap: () => controller.report(type: type, id: id),
                child: CustomButton(
                  isLoading: controller.isLoading.value,
                  fontSize: 18,
                  text: AppString.submitReport,
                  // isLoading: controller.isLoading,
                )
            ),)

          ],
        ),
      ),

    );
  }
}
