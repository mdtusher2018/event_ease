import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/job/jobsearch_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';

import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_related_job_Container.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JobSearchResultScreen extends StatelessWidget {
  JobSearchResultScreen({super.key});

  final JobSearchController controller = Get.find<JobSearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Job Search Results".tr,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              hintText: AppString.search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.close),
              controller: TextEditingController(),
              readOnly: false,

              onTap: () {
                Get.back();
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Obx(() {
                if (controller.isJobSearch.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.jobSearchResult.isEmpty) {
                  return const Center(child: Text("No jobs found."));
                }

                return ListView.separated(
                  itemCount: controller.jobSearchResult.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final job = controller.jobSearchResult[index];

                    return CustomRelatedJobContainer(
                      onTap: () {
                        Get.toNamed(
                          RoutesName
                              .jobDetailScreen, // Replace with your route name
                          arguments: job.id,
                        );
                      },
                      id: job.id,
                      typeImage: AppIcons.jobIcon,
                      bookType: "jobId",
                      eventJobImage: job.coverImage,
                      type: job.contractType,
                      name: job.title,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
