import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';

class SelectEventCategoryPage extends StatefulWidget {
  final List<String> selectedCategories;
  final VoidCallback onNext;

  const SelectEventCategoryPage({
    super.key,
    required this.selectedCategories,
    required this.onNext,
  });

  @override
  _SelectEventCategoryPageState createState() =>
      _SelectEventCategoryPageState();
}

class _SelectEventCategoryPageState extends State<SelectEventCategoryPage> {
  final TextEditingController searchController = TextEditingController();
  WizardController wizardController = Get.find<WizardController>();

  // final List<String> eventCategories = [
  //   "Birthday Party",
  //   "Graduation Party",
  //   "Anniversary",
  //   "Festival",
  //   "Corporate Event",
  //   "Concert",
  // ];

  List<String> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
   await wizardController.getCatagory();
    filteredCategories.clear();
    setState(() {
    filteredCategories = List.from(wizardController.supportAndAdditionalcontroller.services.map((element) {
      return element.name;
    },).toList());
    });
    searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    setState(() {
      filteredCategories =
          wizardController.supportAndAdditionalcontroller.services.map((element) {
      return element.name;
    },).toList()
              .where(
                (category) => category.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                  Center(
                    child: Text(
                      "What type of event do you need to organize?".tr,
                      style: styleForBoldText.copyWith(fontSize: 24.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: AppString.weddingEvent,
                        hintStyle: styleForNormalText.copyWith(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 18.r,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18.r,
                          ),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Categories
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Wrap(
                          // alignment: WrapAlignment.spaceEvenly,
                          spacing: 8.0,
                          runSpacing: 12.0,
                          children:
                          filteredCategories.map((category) {
                            final isSelected = widget.selectedCategories
                                .contains(category);
                            // final isSelect = wizardController
                            //     .selectedCatagory
                            //     .contains(category);
                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  wizardController.selectedService.remove(
                                    category,
                                  );
                                } else {
                                  wizardController.selectedService.add(
                                    category,
                                  );
                                }
                                log("selectService===============${wizardController.selectedService}");
                                setState(() {
                                  if (isSelected) {
                                    widget.selectedCategories.remove(
                                      category,
                                    );
                                  } else {
                                    widget.selectedCategories.add(category);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: styleForNormalText.copyWith(
                                    color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed:
                  widget
                      .onNext, //widget.selectedCategories.isEmpty ? widget.onNext : null,
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
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
