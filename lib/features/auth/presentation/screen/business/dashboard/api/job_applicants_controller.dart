import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/job_applicants_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class JobApplicantsController extends GetxController {
  var isLoading = false.obs;
  String? errorMessage;
  String id;
  JobApplicantsController({required this.id});


@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchJobApplicants();
  }

  final RxList<ApplicantUser> applicants = <ApplicantUser>[].obs;

  Future<void> fetchJobApplicants() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final ApiResponse response = await ApiService.to.getApi(AppUrl.getJobApplicants(id));
      log("${response.data}.........................");

      if (response.success && response.data != null) {
        final dataJson = response.data;

        final JobApplicantModel data = JobApplicantModel.fromJson(dataJson);
        applicants.assignAll(data.applicantUsers);

        log("Fetched ${applicants.length} job applicants");
      } else {
        errorMessage = response.message;
        log("API Error: $errorMessage");
        Get.snackbar("Error".tr,errorMessage!);
      }
    } catch (e,s) {
      errorMessage = 'Something went wrong';
      log("Exception while fetching job applicants: $e\n$s");
      Get.snackbar("Error".tr,errorMessage!);
    } finally {
      isLoading.value = false;
    }
  }
}
