import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/notification_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../../core/routers/routes_name.dart';

class NotificationController extends GetxController{

  RxBool isLoading = false.obs;
  UserRepository userRepository = UserRepository();
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;


RxBool homePageNotification=false.obs;

@override
void onInit() {
  super.onInit();
  getUnreadNotificationCount();
}



 RxInt unreadMessages = 0.obs;










  /// Get unread notification count
  Future<void> getUnreadNotificationCount() async {
    isLoading.value = true;
    try {
      var response = await ApiService.to.getApi(AppUrl.getUnreadNotification);
      if (response.success) {
        unreadMessages.value = response.data ?? 0; // data = 28
        if(unreadMessages.value>0){
          homePageNotification.value=true;
        }
        log("Unread Notifications: ${unreadMessages.value}");
      } else {
        log("Error: ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Exception: $e");
      log("Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }





  Future<void>getNotification()async{
    isLoading.value = true;
    try{
      var response = await userRepository.getNotification();
      if(response.statusCode == 200 || response.statusCode == 201){
        final List<dynamic> data = response.data?? [];

        notificationList.value = data.map((e) => NotificationModel.fromJson(e)).toList();
        log(">>>>>>>>>>>>>>Job detail : $notificationList");
        log(">>>>>>>>>>>>>>Job detail : ${notificationList.length}");
        log(">>>>>>>>>>>>>> ${response.message}");
        Get.toNamed(RoutesName.notification);
        homePageNotification.value=false;
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



}