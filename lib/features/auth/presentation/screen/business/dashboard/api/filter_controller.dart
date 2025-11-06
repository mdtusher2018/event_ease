import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  RxBool isBuissnessLoad = false.obs;
  getBuissnessListName() async {
    isBuissnessLoad(true);

    try {
      var response = await ApiService.to.getApi(AppUrl.eventCatagory);
      // var data = response.data;
      if (response.statusCode == 200) {
      } else {
        Get.snackbar("Error".tr,"No Data Found");
      }
    } catch (e, s) {
      log("Catch Error: $e  \n Catch line======$s");
    } finally {
      isBuissnessLoad(false);
    }
  }
}
