import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/common/profile/job/jobserch_model.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/job/search_details_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class JobSearchController extends GetxController {
  RxBool isGetJob = false.obs;
  RxList<Map<String, String>> job = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getJobName();
  }

  Future<void> getJobName() async {
    isGetJob(true);
    try {
      var response = await ApiService.to.getApi(AppUrl.categoryJobNameList);
      if (response.statusCode == 200) {
        List data = response.data;
        job.clear();
        for (var i = 0; i < data.length; i++) {
          String title = data[i]["name"] ?? "";
          job.add({"title": title});
        }
        log("job name ====================$job");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching job names: $e");
    } finally {
      isGetJob(false);
    }
  }

  //=============================================================get free job search data
  RxBool isJobSearch = false.obs;

  RxList<JobSearchModel> jobSearchResult = <JobSearchModel>[].obs;

  Future<void> getFreeJobSearchData({String searchValue = ""}) async {
    isJobSearch(true);
    try {
      searchValue = searchValue.replaceAll("&", "%26");
      var response = await ApiService.to.getApi(
        AppUrl.freeJobSearch(searchValue),
      );

      // response.data is already a List
      List data = response.data['data'];
      log("free job search data ======$data");

      if (response.statusCode == 200) {
        jobSearchResult.clear();
        Get.to(
          () => JobSearchResultScreen(),
          transition: Transition.rightToLeftWithFade,
        );
        jobSearchResult.value =
            data.map((value) => JobSearchModel.fromJson(value)).toList();
        log(jobSearchResult.length.toString());
        log("Free job search====================$jobSearchResult");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching job search data: $e");
    } finally {
      isJobSearch(false);
    }
  }
}
