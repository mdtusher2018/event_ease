import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/my_subscription_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';




class SubscriptionHistoryController extends GetxController {
  // Reactive list of subscription data
  var subscriptions = <MySponsorSubscriptionData>[].obs;

  // Loading state
  var isLoading = false.obs;

  // Error message
  var errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  // Fetch subscriptions from API
  Future<void> fetchSubscriptions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.to.getApi(AppUrl.getMySubscriptionsHistory);

      if (response.statusCode == 200) {
        
        subscriptions.value = (response.data as List)
          .map((e) => MySponsorSubscriptionData.fromJson(e))
          .toList();
      } else {
        errorMessage.value = 'Failed to load subscriptions';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
