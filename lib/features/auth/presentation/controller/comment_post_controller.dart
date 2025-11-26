import 'dart:developer';
import 'package:event_ease/features/auth/presentation/models/my_model/my_post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/post_details_model.dart';

class CommentPostController extends GetxController {
  final RxBool isLoading = false.obs;
  final UserRepository userRepository = UserRepository();

  Rx<PostDetailsModel> details = PostDetailsModel().obs;

  TextEditingController reportController = TextEditingController();
RxString replyingTo = "".obs;
RxString replyToName = "".obs;
TextEditingController commentController=TextEditingController();
  Future<void> getPostDetail(String id) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getPostDetail(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        details.value = PostDetailsModel.fromJson(response.data);
      } else {
        log("Error: \${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Exception: $e\nStackTrace: $s");
      Get.snackbar("Exception".tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> report({required String type, required String id}) async {
    isLoading.value = true;
    try {
      var body = {
        "type": type, // 'Inspiration', 'PostCommunity', 'PollCommunity',"Bussiness","Event","Job"
        "targetId": id,
        "reason": reportController.text,
      };
      final response = await userRepository.postCommunityReport(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Successful".tr, response.message);
      } else {
        log("Error: \${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Exception: $e\nStackTrace: $s");
      Get.snackbar("Exception".tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> commentPost(
    String id,
    BuildContext context, {
    MyPostModel? postData,
  }) async {
    try {
      final Map<String, String> body = {
        "postId": id,
        "text": commentController.text,
        if(replyingTo.value.isNotEmpty)"commentId": replyingTo.value,
  
      };

      log("commentbody========$body");

log(replyingTo.value.toString()+"..............");
      final response = await userRepository.commentPost(body,isReply:  replyingTo.value.isNotEmpty);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");

        if (postData != null) {
          postData.totalComments = postData.totalComments + 1;
        }

        commentController.clear();
    
        // Get.back(); /============== here back not working
        log("comment success============================================");
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }



}
