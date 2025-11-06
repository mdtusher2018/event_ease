import 'dart:developer';
import 'dart:io';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';



class EditBusinessEventJobController extends GetxController {
 
  /// Loader
  RxBool isLoading = false.obs;
  /// Main Method: Create Business
  Future<void> editBusiness(dynamic body,{
    required String id,
    required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
    log("🚀 Creating Business...");

    isLoading.value = true;
    try {
      final Map<String, String> header = {
        "token": PrefsHelper.token,
        'Content-Type': "application/json",
      };

 

      final List<MultipartBody> multipartBody = [];

      if (coverLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverLogo)));
      }
      if (businessLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("logo", File(businessLogo)));
      }
      if (promotionLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("promotionImage", File(promotionLogo)));
      }
      for (var file in galleryLogo) {
        multipartBody.add(MultipartBody("gallery", file));
      }

      log("🔍 Sending Request with Body: $body");

      final response = await ApiService.to.multipartData(
        AppUrl.editBusiness(id),
        body,method: "PATCH",
        multipartBody: multipartBody,
        extraHeaders: header,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
    Get.back();
            Get.snackbar("Success".tr, response.message);
     
      } else {
          Get.snackbar("Error".tr,response.message);
     
      }
    } catch (e, s) {
      log("❌ Error: $e\n$s");
          Get.snackbar("Error".tr,e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  /// Main Method: Create Business
  Future<void> editEvent(dynamic body,{required String id,required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
    log("🚀 Creating Business...");

    isLoading.value = true;
    try {
      final Map<String, String> header = {
        "token": PrefsHelper.token,
        'Content-Type': "application/json",
      };

 

      final List<MultipartBody> multipartBody = [];

      if (coverLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverLogo)));
      }
      if (businessLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("logo", File(businessLogo)));
      }
      if (promotionLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("promotionImage", File(promotionLogo)));
      }
      for (var file in galleryLogo) {
        multipartBody.add(MultipartBody("gallery", file));
      }

      log("🔍 Sending Request with Body: $body");

      final response = await ApiService.to.multipartData(
        AppUrl.editEvent(id),
        body,method: "PATCH",
        multipartBody: multipartBody,
        extraHeaders: header,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
   Get.back();
            Get.snackbar("Success".tr, response.message);
      
      } else {
          Get.snackbar("Error".tr,response.message);
     
      }
    } catch (e, s) {
      log("❌ Error: $e\n$s");
          Get.snackbar("Error".tr,e.toString());
      ;
    } finally {
      isLoading.value = false;
    }
  }





  /// Main Method: Create Business
  Future<void> editJob(dynamic body,{required String id,required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
    log("🚀 Creating Business...");

    isLoading.value = true;
    try {
      final Map<String, String> header = {
        "token": PrefsHelper.token,
        'Content-Type': "application/json",
      };

 

      final List<MultipartBody> multipartBody = [];

      if (coverLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverLogo)));
      }
      if (businessLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("logo", File(businessLogo)));
      }
      if (promotionLogo.isNotEmpty) {
        multipartBody.add(MultipartBody("promotionImage", File(promotionLogo)));
      }
      for (var file in galleryLogo) {
        multipartBody.add(MultipartBody("gallery", file));
      }

      log("🔍 Sending Request with Body: $body");

      final response = await ApiService.to.multipartData(
        AppUrl.editJob(id),
        body,method: "PATCH",
        multipartBody: multipartBody,
        extraHeaders: header,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
   Get.back();
            Get.snackbar("Success".tr, response.message);
      
      } else {
          Get.snackbar("Error".tr,response.message);
     
      }
    } catch (e, s) {
      log("❌ Error: $e\n$s");
          Get.snackbar("Error".tr,e.toString());
      ;
    } finally {
      isLoading.value = false;
    }
  }







}
