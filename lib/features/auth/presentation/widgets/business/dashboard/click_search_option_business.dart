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

class ClickSearchOptionBusiness extends StatefulWidget {
  final RxList<BusinessNameModel> businessList;

  const ClickSearchOptionBusiness({super.key, required this.businessList});

  @override
  State<ClickSearchOptionBusiness> createState() =>
      _ClickSearchOptionBusinessState();
}

class _ClickSearchOptionBusinessState extends State<ClickSearchOptionBusiness> {
  final TextEditingController searchController = TextEditingController();
  BusinessListController controller = Get.put(BusinessListController());

  List<BusinessNameModel> filteredResults = [];

  @override
  void initState() {
    super.initState();
    filteredResults = widget.businessList;
    ever(widget.businessList, (_) {
      setState(() {
        filteredResults = widget.businessList.toList();
      });
    });

    searchController.addListener(_filterResults);
  }

  void _filterResults() {
    setState(() {
      final query = searchController.text.toLowerCase();
      filteredResults =
          widget.businessList
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
                final business = filteredResults[index];
                return ListTile(
                  leading: SvgPicture.asset(AppIcons.businessIcon),
                  title: Text(
                    business.name,
                    style: styleForNormalText.copyWith(fontSize: 16.sp),
                  ),
                  onTap: () {
                    // Get.toNamed(
                    //   RoutesName.nav,
                    //   arguments: {
                    //     'status': "business",
                    //     'index': 1,
                    //     'data': business.name,
                    //   },
                    // );
                    controller.filterValue.value = filteredResults[index].name;
                    DashboardScreen.status = "business";
                    DashboardScreen.deshBoardController.fetchDeshBoardDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "business",
                    );
                    DashboardScreen.deshBoardController.fetchCompetitorDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "business",
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
