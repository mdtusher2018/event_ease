import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../screen/business/dashboard/api/deshboard_search_controller.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_search_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClickSearchOptionJob extends StatefulWidget {
  final RxList<JobNameModel> jobList;

  const ClickSearchOptionJob({super.key, required this.jobList});

  @override
  State<ClickSearchOptionJob> createState() => _ClickSearchOptionJobState();
}

class _ClickSearchOptionJobState extends State<ClickSearchOptionJob> {
  final TextEditingController searchController = TextEditingController();
  BusinessListController controller = Get.put(BusinessListController());

  List<JobNameModel> filteredResults = [];

  @override
  void initState() {
    super.initState();
    filteredResults = widget.jobList;
    ever(widget.jobList, (_) {
      setState(() {
        filteredResults = widget.jobList.toList();
      });
    });
    searchController.addListener(_filterResults);
  }

  void _filterResults() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredResults =
          widget.jobList
              .where((item) => item.name.toLowerCase().contains(query))
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomSearchField(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.close),
            controller: searchController,
            readOnly: false,
            onPressedSuffix: () {
              searchController.clear();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final job = filteredResults[index];
                return ListTile(
                  leading: SvgPicture.asset(AppIcons.jobIcon),
                  title: Text(
                    job.name,
                    style: styleForNormalText.copyWith(fontSize: 16.sp),
                  ),
                  onTap: () {
                    /// Example navigation — adjust based on your app logic
                    // Get.toNamed(
                    //   RoutesName.nav,
                    //   arguments: {
                    //     'status': "job",
                    //     'index': 1,
                    //     'data': job.name,
                    //   },
                    // );
                    controller.filterValue.value = filteredResults[index].name;

                    DashboardScreen.status = "job";
                    DashboardScreen.deshBoardController.fetchDeshBoardDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "job",
                    );
                    DashboardScreen.deshBoardController.fetchCompetitorDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "job",
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
