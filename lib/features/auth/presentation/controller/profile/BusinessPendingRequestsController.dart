import 'dart:developer';
import 'package:event_ease/features/auth/presentation/controller/profile/model/PendingCreditRequestForBusiness.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';
import 'dart:io';

class BusinessPendingRequestsController extends GetxController {
  /// Observable list of pending requests
  var pendingRequests = <PendingCreditRequestForBusiness>[].obs;

  /// Loading states
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    getPendingRequestsForBusiness();
  }

  /// Fetch all pending requests for this business
  Future<void> getPendingRequestsForBusiness() async {
    try {
      log("Fetching pending requests for business...");
      isLoading.value = true;

      final response = await ApiService.to.getApi(
        AppUrl.pendingRequestsOfBusiness,
      );

      if (response.data != null) {
        final List<dynamic> requests = response.data;
        pendingRequests.value =
            requests
                .map((json) => PendingCreditRequestForBusiness.fromJson(json))
                .toList();

        log(
          "✅ ${pendingRequests.length} pending requests fetched successfully",
        );
      } else {
        pendingRequests.clear();
        log("⚠️ No data found for pending requests.");
      }
    } catch (e, s) {
      log("❌ Error fetching pending requests: $e");
      log("$s");
      Get.snackbar("Error", "Failed to load pending requests");
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve a pending request
  Future<void> approveRequest(String requestId) async {
    try {
      isSubmitting.value = true;
      final response = await ApiService.to.patchApi(
        "${AppUrl.approvePendingRequest}/$requestId",
        {},
      );

      if (response.success == true) {
        Get.snackbar("Success", "Request approved successfully!");
        await getPendingRequestsForBusiness(); // refresh list
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      log("❌ Error approving request: $e");
      Get.snackbar("Error", "Failed to approve request");
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Cancel or reject a pending request
  Future<void> rejectRequest(String requestId) async {
    try {
      isSubmitting.value = true;
      final response = await ApiService.to.patchApi(
        "${AppUrl.rejectPendingRequest}/$requestId",
        {},
      );

      if (response.success == true) {
        Get.snackbar("Success", "Request rejected successfully!");
        await getPendingRequestsForBusiness(); // refresh list
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      log("❌ Error rejecting request: $e");
      Get.snackbar("Error", "Failed to reject request");
    } finally {
      isSubmitting.value = false;
    }
  }
}
