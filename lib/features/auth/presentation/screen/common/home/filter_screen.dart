import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedLocation = "Rome";
  RangeValues budgetRange = RangeValues(0, 3);
  double guestCount = 0;
  double fixedStartValue = 0;
  String sortBy = "High to Low";

  final List<String> budgetLabels = ['0', '€', '€€', '€€€', '€€€€'];
  WizardController wizardController = Get.find<WizardController>();

  @override
  void initState() {
    super.initState();
    wizardController.searchCtl.value.clear();
    Future.microtask(() {
      wizardController.getCatagory();
      Geolocator.getCurrentPosition().then((value) {
        wizardController.buissnessLat.value = value.latitude.toString();
        wizardController.buissnessLng.value = value.longitude.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.filter,
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Type Section
            Text(
              AppString.eventType,
              style: styleForBoldText.copyWith(
                color: AppColors.primary,
                height: 1.56.h,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),

            //=====================================================================event type section
            SizedBox(
              height: 40.h,
              child: Obx(() {
                return wizardController.isCatagory.value
                    ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                    : ListView.builder(
                      itemCount: wizardController.eventCatagory.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        bool isSelected = wizardController.eventType.contains(
                          wizardController.eventCatagory[index],
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                wizardController.eventType.remove(
                                  wizardController.eventCatagory[index],
                                );
                                setState(() {});
                              } else {
                                wizardController.eventType.add(
                                  wizardController.eventCatagory[index],
                                );
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ), // Similar to Chip's internal padding
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 0.4,
                                ),
                              ),
                              child: Text(
                                wizardController.eventCatagory[index],
                                style: styleForNormalText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
              }),
            ),
            SizedBox(height: 10),

            //=================================================================== Location Section
            Text(
              AppString.location,
              style: styleForBoldText.copyWith(
                color: AppColors.primary,
                height: 1.56.h,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),

            GooglePlaceAutoCompleteTextField(
              textEditingController: wizardController.searchCtl.value,
              googleAPIKey: AppUrl.googleMapPlaceKey,
              focusNode: FocusNode(),
              inputDecoration: InputDecoration(
                hintText: AppString.searchLocation,
                border: InputBorder.none,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              debounceTime: 800,

              isCrossBtnShown: false,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (prediction) {
                wizardController.buissnessLat.value = prediction.lat ?? "0.0";
                wizardController.buissnessLng.value = prediction.lng ?? "0.0";
                log(
                  "lat=====${wizardController.buissnessLat.value}\n lang=====${wizardController.buissnessLng.value}",
                );
              },
              itemClick: (prediction) {
                wizardController.searchCtl.value.text = prediction.description!;
              },
            ),

            SizedBox(height: 20.h),

            // Budget Range Section
            Text(
              AppString.budgetRange,
              style: styleForBoldText.copyWith(
                color: AppColors.primary,
                height: 1.56.h,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6),
                activeTickMarkColor: AppColors.primary,
                inactiveTickMarkColor: AppColors.primary,
                rangeTickMarkShape: RoundRangeSliderTickMarkShape(
                  tickMarkRadius: 5,
                ),
                activeTrackColor: AppColors.primary,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withOpacity(0.2),
                valueIndicatorColor: AppColors.primary,
              ),
              child: RangeSlider(
                values: RangeValues(fixedStartValue, budgetRange.end),
                min: 0,
                max: 4,
                divisions: 4,
                labels: RangeLabels(
                  budgetLabels[fixedStartValue.round()],
                  budgetLabels[budgetRange.end.round()],
                ),
                onChanged: (RangeValues values) {
                  double end = values.end.roundToDouble();
                  wizardController.budgetManage(range: end);
                  setState(() {
                    if (end < fixedStartValue) {
                      end = fixedStartValue;
                    }
                    budgetRange = RangeValues(fixedStartValue, end);
                  });
                },
              ),
            ),

            SizedBox(height: 10.h),

            // Guest Count Section
            Text(
              AppString.guestCount,
              style: styleForBoldText.copyWith(
                color: AppColors.primary,
                height: 1.56.h,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Slider(
              value: guestCount,
              min: 0,
              max: 500,
              divisions: 50,
              label: guestCount.round().toString(),
              onChanged: (double value) {
                wizardController.maxGuest.value = value.toInt();
                log("maxGuest=============${wizardController.maxGuest.value}");
                setState(() {
                  guestCount = value;
                });
              },
            ),
            SizedBox(height: 10.h),

            // Sort By Section
            Text(
              AppString.sortBy,
              style: styleForBoldText.copyWith(
                color: AppColors.primary,
                height: 1.56.h,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<String>(
              value: sortBy,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldBg,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items:
                  ["High to Low", "Low to High"]
                      .map(
                        (sortOption) => DropdownMenuItem(
                          value: sortOption,
                          child: Text(
                            sortOption,
                            style: styleForNormalText.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                wizardController.sortBy.value = value ?? "";
                log("sortby=============${wizardController.sortBy.value}");
                setState(() {
                  sortBy = value!;
                });
              },
            ),
            SizedBox(height: 30.h),

            Obx(() {
              return CustomButton(
                isLoading: wizardController.isBuissnessFilter.value,
                fontSize: 18.sp,
                text: AppString.applyFilter,
                onTap: () {
                  wizardController.getFilteredBuissness();
                  // Get.toNamed(RoutesName.nav);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
