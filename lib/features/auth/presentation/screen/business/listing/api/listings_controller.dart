import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/job_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/my_bussiness_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/my_events_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class ListingController extends GetxController {

  RxBool isLoading = false.obs;
  RxList<MyBusinessModel> businessList = <MyBusinessModel>[].obs;
  RxList<MyEventModel> eventList = <MyEventModel>[].obs;
RxList<JobModel> jobList = <JobModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBusinesses();
    fetchMyEvents();
    fetchMyJobs();
  }

  Future<void> fetchMyBusinesses() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.getMyBusiness);

      if (response.success && response.data != null) {
        final businessResponse = List<MyBusinessModel>.from(response.data.map((x) => MyBusinessModel.fromJson(x??{})),
      );

        businessList.assignAll(businessResponse);
        log("Fetched ${businessList.length} businesses");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetchAllBusinesses: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


 Future<void> fetchMyEvents() async {
  isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.getMyEvents);

      if (response.success && response.data != null) {
        final businessResponse = List<MyEventModel>.from(response.data.map((x) => MyEventModel.fromJson(x)),
      );

        eventList.assignAll(businessResponse);
        log("Fetched ${businessList.length} events");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch All Events: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }





 Future<void> fetchMyJobs() async {
  isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.getMyJobs);

      if (response.success && response.data != null) {
        final jobResponse = List<JobModel>.from(response.data.map((x) => JobModel.fromJson(x)),
      );

        jobList.assignAll(jobResponse);
        log("Fetched ${businessList.length} job");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch All jobs: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


}








