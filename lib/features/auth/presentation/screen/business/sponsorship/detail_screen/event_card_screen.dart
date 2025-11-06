// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/event_profile_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/widgets/commonSubscriptionCardDesign.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/payment_selection_page.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/help_center/help_center_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/styles.dart';


class EventCardScreen extends StatelessWidget {
   EventCardScreen({super.key,required this.id,required this.eventName});


  String id;String eventName;
  final controller = Get.put(
    EventSubscriptionProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Event Card",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Choose the Level of Visibility You Want!",
              style: styleForBoldText.copyWith(fontSize: 30.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h,),
            Text(
              "The higher the package, the more visibility you get in search results.",
              style: styleForNormalText.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.50.h,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text("Event Card", style: styleForBoldText.copyWith(fontSize: 24.sp)),
            Text(
              "Promote your business profile in search result",
              style: styleForNormalText.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.56.h,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
        

 Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          physics: NeverScrollableScrollPhysics(),
          
          shrinkWrap: true,
          itemCount: controller.subscriptionPlans.length,
          itemBuilder: (context, index) {
            final model = controller.subscriptionPlans[index];
            return SubscriptionCard(model: model,selectButtonOnTap: (){
              // Get.to(PaymentMethodScreen(amount: model.options.first.price.toDouble(),
              // duration: model.options.first.expirationDays as int,
              // subscriptionFor: id,
              // subscriptionForType: "Event",subscriptionId: model.id,
              // subscriptionOptionIndex: 0,
              // subscriptionName: model.title,
              // name: eventName,
              // ));
            },onOptionTap: (i){
                Get.to(PaymentMethodScreen(amount: model.options[i].price.toDouble(),
              duration: model.options[i].expirationDays as int,
              subscriptionFor: id,
              subscriptionForType: "Event",subscriptionId: model.id,
              subscriptionOptionIndex: i,
              subscriptionName: model.title,
              name: eventName,
              ));
            },indexFonExpantion: index,);
            
          },
        );
      }),

           
           
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Want customized visibility?',
                    style: styleForNormalText.copyWith(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500
                    ),
                    children: [
                      TextSpan(
                        recognizer:  TapGestureRecognizer()
          ..onTap = () {
            // TODO: Add your navigation or action
            Get.to(() => HelpCenterScreen(target: 1,)); 
          },
                        text: ' Contact Us ',
                        style: styleForBoldText.copyWith(fontSize: 16.sp,decoration: TextDecoration.underline,
                            height: 1.50),),
                      TextSpan(
                        text: 'for a personalized package!',
                        style: styleForNormalText.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
