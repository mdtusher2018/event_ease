import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class AttendeeCountPage extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onCountSelected;

  const AttendeeCountPage({
    super.key,
    required this.onNext,
    required this.onCountSelected,
  });

  @override
  _AttendeeCountPageState createState() => _AttendeeCountPageState();
}

class _AttendeeCountPageState extends State<AttendeeCountPage> {
  WizardController wizardController = Get.find<WizardController>();
  String? selectedCount;

  final List<String> attendeeOptions = [
    "Fewer than 20 people",
    "20-50 People",
    "50-100 People",
    "100-500 People",
    "500-1000 People",
    "More Than People",
  ];
  List<String> attendanceOptions = [
    "fewer than 20",
    "20-50",
    "50-100",
    "100-150",
    "150-200",
    "more than 200",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.grey, width: 0.4),
              ),
              child: Column(
                children: [
                  Text(
                    "${AppString.howManyPeopleWillAttend}?",
                    style: styleForBoldText.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 24.h),
                  // Attendee count options
                  Expanded(
                    child: ListView.builder(
                      itemCount: attendeeOptions.length,
                      itemBuilder: (context, index) {
                        final option = attendeeOptions[index];
                        final isSelected = selectedCount == option;

                        return GestureDetector(
                          onTap: () {
                            wizardController.peopleAttend.value =
                                attendanceOptions[index];
                            log(
                              "attendance option===============${wizardController.peopleAttend}",
                            );

                            setState(() {
                              selectedCount = option;
                            });
                            widget.onCountSelected(option);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              color:
                                  isSelected
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.white,
                            ),
                            child: Text(
                              option.tr,
                              style: styleForBoldText.copyWith(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.darkGrey,
                                fontSize: 14.sp,
                              ),
                              // TextStyle(
                              //   fontSize: 16,
                              //   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              //   color: isSelected ? AppColors.primary : Colors.black,
                              // ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed:
                  widget.onNext, //selectedCount != null ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppString.next,
                style: styleForBoldText.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
