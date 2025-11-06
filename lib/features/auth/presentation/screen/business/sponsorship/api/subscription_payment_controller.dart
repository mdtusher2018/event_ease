// import 'dart:developer';
// import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/payment_webview.dart';
// import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
// import 'package:event_ease/services/api_service.dart';
// import 'package:get/get.dart';

// class SubscriptionPaymentController extends GetxController {
//   var isLoading = false.obs;

//   Future<bool> subscribeToPlan({
//     required String subscriptionId,
//     required String subscriptionFor,
//     required String subscriptionForType, // "Business", "Event", or "Job"
//     required int subscriptionOptionIndex,
//     required double amount,
//     required int duration,
//   }) async {
//     final String endpoint = AppUrl.paymentUrl; // Define this in AppUrl

//     final Map<String, dynamic> body = {
//       "subscriptionId": subscriptionId,
//       "subscriptionFor": subscriptionFor,
//       "subscriptionForType": subscriptionForType,
//       "subscriptionOptionIndex": subscriptionOptionIndex,
//       "amount": amount,
//       "duration": duration,
//     };

//     isLoading.value = true;

//     try {
//       final ApiResponse response = await ApiService.to.postApi(endpoint, body);

//       isLoading.value = false;

//      if (response.success) {
//   final String redirectUrl = response.data["redirectUrl"];
//   log("Redirecting to: $redirectUrl");

//   // Open in WebView instead of browser
//   Get.to(() => PaymentWebViewScreen(url: redirectUrl));

//   return true;
// } else {
//         Get.snackbar("Error".tr,response.message);
//         log("Subscription failed: ${response.message}");
//         return false;
//       }
//     } catch (e) {
//       isLoading.value = false;
//       log("Exception in subscribeToPlan: $e");
//       Get.snackbar("Error".tr,"Something went wrong. Please try again.");
//       return false;
//     }
//   }

//   Future<bool> subscribeToPlanWithCridit({
//     required String subscriptionId,
//     required String subscriptionFor,
//     required String subscriptionForType, // "Business", "Event", or "Job"
//     required int subscriptionOptionIndex,
//     required double amount,
//     required int duration,
//   }) async {
//     final String endpoint = AppUrl.paymentWithCriditUrl; // Define this in AppUrl

//     final Map<String, dynamic> body = {
//       "subscriptionId": subscriptionId,
//       "subscriptionFor": subscriptionFor,
//       "subscriptionForType": subscriptionForType,
//       "subscriptionOptionIndex": subscriptionOptionIndex,
//       "amount": amount,
//       "duration": duration,
//     };

//     isLoading.value = true;

//     try {
//       final ApiResponse response = await ApiService.to.postApi(endpoint, body);

//       isLoading.value = false;

//      if (response.success) {

//         Get.snackbar("Sucessfull", "payment sucessfull");
//   return true;
// } else {
//         Get.snackbar("Error".tr,response.message);
//         log("Subscription failed: ${response.message}");
//         return false;
//       }
//     } catch (e) {
//       isLoading.value = false;
//       log("Exception in subscribeToPlan: $e");
//       Get.snackbar("Error".tr,"Something went wrong. Please try again.");
//       return false;
//     }
//   }
// }

import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/payment_webview.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPaymentController extends GetxController {
  var isLoading = false.obs;

  void showSnackBar(
    BuildContext context, {
    required String message,
    bool success = true,
  }) {
    // Close any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<bool> subscribeToPlan({
    required BuildContext context,
    required String subscriptionId,
    required String subscriptionFor,
    required String subscriptionForType,
    required int subscriptionOptionIndex,
    required double amount,
    required int duration,
    String? promocode,
    num? userCredits
  }) async {
    final String endpoint = AppUrl.paymentUrl;

    final Map<String, dynamic> body = {
      "subscriptionId": subscriptionId,
      "subscriptionFor": subscriptionFor,
      "subscriptionForType": subscriptionForType,
      "subscriptionOptionIndex": subscriptionOptionIndex,
      "amount": amount,
      "duration": duration,
      if(promocode!=null)"couponCode":promocode,
      if(userCredits!=null) "userTotalCredits":userCredits,
      if(userCredits!=null)"type" :"credit"
    };

    isLoading.value = true;

    try {
      final ApiResponse response = await ApiService.to.postApi(endpoint, body);
      isLoading.value = false;

      if (response.success) {
        final String redirectUrl = response.data["redirectUrl"];
        log("Redirecting to: $redirectUrl");

        // Open in WebView
        Get.to(() => PaymentWebViewScreen(url: redirectUrl));

        showSnackBar(
          context,
          message: "Redirecting to payment...",
          success: true,
        );

        return true;
      } else {
        showSnackBar(context, message: response.message, success: false);
        log("Subscription failed: ${response.message}");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      showSnackBar(
        context,
        message: "Something went wrong. Please try again.",
        success: false,
      );
      log("Exception in subscribeToPlan: $e");
      return false;
    }
  }

  Future<bool> subscribeToPlanWithCredit({
    required BuildContext context,
    required String subscriptionId,
    required String subscriptionFor,
    required String subscriptionForType,
    required int subscriptionOptionIndex,
    required double amount,
    required int duration,
  }) async {
    final String endpoint = AppUrl.paymentWithCriditUrl;

    final Map<String, dynamic> body = {
      "subscriptionId": subscriptionId,
      "subscriptionFor": subscriptionFor,
      "subscriptionForType": subscriptionForType,
      "subscriptionOptionIndex": subscriptionOptionIndex,
      "amount": amount,
      "duration": duration,
    };

    isLoading.value = true;

    try {
      final ApiResponse response = await ApiService.to.postApi(endpoint, body);
      isLoading.value = false;

      if (response.success) {
        showSnackBar(context, message: "Payment successful", success: true);
        return true;
      } else {
        showSnackBar(context, message: response.message, success: false);
        log("Subscription failed: ${response.message}");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      showSnackBar(
        context,
        message: "Something went wrong. Please try again.",
        success: false,
      );
      log("Exception in subscribeToPlanWithCredit: $e");
      return false;
    }
  }
}
