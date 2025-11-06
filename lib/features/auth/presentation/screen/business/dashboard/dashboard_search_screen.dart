
// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/deshboard_search_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/business/dashboard/click_search_option_business.dart';
import '../../../widgets/business/dashboard/click_search_option_event.dart';
import '../../../widgets/business/dashboard/click_search_option_job.dart';

class DashboardSearchScreen extends StatelessWidget {
DashboardSearchScreen({super.key});
BusinessListController controller=Get.put(BusinessListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            labelStyle: styleForBoldText.copyWith(fontSize: 14),
            tabs:  [
              Tab(text: AppString.business),    
              Tab(text: AppString.event),
              Tab(text: AppString.job),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body:  Obx(
          () {
            if(controller.isLoading.value){
              return Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                ClickSearchOptionBusiness(businessList:  controller.businessList),
                ClickSearchOptionEvent(eventList: controller.eventList,),
                ClickSearchOptionJob(jobList: controller.jobList,),
              ],
            );
          }
        ),
      ),
    );
  }
}