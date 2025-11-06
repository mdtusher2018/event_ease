
import 'package:event_ease/features/auth/presentation/screen/common/home/wizard_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'free_search_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WizardController wizardController = Get.find<WizardController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getApiData();
  }

  getApiData() async {
    await wizardController.getBuissnessName();
    await wizardController.getEventName();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.primary,
            labelStyle: styleForNormalText.copyWith(
              fontSize: 16.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: AppString.freeSearch),
              Tab(text: AppString.wizard),
            ],
            onTap: (index) {
              // Only allow switching if allowed
              if (wizardController.allowPageSwipe.value) {
                _tabController.animateTo(index);
                if (index == 1) {
                  wizardController.getCatagory();
                }
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() {
          return TabBarView(
            controller: _tabController,
            physics:
                wizardController.allowPageSwipe.value
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
            children: [FreeSearchScreen(), const WizardScreen()],
          );
        }),
      ),
    );
  }
}
