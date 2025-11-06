import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/business_subscription_model.dart';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class EventSubscriptionProfileController extends GetxController {
  RxList<SubscriptionModel> subscriptionPlans = <SubscriptionModel>[].obs;
  RxBool isLoading = false.obs;
  RxString? errorMessage = ''.obs;


  RxString selectedPlan = ''.obs;
  RxSet<String> expandedPlans = <String>{}.obs;

  void selectPlan(String planName) {
    selectedPlan.value = planName;
  }

  bool isPlanSelected(String planName) {
    return selectedPlan.value == planName;
  }

  void toggleExpanded(String planName) {
    if (expandedPlans.contains(planName)) {
      expandedPlans.remove(planName);
    } else {
      expandedPlans.add(planName);
    }
  }

  bool isExpanded(String planName) {
    return expandedPlans.contains(planName);
  }

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    isLoading.value = true;
    errorMessage?.value = '';

    try {
      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.getEventSubscriptionPlans, // ensure this is declared
      );

      if (response.success && response.data != null) {
        final List<SubscriptionModel> plans = (response.data as List)
            .map((json) => SubscriptionModel.fromJson(json))
            .toList();
        subscriptionPlans.assignAll(plans);
        log("Fetched ${plans.length} subscription plans");
      } else {
        errorMessage?.value = response.message;
        log("Subscription fetch error: ${response.message}");
      }
    } catch (e) {
      errorMessage?.value = "Something went wrong: $e";
      log("Subscription fetch exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
