import 'dart:developer';
import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_button.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        AppString.stepServicesDetails,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '${AppString.whatDoesYourBusinessOffer}?',
                        style: styleForNormalText.copyWith(
                          color: AppColors.grey,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildProviderDropdown(),
                      SizedBox(height: 20.h),
                      _buildServiceListSection(
                        title: AppString.supportedServiceTypes,
                        showList: controller.showSupportedServiceList,
                        serviceList: controller.supportedServiceList,
                        selectedStates: controller.selectedSupportedStates,
                        selectedServices: controller.selectedSupportedServices,
                      ),
                      SizedBox(height: 20.h),
                      _buildServiceListSection(
                        title: AppString.additionalServices,
                        showList: controller.showAdditionalServiceList,
                        serviceList: controller.additionalServiceList,
                        selectedStates: controller.selectedAdditionalStates,
                        selectedServices: controller.selectedAdditionalServices,
                      ),
                      SizedBox(height: 20.h),
                      _buildPriceRangeSection(),
                      SizedBox(height: 20.h),
                      _buildGuestCapacitySection(),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Obx(() => CustomButton(
                text: AppString.save,
                isLoading: controller.isLoading.value,
                onTap: () => controller.updateServiceDetailInfo(
                  controller.businessProfileModel.value.id,
                ),
              )),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProviderDropdown() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppString.providerType,
          style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600)),
      SizedBox(height: 10.h),
      Obx(() {
        final providerItems = controller.providerList.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item["_id"],
            child: Text(item["name"], style: styleForNormalText.copyWith(fontSize: 14.sp)),
          );
        }).toList();

        // Ensure selected value exists in the list
        final selected = controller.selectedProviderType.value;
        final hasSelected = providerItems.any((item) => item.value == selected);

        return DropdownButtonFormField<String>(
          value: hasSelected ? selected : null,
          decoration: InputDecoration(
            fillColor: AppColors.textFieldBg,
            filled: true,
            hintText: AppString.providerType,
            hintStyle: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 14.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          items: providerItems,
          onChanged: (value) {
            if (value != null) controller.selectedProviderType.value = value;
          },
        );
      }),
    ],
  );


  Widget _buildServiceListSection({
    required String title,
    required RxBool showList,
    required RxList serviceList,
    required RxList<bool> selectedStates,
    required RxList<String> selectedServices,
  }) => Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary)),
        IconButton(
          onPressed: () => showList.toggle(),
          icon: Icon(showList.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.grey),
        ),
      ]),
      if (showList.value)
        serviceList.isEmpty || selectedStates.length != serviceList.length
            ? Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text("No Data", style: styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.darkGrey)),
        )
            : Column(
          children: List.generate(serviceList.length, (index) {
            final serviceName = serviceList[index]['name'];
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              side: BorderSide(color: AppColors.primary),
              title: Text(serviceName, style: styleForBoldText.copyWith(fontSize: 14.sp, color: AppColors.darkGrey)),
              value: selectedStates[index],
              onChanged: (val) {
                selectedStates[index] = val ?? false;
                if (val == true && !selectedServices.contains(serviceName)) {
                  selectedServices.add(serviceName);
                } else {
                  selectedServices.remove(serviceName);
                }
                log("Services updated: $selectedServices");
              },
            );
          }),
        ),
    ],
  ));

  Widget _buildPriceRangeSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppString.priceRange, style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary)),
      SizedBox(height: 10.h),
      Obx(() => Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: controller.priceOptions.map((option) {
          final label = option["label"]!;
          final value = option["value"]!;
          return ChoiceChip(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.grey, width: 0.3)),
            label: Text(label),
            selected: controller.selectedPriceRange.value == value,
            onSelected: (selected) => controller.handlePriceRangeChange(selected ? value : ''),
            checkmarkColor: Colors.white,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(color: controller.selectedPriceRange.value == value ? Colors.white : Colors.black),
            backgroundColor: Colors.white,
          );
        }).toList(),
      )),
    ],
  );

  Widget _buildGuestCapacitySection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppString.maximumGuestCapacity, style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.primary)),
      SizedBox(height: 10.h),
      Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.textFieldBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.guestCount.value.toString(), style: styleForNormalText.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            Row(
              children: [
                IconButton(onPressed: controller.decrementGuestCount, icon: Icon(Icons.remove_circle, color: AppColors.primary)),
                IconButton(onPressed: controller.incrementGuestCount, icon: Icon(Icons.add_circle_outlined, color: AppColors.primary)),
              ],
            ),
          ],
        ),
      )),
    ],
  );
}
