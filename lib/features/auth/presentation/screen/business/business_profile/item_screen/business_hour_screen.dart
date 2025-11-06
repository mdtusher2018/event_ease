import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_button.dart';

class BusinessHourScreen extends StatelessWidget {
  BusinessHourScreen({super.key});
  final BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.stepBusinessHours, style: styleForBoldText.copyWith(fontSize: 24.sp)),
                    SizedBox(height: 10.h),
                    Text(
                      '${AppString.whenAreYouAvailableForCustomers}?',
                      style: styleForNormalText.copyWith(
                        color: AppColors.grey,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// Days of the Week
                    Text(
                      AppString.daysOfWeek,
                      style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: 8.h),

                    Obx(() {
                      return Column(
                        children: List.generate(controller.dayNames.length, (index) {
                          return CheckboxListTile(
                            title: Text(
                              controller.dayNames[index],
                              style: styleForBoldText.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.darkGrey,
                                height: 1.4,
                                letterSpacing: 0.2,
                              ),
                            ),
                            value: controller.selectedDays[index],
                            onChanged: (value) {
                              controller.selectedDays[index] = value!;
                              final day = controller.dayNames[index];
                              if (value) {
                                controller.selectedDayNames.addIf(!controller.selectedDayNames.contains(day), day);
                              } else {
                                controller.selectedDayNames.remove(day);
                              }
                            },
                          );
                        }),
                      );
                    }),

                    SizedBox(height: 16.h),

                    /// Start Time
                    Text(
                      AppString.startTime,
                      style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: 8),
                    Obx(() => InkWell(
                      onTap: () => controller.selectTime(context, true),
                      child: buildTimeField(controller.startTime.value),
                    )),
                    SizedBox(height: 16.h),

                    /// End Time
                    Text(
                      AppString.endTime,
                      style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: 8),
                    Obx(() => InkWell(
                      onTap: () => controller.selectTime(context, false),
                      child: buildTimeField(controller.endTime.value),
                    )),

                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),

          /// Save Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(
              text: AppString.save,
              isLoading: controller.isLoading.value,
              onTap: () {
                controller.updateSBusinessHourInfo(controller.businessProfileModel.value.id);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget buildTimeField(String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.textFieldBg,
      ),
      child: Row(
        children: [
          Icon(Icons.watch_later, color: Colors.black),
          SizedBox(width: 8),
          Text(
            time.isNotEmpty ? time : "Select Time",
            style: styleForNormalText.copyWith(fontSize: 14.sp, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}
