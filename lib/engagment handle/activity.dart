import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

Future<bool> switchBusinessActivity({
  required String businessId,
}) async {
  final String endpoint = "${AppUrl.baseUrl}/business/activate/$businessId";

  try {
    final ApiResponse response = await ApiService.to.patchApi(
      endpoint,
      {}, 
    );

    if (response.success) {
      log("Business activity switched successfully: ${response.data}");
      Get.snackbar("Success".tr, "Business activity updated successfully".tr);
      return true;
    } else {
      Get.snackbar("Error".tr, response.message);
      log("Switch activity failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in switchBusinessActivity: $e");
    Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
  }
  return false;
}
Future<bool> switchEventActivity({
  required String businessId,
}) async {
  final String endpoint = "${AppUrl.baseUrl}/event/activate/$businessId";

  try {
    final ApiResponse response = await ApiService.to.patchApi(
      endpoint,
      {}, 
    );

    if (response.success) {
      log("Event activity switched successfully: ${response.data}");
      Get.snackbar("Success".tr, "Event activity updated successfully".tr);
      return true;
    } else {
      Get.snackbar("Error".tr, response.message);
      log("Switch activity failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in switchEventActivity: $e");
    Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
  }
  return false;
}


Future<bool> switchjobActivity({
  required String businessId,
}) async {
  final String endpoint = "${AppUrl.baseUrl}/job/activate/$businessId";

  try {
    final ApiResponse response = await ApiService.to.patchApi(
      endpoint,
      {}, 
    );

    if (response.success) {
      log("Job activity switched successfully: ${response.data}");
      Get.snackbar("Success".tr, "Job activity updated successfully".tr);
      return true;
    } else {
      Get.snackbar("Error".tr, response.message);
      log("Switch activity failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in switchJobActivity: $e");
    Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
  }
  return false;
}


Future<bool> deleteItem({
  required String type, // "event", "job", "business"
  required String id,
}) async {
  final String endpoint = "${AppUrl.baseUrl}/$type/$id";

  try {
    final ApiResponse response = await ApiService.to.deleteApi(endpoint);

    if (response.success) {
      log("${type.capitalizeFirst} deleted successfully: ${response.data}");
      Get.snackbar("Success".tr, "${type.capitalizeFirst} deleted successfully");
      return true;
    } else {
      Get.snackbar("Error".tr, response.message);
      log("Delete $type failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in deleteItem: $e");
    Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
  }
  return false;
}
