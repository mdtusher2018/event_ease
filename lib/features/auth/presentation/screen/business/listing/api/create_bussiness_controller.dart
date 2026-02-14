import 'dart:developer';
import 'dart:io';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/data/repository/bussiness%20repositories/home_page_repository.dart';
import 'package:event_ease/features/auth/presentation/models/ProviderCategoryModel.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/mybusiness_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';



class CreateController extends GetxController {
 
  /// Loader
  RxBool isLoading = false.obs;
  final BusinessHomePageRepository _businessRepository =
      BusinessHomePageRepository();

    var eventCategories = <ProviderCategory>[].obs;
    var businessCategories = <ProviderCategory>[].obs;
    var jobCategories = <ProviderCategory>[].obs;

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEventCategories();
    fetchBusinessCategories();
    fetchJobCategories();
    fetchMyBusinesses();
  }

  Future<void> fetchEventCategories() async {
    isLoading.value = true;

    try {
      final response = await _businessRepository.getEventCategories();
      final catagoryResponse = ProviderCategoryDataModel.fromJson(
        response.data,
      );
      eventCategories.assignAll(catagoryResponse.categories);
    
    } catch (e, s) {
      log("Error in fetch provider catagory: $e\n$s");
      Get.snackbar("Error".tr,"Error in fetch Catagories: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchBusinessCategories() async {
    isLoading.value = true;
    try {
      final response = await _businessRepository.getProviderCategories();
      final catagoryResponse = ProviderCategoryDataModel.fromJson(
        response.data,
      );
      businessCategories.assignAll(catagoryResponse.categories);
    
    } catch (e, s) {
      log("Error in fetch provider catagory: $e\n$s");
      Get.snackbar("Error".tr,"Error in fetch Catagories: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  

Future<void> fetchJobCategories() async {
    isLoading.value = true;

    try {
      final response = await _businessRepository.getJobCategories();
      final catagoryResponse = ProviderCategoryDataModel.fromJson(
        response.data,
      );
      jobCategories.assignAll(catagoryResponse.categories);
    
    } catch (e, s) {
      log("Error in fetch Job catagory: $e\n$s");
      Get.snackbar("Error".tr,"Error in fetch Catagories: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }










  /// Main Method: Create Business
  Future<void> createCompleteBusiness(dynamic body,{required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
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
        AppUrl.businessCreate,
        body,
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
  Future<void> createEvent(dynamic body,{required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
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
        AppUrl.createEvent,
        body,
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
  Future<void> createJob(dynamic body,{required String coverLogo,required String businessLogo,required String promotionLogo,required List<File> galleryLogo}) async {
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
        AppUrl.createJob,
        body,
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




  /// My Business List
  var myBusinesses = <BusinessItem>[].obs; // <-- Use the model we created earlier

  Future<void> fetchMyBusinesses() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.myBusiness);

      if (response.success) {
        final data = (response.data as List<dynamic>? ?? [])
            .map((e) => BusinessItem.fromJson(e))
            .toList();

        myBusinesses.assignAll(data);
        log("✅ My businesses fetched: ${myBusinesses.length}");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("❌ Error fetching my businesses: $e\n$s");
      Get.snackbar("Error".tr,e.toString());
    } finally {
      isLoading.value = false;
    }
  }



}





