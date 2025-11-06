import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class BusinessListController extends GetxController {
  RxString  filterValue = "".obs;
  RxList<BusinessNameModel> businessList = <BusinessNameModel>[].obs;
  RxList<EventNameModel> eventList = <EventNameModel>[].obs;
  RxList<JobNameModel> jobList = <JobNameModel>[].obs;
  RxBool isLoading = false.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchBusinessList();
    fetchEventList();
    fetchJobList();
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
        log("Fetched ${businessList.length} event");
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


  Future<void> fetchJobList() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final ApiResponse response = await ApiService.to.getApi(AppUrl.getMyJobList);

      if (response.success && response.data != null) {
        final List<JobNameModel> loadedList = (response.data as List)
            .map((json) => JobNameModel.fromJson(json))
            .toList();

        jobList.assignAll(loadedList);
        log("Fetched ${businessList.length} job");
      } else {
        errorMessage = response.message;
        log("Job list fetch error: $errorMessage");
      }
    } catch (e) {
      errorMessage = 'Something went wrong';
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }



}
