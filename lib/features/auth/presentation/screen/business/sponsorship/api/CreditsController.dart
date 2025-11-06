import 'dart:developer';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class CreditsController extends GetxController {
  /// Holds credits as String
  RxString credits = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyTotalCredits();
  }

  /// Fetch credits from API
  Future<void> fetchMyTotalCredits() async {
    try {
      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.myTotalCredits,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final totalCredits = (data['totalCredits'] as num?)?.toDouble() ?? 0.0;

        credits.value = totalCredits.toStringAsFixed(2);
        log("✅ Total Credits: ${credits.value}");
      } else {
        log("❌ Error fetching credits: ${response.message}");
      }
    } catch (e) {
      log("⚠️ Exception fetching credits: $e");
    }
  }
}
