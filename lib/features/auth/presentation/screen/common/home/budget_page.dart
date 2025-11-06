import 'dart:developer';

import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';

class BudgetPage extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onBudgetSelected;

  const BudgetPage({
    super.key,
    required this.onNext,
    required this.onBudgetSelected,
  });

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  WizardController wizardController = Get.find<WizardController>();
  String? selectedBudget;
  bool noBudget = false;

  final List<Map<String, String>> budgetOptions = [
    {"label": "${AppString.budgetFriendly} €", "value": "budget"},
    {"label": "${AppString.midRange} €€", "value": "medium"},
    {"label": "${AppString.highEnd} €€€", "value": "high"},
    {"label": "${AppString.luxury} €€€€", "value": "luxury"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(child: Container(
             padding: EdgeInsets.all(14),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(24),
               border: Border.all(color: AppColors.grey, width: 0.4)
             ),
             child: Column(
               children: [
                 Center(
                   child: Text(
                     "${AppString.doYouHaveAMaximumBudget}?",
                     style:  styleForBoldText.copyWith(fontSize: 24.sp),
                     textAlign: TextAlign.center,
                   ),
                 ),
                  SizedBox(height: 24.h),
                 // Budget options
                 Expanded(
                   child: ListView.builder(
                     itemCount: budgetOptions.length + 1, // +1 for "no budget" option
                     itemBuilder: (context, index) {
                       if (index < budgetOptions.length) {
                         final option = budgetOptions[index];
                         final isSelected =
                             selectedBudget == option["value"] && !noBudget;
                             

                         return GestureDetector(
                           onTap: () {
                            wizardController.selectedBudget.value = option["value"]??"";
                            log("selectedBudget======================${wizardController.selectedBudget.value}");
                             setState(() {
                               selectedBudget = option["value"];
                               noBudget = false;
                             });
                             widget.onBudgetSelected(option["value"]!);
                           },
                           child: Container(
                             margin: const EdgeInsets.only(bottom: 12),
                             padding: const EdgeInsets.symmetric(
                               horizontal: 16,
                               vertical: 16,
                             ),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(
                                 color:
                                 isSelected ? AppColors.primary : Colors.grey.shade300,
                                 width: isSelected ? 2 : 1,
                               ),
                               color:
                               isSelected
                                   ? AppColors.primary.withOpacity(0.1)
                                   : Colors.white,
                             ),
                             child: Text(
                                 option["label"]!,
                                 style: styleForNormalText.copyWith(fontSize: 14.sp, fontWeight:
                                 isSelected ? FontWeight.bold : FontWeight.normal,color: isSelected ? AppColors.primary : AppColors.darkGrey)

                             ),
                           ),
                         );
                       } else {
                         // "I don't have precise budget" option
                         final isSelected = noBudget;

                         return GestureDetector(
                           onTap: () {
                             setState(() {
                               noBudget = true;
                               selectedBudget = "No specific budget";
                             });
                             widget.onBudgetSelected("No specific budget");
                           },
                           child: Container(
                             margin: const EdgeInsets.only(bottom: 12),
                             padding:  EdgeInsets.symmetric(
                               horizontal: 16.w,
                               vertical: 16.h,
                             ),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(
                                 color:
                                 isSelected ? AppColors.primary : Colors.grey.shade300,
                                 width: isSelected ? 2 : 1,
                               ),
                               color:
                               isSelected
                                   ? AppColors.primary.withOpacity(0.1)
                                   : Colors.white,
                             ),
                             child: Text(
                               AppString.iDonotHavePrecise,
                               style: styleForNormalText.copyWith(fontSize: 14.sp,fontWeight:
                               isSelected ? FontWeight.bold : FontWeight.normal,
                                 color: isSelected ? AppColors.primary : Colors.black,),

                             ),
                           ),
                         );
                       }
                     },
                   ),
                 ),
               ],
             ),
           )),
           SizedBox(height: 16.h),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: widget.onNext,//(selectedBudget != null) ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:  Obx((){
                return wizardController.isFilter.value? CircularProgressIndicator(
                  color: Colors.white,
                ) :Text(
                    AppString.next,
                    style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.white)
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

