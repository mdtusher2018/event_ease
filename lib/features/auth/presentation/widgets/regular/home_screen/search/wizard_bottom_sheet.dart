
import 'package:event_ease/features/auth/presentation/models/engagment/comment_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/wizard_controller.dart';

Future<void> WizardBottomSheet(
  BuildContext context, {
  required TextEditingController commentController,
  required VoidCallback onPressed,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (context) {
      WizardController wizardController = Get.find<WizardController>();
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.comments,
              style: styleForBoldText.copyWith(
                fontSize: 24.sp,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: Obx(() {
                return ListView.builder(
                  itemCount: wizardController.commentList.length,
                  itemBuilder: (context, index) {
                    CommentModel data = wizardController.commentList[index];
                    return ListTile(
                      leading: CommonImage(
                        imageSrc: data.user.profileImage,
                        imageType: ImageType.network,
                        borderRadius: 40.r,
                        height: 40.h,
                        width: 40.w,
                      ),
                      title: Text(
                        data.user.name,
                        style: styleForBoldText.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      subtitle: Text(
                        data.text,
                        style: styleForNormalText.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                      fillColor: AppColors.textFieldBg,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.h),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {
                    if (commentController.text.trim().isNotEmpty) {
                      onPressed();
                    } else {
                      Get.snackbar(
                        "Empty Comment",
                        "Please write something before sending.",
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
