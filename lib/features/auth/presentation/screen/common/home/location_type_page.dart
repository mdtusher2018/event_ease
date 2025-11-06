import 'dart:developer';

import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';

class LocationTypePage extends StatefulWidget {
  final List<String> selectedLocationTypes;
  final VoidCallback onNext;

  const LocationTypePage({
    super.key,
    required this.selectedLocationTypes,
    required this.onNext,
  });

  @override
  _LocationTypePageState createState() => _LocationTypePageState();
}

class _LocationTypePageState extends State<LocationTypePage> {
  final TextEditingController searchController = TextEditingController();
  WizardController wizardController = Get.find<WizardController>();



  List<String> filteredLocationTypes = [];

  @override
  void initState() {
    super.initState();
    filteredLocationTypes = List.from( wizardController.eventCatagory);
    searchController.addListener(_filterLocationTypes);
  }

  void _filterLocationTypes() {
    setState(() {
      filteredLocationTypes =
           wizardController.eventCatagory
              .where(
                (type) => type.toLowerCase().contains(
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
      padding: EdgeInsets.all(16.0),
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
                      "${AppString.doYouHavePreferencesForTheTypeOfLocation}?",
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
                        hintStyle: styleForNormalText.copyWith(fontSize: 14.sp),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 19.r,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 19.r,
                          ),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Location types
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 12.0,
                        children:
                            filteredLocationTypes.map((type) {
                              final isSelected = widget.selectedLocationTypes
                                  .contains(type);
                              final isSelect = wizardController.locationType
                                  .contains(type);
                              return GestureDetector(
                                onTap: () {
                                  if (isSelect) {
                                    wizardController.locationType.remove(type);
                                  } else {
                                    wizardController.locationType.add(type);
                                  }
                                  log("locationtype ===================${wizardController.locationType}");
                                  setState(() {
                                    if (isSelected) {
                                      widget.selectedLocationTypes.remove(type);
                                    } else {
                                      widget.selectedLocationTypes.add(type);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
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
                                    type,
                                    style: styleForNormalText.copyWith(
                                      fontSize: 14.sp,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.darkGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    // TextStyle(
                                    //   color: isSelected ? Colors.white : Colors.black,
                                    //   fontSize: 14,
                                    // ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
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
              // Allow proceeding even if no location types are selected
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
