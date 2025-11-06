import 'package:event_ease/features/auth/presentation/screen/common/home/service_page.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/regular/home_screen/search/select_event_category_page.dart';
import 'attendee_count_page.dart';
import 'budget_page.dart';
import 'location_selection_page.dart';
import 'location_type_page.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  _WizardScreenState createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> selectedCategories = [];
  String? selectedLocation;
  String? selectedAttendeeCount;
  final List<String> selectedLocationType = [];
  final List<String> selectedServices = [];
  String? selectedBudget;

  final WizardController wizardController = Get.find<WizardController>();

  void goToNextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wizardController.searchCtl.value.text =
        selectedLocation ?? "12, Roma, Lazio, Italy";
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SelectEventCategoryPage(
        onNext: goToNextPage,
        selectedCategories: selectedCategories,
      ),

      LocationSelectionPage(
        onNext: goToNextPage,
        onLocationSelected: (location) {
          setState(() {
            selectedLocation = location;
          });
        },
      ),

      AttendeeCountPage(
        onNext: goToNextPage,
        onCountSelected: (count) {
          setState(() {
            selectedAttendeeCount = count;
          });
        },
      ),

      LocationTypePage(
        selectedLocationTypes: selectedLocationType,
        onNext: goToNextPage,
      ),

      ServicesPage(selectedServices: selectedServices, onNext: goToNextPage),

      BudgetPage(
        onNext: () {
          wizardController.getWizard();
          print('Wizard completed with the following data:');
          print('Categories: $selectedCategories');
          print('Location: $selectedLocation');
          print('Attendee Count: $selectedAttendeeCount');
          print('Location Types: $selectedLocationType');
          print('Services: $selectedServices');
          print('Budget: $selectedBudget');
        },
        onBudgetSelected: (budget) {
          setState(() {
            selectedBudget = budget;
          });
        },
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              physics:
                  wizardController.allowPageSwipe.value
                      ? const PageScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              children: pages,
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 30.0.w : 5.0.h,
                height: 5.0.h,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? AppColors.primary
                          : AppColors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
