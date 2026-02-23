import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/engagment%20handle/comment_model.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/routers/routes_name.dart';
import '../models/my_model/my_post_model.dart';
import '../models/my_model/poll_model.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find<CommunityController>();
  RxBool isLoading = false.obs;
  UserRepository userRepository = UserRepository();
  RxList<MyPostModel> myPostList = <MyPostModel>[].obs;
  RxList<MyPostModel> latestPostList = <MyPostModel>[].obs;
  RxList<MyPostModel> mostViewedPostList = <MyPostModel>[].obs;
  RxList<MyPostModel> mostCommentPostList = <MyPostModel>[].obs;
  RxList<PollModel> latestPollList = <PollModel>[].obs;
  RxList<PollModel> myPollList = <PollModel>[].obs;
  RxMap<String, int> selectedPollOptions = <String, int>{}.obs;

  RxMap<String, int> selectedMyPollOptions = <String, int>{}.obs;

  TextEditingController commentController = TextEditingController();

  RxList<MyPostModel> groupList = <MyPostModel>[].obs;
  RxList<MyPostModel> regionList = <MyPostModel>[].obs;

  RxString replyingTo = "".obs;
  RxString replyToName = "".obs;

  //=============================================================get comment
  RxList<EventComment> commentList = <EventComment>[].obs;
  Future<void> getComment({id}) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getComments(id: id);
      if (response.statusCode == 200) {
        final List data = response.data as List;
        commentList.value = data.map((e) => EventComment.fromJson(e)).toList();
        log("Fetched commentList : $commentList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get My Post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getMyPost() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getMyPost();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        myPostList.value = data.map((e) => MyPostModel.fromJson(e)).toList();
        log("Fetched community my post : $myPostList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Latest Post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getLatestPost() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getLatestPost();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        latestPostList.value = data
            .map((e) => MyPostModel.fromJson(e))
            .toList();
        log("Fetched community my post : $latestPostList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Latest Post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getMostCommentPost() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getMostCommentPost();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        mostCommentPostList.value = data
            .map((e) => MyPostModel.fromJson(e))
            .toList();
        log("Fetched community my post : $mostCommentPostList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Latest Post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getMostViewedPost() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getMostViewedPost();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        mostViewedPostList.value = data
            .map((e) => MyPostModel.fromJson(e))
            .toList();
        log("Fetched community my post : $mostViewedPostList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Latest poll >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getLatestPoll() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getLatestPoll();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        latestPollList.value = data.map((e) => PollModel.fromJson(e)).toList();
        log("Fetched community my post : $latestPollList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get My poll >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getMyPoll() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getMyPoll();
      if (response.statusCode == 200) {
        final List data = response.data as List;
        myPollList.value = data.map((e) => PollModel.fromJson(e)).toList();
        log("Fetched community my post : $myPollList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> patch vote (My Poll) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> patchMyPoll(String pollId, int index) async {
    if (selectedMyPollOptions.containsKey(pollId)) {
      Get.snackbar("Notice", "You have already voted on this poll.");
      return;
    }

    log(">>>>>>>>>>>>>>> MyPoll Id : ============= $pollId");
    log(">>>>>>>>>>>>>>> MyPoll index : ============= $index");

    isLoading.value = true;
    try {
      var body = {"pollId": pollId, "optionIndex": index};

      final response = await userRepository.patchVote(body);
      if (response.statusCode == 200) {
        selectedMyPollOptions[pollId] = index; // ✅ mark vote
        log("Successfully voted on MyPoll $pollId");
        Get.snackbar("Successful".tr, response.message);

        /// ✅ refresh my polls list
        await getMyPoll();
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> patch vote >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> patchLatestPoll(String pollId, int index) async {
    if (selectedPollOptions.containsKey(pollId)) {
      Get.snackbar("Notice", "You have already voted on this poll.");
      return;
    }

    log(">>>>>>>>>>>>>>> Id : ============= $pollId");
    log(">>>>>>>>>>>>>>> index : ============= $index");

    isLoading.value = true;
    try {
      var body = {"pollId": pollId, "optionIndex": index};

      final response = await userRepository.patchVote(body);
      if (response.statusCode == 200) {
        selectedPollOptions[pollId] = index; // Move this up
        log("Successfully voted on poll $pollId");
        Get.snackbar("Successful".tr, response.message);
        await getLatestPoll();
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Group >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getCommunityGroup(String name, {bool iAmNorGuest = true}) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getCommunityGroup(name);
      if (response.statusCode == 200) {
        final List data = response.data as List;
        groupList.value = data.map((e) => MyPostModel.fromJson(e)).toList();
        log("Fetched community Group : $groupList");
        Get.toNamed(
          RoutesName.seeAllPostScreen,
          arguments: {
            "data": "group",
            'name': name,
            'iAmNotGuest': iAmNorGuest,
          },
        );
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Region >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getCommunityRegion(String name,{bool iAmNotGuest=true}) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getCommunityRegion(name);
      if (response.statusCode == 200) {
        final List data = response.data as List;
        regionList.value = data.map((e) => MyPostModel.fromJson(e)).toList();
        log("Fetched community region : $regionList");
        Get.toNamed(
          RoutesName.seeAllPostScreen,
          arguments: {"data": "region", 'name': name,'iAmNotGuest':iAmNotGuest},
        );
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Like post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> likePost(String id, {MyPostModel? data}) async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {"postId": id};

      final response = await userRepository.postLike(body);
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");
        if (data != null && data.isLiked == false) {
          data.isLiked = true;
          data.totalLikes = data.totalLikes + 1;
        }
        await getLatestPost();
        await getMyPost();
        await getMostCommentPost();
        await getMostViewedPost();
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> unlike post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> unLikePost(String id, {MyPostModel? data}) async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {"postId": id};

      final response = await userRepository.postUnLike(body);
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");
        if (data != null && data.isLiked == true) {
          data.isLiked = false;

          data.totalLikes = data.totalLikes - 1;
        }
        await getLatestPost();
        await getMyPost();
        await getMostCommentPost();
        await getMostViewedPost();
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Comment post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  RxBool isSheet = false.obs;

  Future<void> commentPost(
    String id,
    BuildContext context, {
    MyPostModel? postData,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {
        "postId": id,
        "text": commentController.text,
        if (replyingTo.value.isNotEmpty) "commentId": replyingTo.value,
      };

      log("commentbody========$body");

      final response = await userRepository.commentPost(
        body,
        isReply: replyingTo.value.isNotEmpty,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");

        if (postData != null) {
          postData.totalComments = postData.totalComments + 1;
        }

        commentController.clear();
        await getLatestPost();
        await getMyPost();

        // ✅ Only close the bottom sheet
        Navigator.of(context).pop();

        // Get.back(); /============== here back not working
        log("comment success============================================");
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> New  Comment post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  TextEditingController titleController = TextEditingController();
  TextEditingController eventShortDescriptionController =
      TextEditingController();
  RxString selectedCategory = "".obs;
  RxString selectedRegion = "".obs;
  RxString image = "".obs;

  void pickImage() async {
    image.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  void removeImage() async {
    image.value = "";
  }

  void clearAddPostForm() {
    titleController.clear();
    eventShortDescriptionController.clear();
    selectedCategory.value = "";
    selectedRegion.value = "";
    image.value = "";
  }

  Future<void> addNewCommentPost({required List<File> galleryLogo}) async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {
        "title": titleController.text,
        "category": selectedCategory.value,
        "region": selectedRegion.value,
        "description": eventShortDescriptionController.text,
      };

      final multiPartData = <MultipartBody>[];

      if (image.value.isNotEmpty) {
        multiPartData.add(MultipartBody("image", File(image.value)));
      }
      for (var file in galleryLogo) {
        multiPartData.add(MultipartBody("gallery", file));
      }

      // Map<String, String> heder = {"Content-Type": "application/json"};

      final response = await userRepository.newCommentPost(
        body,
        multipartBody: multiPartData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success ✅");
        clearAddPostForm();
        await getMyPost();
        Get.back();
        Get.snackbar("Success".tr, "Post added successfully!");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editCommentPost(
    String id, {
    required List<File> galleryLogo,
    required List<String> deletedImage,
  }) async {
    isLoading.value = true;
    try {
      var body = {
        "data": jsonEncode({
          "title": titleController.text,
          "category": selectedCategory.value,
          "region": selectedRegion.value,
          "description": eventShortDescriptionController.text,
          "deleteGallery": deletedImage,
        }),
      };

      final multiPartData = <MultipartBody>[];

      if (image.value.isNotEmpty) {
        multiPartData.add(MultipartBody("image", File(image.value)));
      }

      for (var file in galleryLogo) {
        multiPartData.add(MultipartBody("gallery", file));
      }

      // Map<String, String> heder = {"Content-Type": "application/json"};

      final response = await userRepository.editCommentPost(
        body,
        id,
        multipartBody: multiPartData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success ✅");
        clearAddPostForm();
        await getMyPost();
        Get.back();
        Get.snackbar("Success".tr, "Post Updated successfully!");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> New  Comment Poll >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  final TextEditingController titleController2 = TextEditingController();
  final TextEditingController eventShortDescriptionController2 =
      TextEditingController();
  final TextEditingController categoryController2 = TextEditingController();
  final List<TextEditingController> optionControllers = [];

  final ScrollController scrollController = ScrollController();

  RxString selectedCategory2 = "".obs;
  RxString selectedRegion2 = "".obs;

  void clearAddPostForm2() {
    titleController2.clear();
    eventShortDescriptionController2.clear();
    selectedCategory2.value = "";
    selectedRegion2.value = "";
  }

  Future<void> addNewCommentPoll() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "title": titleController2.text.trim(),
        "category": selectedCategory2.value,
        "region": selectedRegion2.value,
        "description": eventShortDescriptionController2.text.trim(),
        "options": optionControllers
            .where((c) => c.text.trim().isNotEmpty)
            .map((c) => {"text": c.text.trim()})
            .toList(),
      };

      final response = await userRepository.newCommentPoll(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success ✅");
        clearAddPostForm2();
        await getLatestPoll();
        Get.back();
        Get.snackbar("Success".tr, "Poll added successfully!");
        getMyPoll();
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editPoll(String id) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "title": titleController2.text.trim(),
        "category": selectedCategory2.value,
        "region": selectedRegion2.value,
        "description": eventShortDescriptionController2.text.trim(),
        "options": optionControllers
            .where((c) => c.text.trim().isNotEmpty)
            .map((c) => {"text": c.text.trim()})
            .toList(),
      };

      final response = await userRepository.editCommentPoll(body, id);
      if (response.success) {
        log(">>>>>>>>>>>>>>> Success ✅");
        clearAddPostForm2();
        await getLatestPoll();
        Get.back();
        Get.snackbar("Success".tr, "Poll added successfully!");
        getMyPoll();
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyPost();
    getLatestPost();
    getMostCommentPost();
    getMostViewedPost();
    getLatestPoll();
    getMyPoll();
  }
}
