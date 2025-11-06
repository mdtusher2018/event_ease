// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_url.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/custom_button.dart';

class AddressMapScreen extends StatelessWidget {
   AddressMapScreen({super.key});

   BusinessProfileController controller = Get.find<BusinessProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Make BuildStepOne scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                      Text(
                        AppString.stepAddressMap,
                        style: styleForBoldText.copyWith(fontSize: 24.sp),
                      ),
                    SizedBox(height: 10.h),
                    Text(
                      '${AppString.whereAreYouLocated}?',
                      style: styleForNormalText.copyWith(color: AppColors.grey, fontSize: 18.sp, fontWeight: FontWeight.w600,),
                    ),
                    SizedBox(height: 16.h),
                    // Business Name Field
                    Text(
                        AppString.address,
                        style: styleForBoldText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600,)
                    ),
                    SizedBox(height: 10.h),
                    Obx(() => GooglePlaceAutoCompleteTextField(
                      textEditingController: controller.addressSearchController.value,
                      googleAPIKey: AppUrl.googleMapPlaceKey,
                      containerVerticalPadding: 4,
focusNode: FocusNode(),
                      inputDecoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: AppString.searchLocation,
                        hintStyle: styleForNormalText.copyWith(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        fillColor: AppColors.textFieldBg,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      debounceTime: 800,
                      boxDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.textFieldBg
                      ),
                      
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {},
                      itemClick: (prediction) {
                        
                        controller.addressSearchController.value.text = prediction.description!;
                        // searchController.text = prediction.description!;
                        controller.addressSearchController.value.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      },
                    ),),
                    SizedBox(height: 15.h),
                    // Short Description Field
                    // Text(
                    //     AppString.geolocation,
                    //     style: styleForBoldText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                    // ),
                    // SizedBox(height: 10.h),
                    // Obx(() => GestureDetector(
                    //   onTap: () async {
                    //     // Map data = await Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(
                    //     //     builder: (context) =>
                    //     //         CreateEventScreenMap(), // Show the LocationScreen
                    //     //   ),
                    //     // );
                    //     // controller.selectedAddress = data['address'];
                    //     // setState(() {});
                    //     // controller.latitude.value = data['lat'];
                    //     // controller.longitude.value = data['lng'];
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: AppColors.textFieldBg,
                    //       borderRadius: BorderRadius.circular(12),
                    //       border: Border.all(color: AppColors.primary, width: 2),
                    //     ),
                    //     child: ListTile(
                    //         title: Text(controller.geoLocation.value, style: styleForNormalText.copyWith(
                    //           color: AppColors.grey,
                    //           fontSize: 14.sp,
                    //           fontWeight: FontWeight.w600,
                    //         ),),
                    //         trailing: SvgPicture.asset(AppIcons.locationIcon)
                    //       // title: controller.selectedAddress.isEmpty
                    //       //     ? Text("Location")
                    //       //     : CommonText(text: controller.selectedAddress, textAlign: TextAlign.start,),
                    //     ),
                    //   ),
                    // ),),
                    // SizedBox(height: 10.h),

                  ],
                ),
              ),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() => CustomButton(
              text: AppString.save,
              isLoading: controller.isLoading.value,
              onTap: (){controller.updateAddressMapInfo(controller.businessProfileModel.value.id);},
            ),),
          ),
        ],
      ),
    );
  }
}
