import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/intrested_user.dart';
import 'package:get/get.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

class InterestedUsersController extends GetxController {
  RxList<InterestUser> interestedUsers = <InterestUser>[].obs;
  RxBool isLoading = false.obs;
  String? errorMessage;
  String id;
  InterestedUsersController({required this.id});

  @override
  void onInit() {
    super.onInit();
    fetchInterestedUsers();
  }

  Future<void> fetchInterestedUsers() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final ApiResponse response = await ApiService.to.getApi(AppUrl.getInterestedUsers(id));
 log(response.data+".........................");
      if (response.success && response.data != null) {
        final dataJson = response.data;
       
        final InterestedUsersData data = InterestedUsersData.fromJson(dataJson);
        interestedUsers.assignAll(data.interestUsers);
        log("Fetched ${interestedUsers.length} interested users");
      } else {
        errorMessage = response.message ;
        log("API Error: $errorMessage");
        Get.snackbar("Error".tr,"No Data Found");
      }
    } catch (e) {
      errorMessage = 'Something went wrong';
      log("Exception while fetching interested users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
