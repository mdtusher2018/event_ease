import 'dart:developer';

import 'package:get/get.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import '../services/api_service.dart';
import 'comment_model.dart'; // Update path accordingly

class CommentController extends GetxController {
  RxList<EventComment> comments = <EventComment>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;




// Track which comment the user is replying to (null = no reply)
RxString replyingTo = "".obs;
RxString replyToName = "".obs;













  /// Fetch comments by type (event or business)
  Future<void> fetchComments({
    required String id,
    required bool isBusiness,
    String? url
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    comments.clear();

    try {
    url ??=
          isBusiness
              ? AppUrl.getBusinessComments(id)
              : AppUrl.geteventComments(id); // Ensure this method exists

      final ApiResponse response = await ApiService.to.getApi(url!);

      if (response.success && response.data != null) {
        final List<EventComment> fetchedComments =
            (response.data as List)
                .map((item) => EventComment.fromJson(item))
                .toList();
        comments.assignAll(fetchedComments);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> postComment({
    required String id,
    required String text,
    required bool isBussiness,
    Map<String, dynamic>? body,
    String? url,
  }) async {
    try {
      body ??= {
        if (isBussiness) "businessId": id,
        if (!isBussiness) "eventId": id,
        "text": text,
      };
url??=(isBussiness) ? AppUrl.postBusinessComment : AppUrl.postEventComment;
      final ApiResponse response = await ApiService.to.postApi(
        url,
        body,
      );
      log(response.toString());
      if (response.success) {
        Get.snackbar("Success".tr, "Comment added successfully".tr);
        return true;
      } else {
        Get.snackbar("Failed".tr, response.message);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error".tr, "Something went wrong: $e");
      return false;
    }
  }

  void clearComments() {
    comments.clear();
  }




  Future<bool> postCommentReply({
    required String id,
    required String text,
    required bool isBussiness,
    Map<String, dynamic>? body,
    String? url,
  }) async {
    try {
      body ??= {
        if (isBussiness) "businessId": id,
        if (!isBussiness) "eventId": id,
         "commentId": replyingTo.value,
        "text": text,
      };
url??=(isBussiness) ? AppUrl.postBusinessCommentReply : AppUrl.postEventCommentReply;
      final ApiResponse response = await ApiService.to.postApi(
        url,
        body,
      );
      log(response.toString());
      if (response.success) {
        Get.snackbar("Success".tr, "Reply added successfully");
        return true;
      } else {
        Get.snackbar("Failed".tr,response.message);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error".tr,"Something went wrong: $e");
      return false;
    }
  }


}


