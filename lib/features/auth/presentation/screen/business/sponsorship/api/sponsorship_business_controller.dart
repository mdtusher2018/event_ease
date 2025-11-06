import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class SponsorshipBusinessListController extends GetxController {
  RxList<BusinessNameModel> businessList = <BusinessNameModel>[].obs;
  RxBool isLoading = false.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchBusinessList();
  }

  Future<void> fetchBusinessList() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final ApiResponse response = await ApiService.to.getApi(AppUrl.getMyBusinessList);

      if (response.success && response.data != null) {
        final List<BusinessNameModel> loadedList = (response.data as List)
            .map((json) => BusinessNameModel.fromJson(json))
            .toList();

        businessList.assignAll(loadedList);
        log("Fetched ${businessList.length} businesses");
      } else {
        errorMessage = response.message;
        log("Business list fetch error: $errorMessage");
      }
    } catch (e) {
      errorMessage = 'Something went wrong';
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }



}
