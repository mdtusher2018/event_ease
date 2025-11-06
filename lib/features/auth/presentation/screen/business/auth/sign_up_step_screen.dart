// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/auth/sign_up_step_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/Sign_up_step/build_step_eight.dart';
import '../../../widgets/Sign_up_step/build_step_four.dart';
import '../../../widgets/Sign_up_step/build_step_seven.dart';
import '../../../widgets/Sign_up_step/build_step_six.dart';
import '../../../widgets/Sign_up_step/build_step_three.dart';
import '../../../widgets/Sign_up_step/build_step_two.dart';
import '../../../widgets/Sign_up_step/build_step_one.dart';
import '../../../widgets/Sign_up_step/build_step_five.dart';
import '../../../widgets/Sign_up_step/build_step_nine.dart';

class SignUpStepScreen extends StatelessWidget {
  SignUpStepScreen({super.key});

  SignUpStepController controller = Get.find<SignUpStepController>();
  String promotionLogo ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed:() {
            if (controller.currentPage.value > 0) {
              controller.goToPreviousPage();
            } else {
              Get.back(); // go back to previous screen
            }
          },
          icon: const Icon(Icons.arrow_back),
          
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Get.offAndToNamed(RoutesName.nav);
        //     },
        //     child: Text("Skip Now",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppColors.primary),)),
        //   SizedBox(width: 16,)
        // ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.onPageChanged,
              children: [
                BuildStepOne(onContinue: controller.goToNextPage),
                BuildStepTwo(onContinue: controller.goToNextPage),
                BuildStepThree(onContinue: controller.goToNextPage),
                BuildStepFour(onContinue: controller.goToNextPage),
                BuildStepFive(onContinue: controller.goToNextPage),
                BuildStepSix(onContinue: controller.goToNextPage),
                BuildStepSeven(onContinue: controller.goToNextPage),
                BuildStepEight(onContinue: controller.goToNextPage),
                BuildStepNine(onComplete: controller.createCompleteBusiness),
              ],
            ),
          ),
    
          // Page Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(9, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: controller.currentPage.value == index ? 30.0.w : 5.0.h,
                  height: 5.0.h,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index ? AppColors.primary : AppColors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              }),
            )),
          ),
        ],
      ),
    
    );
  }

}
