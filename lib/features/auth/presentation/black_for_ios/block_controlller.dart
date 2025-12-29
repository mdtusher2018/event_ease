import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../screen/common/nav_screen.dart';

Future<bool> blockAnything({required String type, required String id}) async {
  final String endpoint = "${AppUrl.baseUrl}/$type/block/$id";

  try {
    final ApiResponse response = await ApiService.to.patchApi(endpoint, {});

    if (response.success) {
      Get.offAll(NavScreen());
      Get.snackbar(
        "Success".tr,
        "Blocked successfully, You will not see this in Future".tr,
      );
      return true;
    } else {
      Get.snackbar("Error".tr, response.message);
    }
  } catch (e) {
    Get.snackbar("Error".tr, "Failed to block. Please try again.".tr);
  }
  return false;
}
