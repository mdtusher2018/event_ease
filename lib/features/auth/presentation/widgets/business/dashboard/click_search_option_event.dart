import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/dashboard_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../screen/business/dashboard/api/deshboard_search_controller.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_search_field.dart';

class ClickSearchOptionEvent extends StatefulWidget {
  final RxList<EventNameModel> eventList;

  const ClickSearchOptionEvent({super.key, required this.eventList});

  @override
  State<ClickSearchOptionEvent> createState() => _ClickSearchOptionEventState();
}

class _ClickSearchOptionEventState extends State<ClickSearchOptionEvent> {
  final TextEditingController searchController = TextEditingController();
  BusinessListController controller = Get.put(BusinessListController());

  List<EventNameModel> filteredResults = [];

  @override
  void initState() {
    super.initState();
    filteredResults = widget.eventList;
    ever(widget.eventList, (_) {
      setState(() {
        filteredResults = widget.eventList.toList();
      });
    });
    searchController.addListener(_filterResults);
  }

  void _filterResults() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredResults =
          widget.eventList
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
            hintText: 'Search',
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
                final event = filteredResults[index];
                return ListTile(
                  leading: SvgPicture.asset(AppIcons.eventIcon),
                  title: Text(
                    event.name,
                    style: styleForNormalText.copyWith(fontSize: 16.sp),
                  ),
                  onTap: () {
                    /// You can handle the event selection here
                    /// Example: fetch dashboard details or navigate
                    // DashboardScreen.deshBoardController.fetchDeshBoardDetails(parentEventId: event.id);

                    controller.filterValue.value = filteredResults[index].name;
                    DashboardScreen.status = "event";
                    DashboardScreen.deshBoardController.fetchDeshBoardDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "event",
                    );
                    DashboardScreen.deshBoardController.fetchCompetitorDetails(
                      parentBusinessId: filteredResults[index].id,
                      status: "event",
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
