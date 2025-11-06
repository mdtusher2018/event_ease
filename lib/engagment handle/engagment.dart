import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

Future<bool> likeUnlike({
  required bool isLike,
  required String businessId,
}) async {
  final String endpoint = isLike ? AppUrl.unlikeBusiness : AppUrl.likeBusiness;

  try {
    final Map<String, dynamic> body = {"businessId": businessId};

    final ApiResponse response = await ApiService.to.postApi(endpoint, body);

    if (response.success) {

      return true;
    } else {
      Get.snackbar("Error".tr,response.message);
      log("Action failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in likeUnlike: $e");
    Get.snackbar("Error".tr,"Something went wrong. Please try again.");
  }
  return false;
}

Future<bool> eventLikeUnlike({
  required bool isLike,
  required String eventId,
}) async {
  final String endpoint = isLike ? AppUrl.unlikeEvent : AppUrl.likeEvent;

  try {
    final Map<String, dynamic> body = {"eventId": eventId};

    final ApiResponse response = await ApiService.to.postApi(endpoint, body);

    if (response.success) {

      return true;
    } else {
      Get.snackbar("Error".tr,response.message);
      log("Action failed: ${response.message}");
    }
  } catch (e) {
    log("Exception in likeUnlike: $e");
    Get.snackbar("Error".tr,"Something went wrong. Please try again.");
  }
  return false;
}

Future<bool> followUnfollow({
  required String businessId,
  required bool isFollowed,
}) async {
  final String url =
      isFollowed
          ? AppUrl
              .businessUnfollow // If already followed, then unfollow
          : AppUrl.businessFollow; // If not followed, then follow

  try {
    final Map<String, dynamic> body = {"businessId": businessId};

    final ApiResponse response = await ApiService.to.postApi(url, body);

    if (response.success) {
      Get.snackbar(
        "Success".tr,
        isFollowed ? "Unfollowed successfully".tr : "Followed successfully".tr,
      );
      return true;
    } else {
      Get.snackbar("Error".tr,response.message);
      return false;
    }
  } catch (e) {
    Get.snackbar("Exception".tr, "Something went wrong: $e");
    return false;
  }
}
