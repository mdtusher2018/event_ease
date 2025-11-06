import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/job_detail_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/api_service.dart';

class JobController extends GetxController  with GetTickerProviderStateMixin{
  RxBool isLoading = false.obs;
  RxBool isDataLoading = false.obs;
  UserRepository userRepository = UserRepository();
  RxList jobCategoryList = [].obs;
  RxList jobSubCategoryList = [].obs;
  RxList jobUnSubCategoryList = [].obs;
  Rx<JobDetailModel?> jobDetailModel = Rx<JobDetailModel?>(null);
  RxInt activeIndex = 0.obs;
  late TabController tabController;

  RxString jobId = "".obs;

  RxString cvImage = "".obs;

  void pickCv()async{
    cvImage.value = await OtherHelper.pickImage(ImageSource.gallery);
  }



  Future<bool> postComment({
    required String id,
    required String text,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "jobId": id,
        "text": text,
      };

      final ApiResponse response = await ApiService.to.postApi(
        AppUrl.postjobComment,
        body,
      );
      log(response.toString());
      if (response.success) {
        Get.snackbar("Success".tr, "Comment added successfully");
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



  Future<void>getJobCategory()async{
    isLoading.value = true;

    try{
      var response = await userRepository.getJobCategory();
      if(response.statusCode == 200 || response.statusCode == 201){
        jobCategoryList.value= response.data['data'];
        tabController = TabController(length: jobCategoryList.length, vsync: this);
        log(">>>>>>>>>>>>>> Category List : $jobCategoryList");
        log(">>>>>>>>>>>>>> ${response.message}");
        if (jobCategoryList.isNotEmpty) {
          String firstCategoryName = jobCategoryList[0]['_id'];
          getJobSubCategory(firstCategoryName);
          getJobUnSubCategory(firstCategoryName);
        }
      }else{
        log(">>>>>>>>>>>>>>Error : ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }

    }catch(e,s){
      log(">>>>>>>>>>>>>>>> e :$e");
      log(">>>>>>>>>>>>>>>> s :$s");
    }finally{
      isLoading.value= false;
    }

  }

  Future<void>getJobSubCategory(String id)async{
    isDataLoading.value = true;

    try{
      var response = await userRepository.getSubJob(id);
      if(response.statusCode == 200 || response.statusCode == 201){
        jobSubCategoryList.value= response.data['data'];

        log(">>>>>>>>>>>>>> Sub Category List : $jobSubCategoryList");
        log(">>>>>>>>>>>>>> ${response.message}");
      }else{
        log(">>>>>>>>>>>>>>Error : ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }

    }catch(e,s){
      log(">>>>>>>>>>>>>>>> e :$e");
      log(">>>>>>>>>>>>>>>> s :$s");
    }finally{
      isDataLoading.value= false;
    }

  }

  Future<void>getJobUnSubCategory(String id)async{
    isDataLoading.value = true;

    try{
      var response = await userRepository.getUnSubJob(id);
      if(response.statusCode == 200 || response.statusCode == 201){
        jobUnSubCategoryList.value= response.data['data'];
        // jobUnSubCategoryList.addAll(response.data['data']);

        log(">>>>>>>>>>>>>> List =======================: ${response.data['data']}");
        log(">>>>>>>>>>>>>>Un  Sub Category List : $jobSubCategoryList");
        log(">>>>>>>>>>>>>> ${response.message}");
      }else{
        log(">>>>>>>>>>>>>>Error : ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }

    }catch(e,s){
      log(">>>>>>>>>>>>>>>> e :$e");
      log(">>>>>>>>>>>>>>>> s :$s");
    }finally{
      isDataLoading.value= false;
    }

  }

  Future<void>getJobDetail(String id)async{
    isDataLoading.value = true;
    isLoading.value=true;

    try{
      var response = await userRepository.getJobDetail(id);
      if(response.statusCode == 200 || response.statusCode == 201){
        jobDetailModel.value = JobDetailModel.fromJson(response.data);
        log(jobDetailModel.value.toString());
        log(">>>>>>>>>>>>>>Job detail : $jobDetailModel");
        log(">>>>>>>>>>>>>>Job detail : ${jobDetailModel.value!.title}");
        log(">>>>>>>>>>>>>> ${response.message}");
        Get.toNamed(RoutesName.jobDetailScreen);
      }else{
        log(">>>>>>>>>>>>>>Error : ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }

    }catch(e,s){
      log(">>>>>>>>>>>>>>>> e :$e");
      log(">>>>>>>>>>>>>>>> s :$s");
    }finally{
      isDataLoading.value= false;
      isLoading.value=false;
    }

  }

  Future<void> applyJob(String id) async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {
        // "jobId": id
      };

      var multipartBody=<MultipartBody>[];

      if (cvImage.value.isNotEmpty) {
        multipartBody.add(
          MultipartBody("viewCvImage", File(cvImage.value)),
        );
      }

      final response = await userRepository.applyJob(id, body, multipartBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        cvImage.value = "";
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

  Future<String?> getLocationName(double lon,double lat) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String locationName = "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
        print("Location: $locationName");
        return locationName;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getJobCategory();
    
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

}