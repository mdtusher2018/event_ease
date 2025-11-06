import 'dart:developer';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/deshboard_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../../data/repository/business_repository.dart';

class DeshBoardController extends GetxController {
  var stats = Rxn<DeshBoardModel>();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxInt competitionScore = 0.obs;
  RxString suggestedPack = ''.obs;
  RxInt notificationCountNum = 0.obs;

  final BusinessRepository businessRepository = BusinessRepository();

  @override
  void onInit() {
    super.onInit();
    fetchDeshBoardDetails(status: "business");
    fetchCompetitorDetails(status: "business");
  }

  Future<void> notificationCount(String type, String id) async {
    isLoading.value = true;
    try {
      final response = await businessRepository.getNotificationCount(type, id);
      if (response.statusCode == 200) {
        final count = int.tryParse(response.data['count'].toString()) ?? 0;
        notificationCountNum.value = count;
        log("Notification Count: ${notificationCountNum.value}");
      } else {
        log("Error: ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in notificationCount(): $e");
      log("Stack trace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeshBoardDetails({
    String? parentBusinessId,
    required String status,
  }) async {
    parentBusinessId ??= await PrefsHelper.getParentBusinessId();
    isLoading.value = true;
    errorMessage.value = '';

    String url = "";
    if (status == "business") {
      url = AppUrl.getdeshboardBusinessStats(parentBusinessId ?? "");
    } else if (status == "event") {
      url = AppUrl.getdeshboardEventStats(parentBusinessId ?? "");
    } else if (status == "job") {
      url = AppUrl.getdeshboardJobStats(parentBusinessId ?? "");
    }

    try {
      final ApiResponse response = await ApiService.to.getApi(url);
      if (response.success && response.data != null) {
        stats.value = DeshBoardModel.fromJson(response.data);
        log("Fetched Stats: ${stats.value?.totalFollowers}");
      } else {
        errorMessage.value = response.message;
        log("Dashboard Error: ${response.message}");
      }
    } catch (e, s) {
      errorMessage.value = 'Something went wrong';
      log("Exception in fetchDeshBoardDetails: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompetitorDetails({
    String? parentBusinessId,
    required String status,
  }) async {
    parentBusinessId ??= await PrefsHelper.getParentBusinessId();
    String url = "";
    if (status == "business") {
      url = AppUrl.businessCompetitionScore(parentBusinessId ?? "");
    } else if (status == "event") {
      url = AppUrl.eventCompetitionScore(parentBusinessId ?? "");
    } else if (status == "job") {
      url = AppUrl.jobCompetitionScore(parentBusinessId ?? "");
    }

    if (parentBusinessId == null || parentBusinessId.isEmpty) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final ApiResponse response = await ApiService.to.getApi(url);
      if (response.success && response.data != null) {
        competitionScore.value =
            int.tryParse(response.data["competitionScore"].toString()) ?? 0;
        suggestedPack.value = response.data['suggestedPack'] ?? '';
      } else {
        errorMessage.value = response.message;
        log("Competition Error: ${response.message}");
      }
    } catch (e, s) {
      errorMessage.value = 'Something went wrong';
      log("Exception in fetchCompetitorDetails: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }
}
