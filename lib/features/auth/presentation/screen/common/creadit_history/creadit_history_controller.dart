import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/common/creadit_history/creadit_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CreditHistoryPageController extends GetxController {
  RxBool isLoading = false.obs; // To handle loading state
  RxList<CreditData> creditHistory =
      <CreditData>[].obs; // Observable list for credit history

  Position? position;

  @override
  void onInit() {
    super.onInit();
    // Optional: Fetch credit history immediately on page load
    fetchCreditHistory(null);
  }

  Future<void> fetchCreditHistory(String? name) async {
    isLoading.value = true; // Show loading spinner

    try {
      final response = await ApiService.to.getApi(AppUrl.creditHistory);

      if (response.success && response.data != null) {
        if (response.data is List) {
          List<CreditData> fetchedCreditHistory =
              (response.data as List).map((item) {
                return CreditData.fromJson(item);
              }).toList();

          creditHistory.value = fetchedCreditHistory;
        }
      } else {
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error in fetchCreditHistory: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false; // Hide loading spinner
    }
  }
}
