import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/data/repository/business_repository.dart';
import 'package:event_ease/features/auth/data/repository/bussiness%20repositories/home_page_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/bussiness%20controller/extra_event_model.dart';
import 'package:event_ease/features/auth/presentation/models/event_details_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../../core/routers/routes_name.dart';

class EventDetailsController extends GetxController {
  final BusinessHomePageRepository _eventRepository =
      BusinessHomePageRepository();

  BusinessRepository repository = BusinessRepository();

  RxBool isLoading = false.obs;
  RxBool isLoadingMsg = false.obs;
  RxBool isLoadingInterest = false.obs;

  Rx<EventDetailsModel?> eventDetail = Rx<EventDetailsModel?>(null);
  Rx<ExtraEventData?> extraEventData = Rx<ExtraEventData?>(null);

  Future<bool> postComment({required String id, required String text}) async {
    try {
      final Map<String, dynamic> body = {"eventId": id, "text": text};

      final ApiResponse response = await ApiService.to.postApi(
        AppUrl.postEventComment,
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

  Future<void> fetchEventDetailsById({String? id}) async {
    id ??= Get.arguments;
    log(">>>>>>>>>> id: $id");
    try {
      isLoading.value = true;

      // Fetch both main event details and extra event data concurrently
      final List<dynamic> responses = await Future.wait([
        _eventRepository.getEventDetailsById(id ?? Get.arguments),
        _eventRepository.getExtraEventData(id ?? Get.arguments),
      ]);

      final mainResponse = responses[0];
      final extraResponse = responses[1];

      // Process main event details
      if (mainResponse.success && mainResponse.data != null) {
        eventDetail.value = EventDetailsModel.fromJson(mainResponse.data);
        log("✅ Fetched event details");
      } else {
        Get.snackbar("Error".tr,mainResponse.message);
        return;
      }

      // Process extra event data
      if (extraResponse.success && extraResponse.data != null) {
        extraEventData.value = ExtraEventData.fromJson(extraResponse.data);
        log("✅ Fetched extra event data");
      } else {
        Get.snackbar("Error".tr,extraResponse.message);
      }
    } catch (e, s) {
      log("Error in fetch Event Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createChat() async {
    try {
      isLoadingMsg.value = true;
      Map<String, dynamic> body = {
        "users": [eventDetail.value?.author ?? ""],
        "chatName": eventDetail.value?.name ?? "",
        "chatImage": eventDetail.value?.logo ?? "",
        "contextType": "event", // event || job
        "contextId": eventDetail.value?.id ?? "",
      };

      log("Chat Name==============>>>>>>>>>>>>>${eventDetail.value!.name}");
      final response = await repository.createChat(body);

      if (response.success && response.data != null) {
        final userRole = response.data?['users']?[0]?['role'] ?? "";
        final chatName = response.data?['chatName'] ?? "";
        final contextOwner = response.data?['contextOwner'];
        final userName = response.data?['userName'] ?? "";
        log("Fetched event details");
        Get.toNamed(
          RoutesName.chatting,
          arguments: {
            "chatId": response.data?['_id'] ?? "",
            'isAdmin':userRole == "admin",
            "name":
                (userRole == "admin")
                    ? chatName
                    : (PrefsHelper.userId == contextOwner)
                    ? userName
                    : chatName,
            "chatname":
                userRole == "admin"
                    ? ""
                    : (PrefsHelper.userId != contextOwner)
                    ? ""
                    : chatName,

            "image":
                (PrefsHelper.userId == response.data?['contextOwner'])
                    ? (response.data?['users']?[0]?['profileImage'] ?? "")
                    : (response.data?['chatImage'] ?? ""),
            "closed":
                (response.data?['users']?[0]?['status'] ?? "") == "closed",
          },
        );
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch event Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoadingMsg.value = false;
    }
  }

  Future<void> createInterest() async {
    try {
      isLoadingInterest.value = true;
      Map<String, dynamic> body = {};
      final response = await repository.patchInterest(
        body,
        id: eventDetail.value!.id,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Fetched event interest ");
        Get.snackbar("Successful".tr, response.message);
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch event Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoadingInterest.value = false;
    }
  }

  /// Combined fetch for both main and extra event details
  Future<void> fetchEventDetailsWithExtras() async {
    final String? id = Get.arguments;
    if (id == null || id.isEmpty) {
      Get.snackbar("Error".tr,"Event ID is missing.");
      return;
    }

    try {
      isLoading.value = true;

      /// Fetch main event
      final response = await _eventRepository.getEventDetailsById(id);
      if (response.success && response.data != null) {
        eventDetail.value = EventDetailsModel.fromJson(response.data);
        log("✅ Fetched event details");
      } else {
        Get.snackbar("Error".tr,response.message);
        return;
      }

      /// Fetch extra event data
      final extraResponse = await _eventRepository.getExtraEventData(id);
      if (extraResponse.success && extraResponse.data != null) {
        extraEventData.value = ExtraEventData.fromJson(extraResponse.data);
        log("✅ Fetched extra event data");
      } else {
        Get.snackbar("Error".tr,extraResponse.message);
      }
    } catch (e, s) {
      log("❌ Error in fetchEventDetailsWithExtras: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
