import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
// import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/business_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/inspiration/inspiration_controller.dart';
// import 'package:event_ease/features/auth/presentation/models/my_model/map_model.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BlockController extends GetxController {
  RxBool isLoading = false.obs;
  BusinessRepository repository = BusinessRepository();
  RxString coverImage = "".obs;

  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventDetailedDescriptionController =
      TextEditingController();
  RxString selectedCategory = "".obs;
  RxString selectedSubCategory = "".obs;
  InspirationController controller = InspirationController();

  var galleryImages = <String>[].obs;
  var deletedGalleryImages = <String>[].obs;

  Future<void> pickGalleryImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      galleryImages.addAll(images.map((e) => e.path));
    }
  }

  void removeGalleryImage(String path) {
    galleryImages.remove(path);
    deletedGalleryImages.add(path);
  }

  void pickImage() async {
    coverImage.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  void clearAddPostForm() {
    eventTitleController.clear();
    eventDetailedDescriptionController.clear();
    selectedCategory.value = "";
    coverImage.value = "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventTitleController.clear();
    eventDetailedDescriptionController.clear();
    selectedCategory.value = "";
    coverImage.value = "";
  }

  Future<void> postBlog() async {
    if (eventTitleController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter an event title");
      return;
    }

    if (selectedCategory.value.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please select a category");
      return;
    }
    // if (selectedSubCategory.value.trim().isEmpty) {
    //   Get.snackbar("Error".tr, "Please select a sub category");
    //   return;
    // }

    if (eventDetailedDescriptionController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter a detailed description");
      return;
    }

    if (coverImage.value.isEmpty) {
      Get.snackbar("Error".tr, "Please upload a cover image");
      return;
    }
    isLoading.value = true;
    try {
      var body = {
        "data": jsonEncode({
          "title": eventTitleController.text,
          "category": selectedCategory.value,
          "type": "blog",
          "description": eventDetailedDescriptionController.text,
        }),
      };
      final multipartBody = <MultipartBody>[];

      if (coverImage.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverImage.value)));
      }
      for (var file in galleryImages) {
        multipartBody.add(MultipartBody("gallery", File(file)));
      }

      final response = await repository.createBlog(
        body: body,
        multipartBody: multipartBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>> ${response.message}");
        clearAddPostForm();
        // Get.offNamed(RoutesName.inspirationScreen, arguments: {'index':2});
        await controller.getInspirationCategoryGroup();
        await controller.getInspirationMyPost();
        Get.back();
        // Get.offNamed(RoutesName.nav, arguments: {'index': 2},);
        Get.snackbar("Success".tr, response.message);
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error Post", response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBlog(String blogId) async {
    if (eventTitleController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter an event title");
      return;
    }

    if (selectedCategory.value.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please select a category");
      return;
    }
    // if (selectedSubCategory.value.trim().isEmpty) {
    //   Get.snackbar("Error".tr, "Please select a sub category");
    //   return;
    // }

    if (eventDetailedDescriptionController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter a detailed description");
      return;
    }

    if (coverImage.value.isEmpty) {
      Get.snackbar("Error".tr, "Please upload a cover image");
      return;
    }

    isLoading.value = true;
    try {
   
      var body = {
        "data": jsonEncode({
          "title": eventTitleController.text,
          "category": selectedCategory.value,
          // "subCategory": selectedSubCategory.value,
          "type": "blog",
          "description": eventDetailedDescriptionController.text,
          "deleteGallery": deletedGalleryImages, 
        }),
      };

      final multipartBody = <MultipartBody>[];

      if (coverImage.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverImage.value)));
      }

      for (var file in galleryImages) {
        multipartBody.add(MultipartBody("gallery", File(file)));
      }

      final response = await repository.updateBlog(
        blogId: blogId,
        body: body,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>> ${response.message}");
        await controller.getInspirationCategoryGroup();
        await controller.getInspirationMyPost();
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error Update", response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
    } finally {
      isLoading.value = false;
    }
  }
}
