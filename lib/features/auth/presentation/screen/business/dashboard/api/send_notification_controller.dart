import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/send_notification_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class GEtSendNotificationController extends GetxController {
  var notifications = <NotificationData>[].obs;
  var isLoading = false.obs;
  String type, id;
  // Replace with your API URL
  GEtSendNotificationController({required this.type, required this.id});
  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.getSendNotification(type, id),
      );
      log("Response: ${response.data}");
      if (response.success) {
        notifications.value = List<NotificationData>.from(
          response.data.map((x) => NotificationData.fromJson(x)),
        );
      } else {
        Get.snackbar('Error', 'Failed to load notifications');
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
