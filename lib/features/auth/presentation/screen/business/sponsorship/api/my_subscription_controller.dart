import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/my_subscription_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySubscriptionController extends GetxController {
  /// Observable list of subscriptions
  RxList<MySponsorSubscriptionData> subscriptions =
      <MySponsorSubscriptionData>[].obs;

  /// State flags
  RxBool isLoading = false.obs;
  RxBool buttonLoading = false.obs;
  RxString? errorMessage = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchMySubscriptions();
  }

  /// Fetch subscriptions
  Future<void> fetchMySubscriptions() async {
    isLoading.value = true;
    errorMessage?.value = '';

    try {
      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.getMySubscriptions, // Ensure this endpoint is set correctly
      );

      if (response.success && response.data != null) {
        final List<MySponsorSubscriptionData> data =
            (response.data as List)
                .map((json) => MySponsorSubscriptionData.fromJson(json))
                .toList();

        subscriptions.assignAll(data);
        log("Fetched ${data.length} subscriptions successfully");
      } else {
        errorMessage?.value = response.message;
        log("Error fetching subscriptions: ${response.message}");
      }
    } catch (e) {
      errorMessage?.value = "Failed to fetch subscriptions: $e";
      log("Subscription fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Activate a subscription
  Future<void> activateSubscription(String id) async {
    
    buttonLoading.value = true;
    try {
      
      final ApiResponse response = await ApiService.to.patchApi(
        AppUrl.activeSubscription(id),
        {},
      );

      if (response.success) {
        Get.snackbar(
          "Success".tr,
          "Subscription activated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchMySubscriptions(); // refresh list
      } else {
        Get.snackbar(
          "Error",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }finally{
      buttonLoading.value = false;
    }
  }

  /// Stop a subscription
  Future<void> stopSubscription(String id) async {
    buttonLoading.value = true;
    try {
      final ApiResponse response = await ApiService.to.patchApi(
        AppUrl.stopSubscription(id),
        {},
      );

      if (response.success) {
        Get.snackbar(
          "Success".tr,
          "Subscription stopped successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchMySubscriptions(); // refresh list
      } else {
        Get.snackbar(
          "Error",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }finally{
      buttonLoading.value = false;
    }
  }
}
