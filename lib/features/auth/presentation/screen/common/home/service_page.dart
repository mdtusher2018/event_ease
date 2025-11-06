import 'dart:developer';

import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';

class ServicesPage extends StatefulWidget {
  final List<String> selectedServices;
  final VoidCallback onNext;

  const ServicesPage({
    super.key,
    required this.selectedServices,
    required this.onNext
  });

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController searchController = TextEditingController();
  
  WizardController wizardController = Get.find<WizardController>();



  List<String> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = List.from(wizardController.supportAndAdditionalcontroller.additionalServices.map((element) {
      return element.name;
    },).toList());
    searchController.addListener(_filterServices);
  }

  void _filterServices() {
    setState(() {
      filteredServices = wizardController.supportAndAdditionalcontroller.additionalServices.map((element) {
      return element.name;
    },).toList()
          .where((service) => service.toLowerCase().contains(searchController.text.toLowerCase()))
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
      padding:  EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(child: Container(
             padding: EdgeInsets.all(14),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(24),
               border: Border.all(color: AppColors.grey, width: 0.4)
             ),
             child: Column(children: [
               Center(
                 child: Text(
                   "${AppString.whatServicesDoYouNeed}?",
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
                     hintStyle:styleForNormalText.copyWith(fontSize: 14.sp),
                     prefixIcon:  Icon(Icons.search, color: Colors.grey, size: 16.r,),
                     suffixIcon: IconButton(
                       icon:  Icon(Icons.close, color: Colors.grey, size: 16.r,),
                       onPressed: () {
                         searchController.clear();
                       },
                     ),
                     border: InputBorder.none,
                     contentPadding:  EdgeInsets.symmetric(vertical: 15.0.h),
                   ),
                 ),
               ),
               const SizedBox(height: 16),
               // Services
               Expanded(
                 child: SingleChildScrollView(
                   child: Wrap(
                     spacing: 8.0,
                     runSpacing: 12.0,
                     children: filteredServices.map((service) {
                       final isSelected = widget.selectedServices.contains(service);
                       final isSelect = wizardController.selectedAdditionalService.contains(service);
                       return GestureDetector(
                         onTap: () {
                          
                             if (isSelect) {
                               wizardController.selectedAdditionalService.remove(service);
                             } else {
                               wizardController.selectedAdditionalService.add(service);
                             }
                             log("selectedAdditional======================${wizardController.selectedAdditionalService}");
                           setState(() {
                             if (isSelected) {
                               widget.selectedServices.remove(service);
                             } else {
                               widget.selectedServices.add(service);
                             }
                           });
                         },
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(
                             color: isSelected ? AppColors.primary : Colors.white,
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(
                               color: isSelected ? AppColors.primary : Colors.grey.shade300,
                             ),
                           ),
                           child: Text(
                             service,
                             style: styleForNormalText.copyWith(fontSize: 14.sp, color: isSelected ? Colors.white : AppColors.darkGrey),
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
             ],),
           )),
           SizedBox(height: 16.h),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              // Allow proceeding even if no services are selected
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child:  Text(
                AppString.next,
                  style: styleForBoldText.copyWith(fontSize: 16.sp, color: AppColors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}