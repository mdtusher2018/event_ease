// ignore_for_file: must_be_immutable

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/profile/business_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/drawer/custom_drawer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileScreen extends StatelessWidget {
   BusinessProfileScreen({super.key});
  BusinessProfileController controller = Get.find<BusinessProfileController>();

  @override
  Widget build(BuildContext context) {
    controller.getBusinessProfile();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppString.businessProfile, style: styleForBoldText.copyWith(fontSize: 23)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.businessProfileModel.value.id.isEmpty) {
          return  Center(child: Text(AppString.noDataFound));
        }

        return Column(
          children: [
            CustomDrawerListTile(title: AppString.generalInformation, onTabFunction: () => Get.toNamed(RoutesName.generalInfoScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.imagesMedia, onTabFunction: () => Get.toNamed(RoutesName.imageMediaScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.contactInformation, onTabFunction: () => Get.toNamed(RoutesName.contactInfoScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.socialNetworks, onTabFunction: () => Get.toNamed(RoutesName.socialNetworkScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.businessHours, onTabFunction: () => Get.toNamed(RoutesName.businessHourScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.addressMap, onTabFunction: () => Get.toNamed(RoutesName.addressMapScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.servicesDetails, onTabFunction: () => Get.toNamed(RoutesName.serviceDetailsScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.faq, onTabFunction: () => Get.toNamed(RoutesName.faqScreen)),
            const Divider(),
            CustomDrawerListTile(title: AppString.promotions, onTabFunction: () => Get.toNamed(RoutesName.promotionScreen)),
          ],
        );
      }),
    );
  }
}
