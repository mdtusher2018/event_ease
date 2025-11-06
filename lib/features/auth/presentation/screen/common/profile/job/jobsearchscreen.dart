import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/common/profile/job/jobsearch_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final JobSearchController wizardController = Get.put(JobSearchController());

  @override
  void initState() {
    super.initState();
    
    log("jobData ====== ${wizardController.job}");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppString.search,style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold),)),
      body:     Column(
      children: [
        /// 🔎 Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchField(
            hintText: AppString.search,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.close),
            controller: searchController,
            readOnly: false,
            onChanged: (p0) {
              setState(() {});
            },
            onPressedSuffix: () {
              searchController.clear();
              setState(() {});
            },
          ),
        ),

        /// 📌 Job List
        Expanded(child: _buildJobList()),
      ],
    )
 
    );

  }

  /// Job List
  Widget _buildJobList() {
    return Obx(() {
      final query = searchController.text.toLowerCase();
      final filtered = wizardController.job.where((result) {
        final name = result["title"]?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();

      return _buildResultList(filtered);
    });
  }

  /// Reusable List Builder
  Widget _buildResultList(List<dynamic> results) {
    if (results.isEmpty) {
      return const Center(child: Text("No results found"));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final data = results[index];
        return ListTile(
          leading: CommonImage(imageSrc: AppIcons.job,width: 20,height: 20,),
          title: Text(
            data["title"] ?? '',
            style: styleForNormalText.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
      
          onTap: () {
            wizardController.getFreeJobSearchData(
              searchValue: data["title"] ?? "",
            );
          },
        );
      },
    );
  }
}
