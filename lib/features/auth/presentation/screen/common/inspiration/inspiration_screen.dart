import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/routers/routes_name.dart';
import '../../../widgets/regular/inspiration/business_inspiration_content.dart';
import '../../../widgets/regular/inspiration/regular_inspiration_content.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  // // Method to handle popup menu selection
  // void _handleMenuSelection(String value) {
  //   switch (value) {
  //     case 'postBlock':
  //       Get.toNamed(RoutesName.postBlockScreen); // Replace with your actual route name
  //       break;
  //     case 'postEvent':
  //     Get.toNamed(RoutesName.postEventScreen); // Replace with your actual route name
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PrefsHelper.myRole=="organizer"
          ? FloatingActionButton(
        onPressed: () {Get.toNamed(RoutesName.postBlockScreen);},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child:Icon(Icons.add, color: Colors.white),
      )
          : const SizedBox(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: PrefsHelper.myRole=="user"
              ?  RegularInspirationContent()
              :  BusinessInspirationContent(),
        ),
      ),
    );
  }
}