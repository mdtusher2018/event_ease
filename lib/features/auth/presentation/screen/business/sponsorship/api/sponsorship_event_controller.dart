import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class SponsorshipEventListController extends GetxController {
  RxList<EventNameModel> eventList = <EventNameModel>[].obs;
  RxBool isLoading = false.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
       fetchEventList();
  }




  Future<void> fetchEventList() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final ApiResponse response = await ApiService.to.getApi(AppUrl.getMyEventList);

      if (response.success && response.data != null) {
        final List<EventNameModel> loadedList = (response.data as List)
            .map((json) => EventNameModel.fromJson(json))
            .toList();

        eventList.assignAll(loadedList);
        log("Fetched ${eventList.length} event");
      } else {
        errorMessage = response.message;
        log("Event list fetch error: $errorMessage");
      }
    } catch (e) {
      errorMessage = 'Something went wrong';
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }



}
