import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/business_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/inspiration/insparation_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../../../data/repository/user_repository.dart';
import '../../models/my_model/inspiration_detail_model.dart';

class InspirationController extends GetxController {
  RxBool isLoading = false.obs;
  UserRepository userRepository = UserRepository();
  BusinessRepository businessRepository = BusinessRepository();

  RxList inspirationCategoryList = [].obs;
  RxList inspirationCategoryGroupList = [].obs;
  RxList specificCategoryList = [].obs;
  RxList groupCategoryViewAllList = [].obs;
  RxList inspirationMyPost = [].obs;
  Rx<InspirationDetailModel> inspirationDetailModel =
      InspirationDetailModel().obs;
  RxString categoryName = "".obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Regular
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Inspiration Category  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getInspirationCategory() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getInspirationCategory();
      if (response.statusCode == 200) {
        log(
          ">>>>>>>>>>>>>>>>>>>>>>>>>  Response : ==============${response.data['data']} ",
        );
        inspirationCategoryList.value = response.data['data'];
        log("Fetched Inspiration Category");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get group Inspiration Category  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getInspirationCategoryGroup() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getInspirationCategoryGroup();
      if (response.statusCode == 200) {
        inspirationCategoryGroupList.value = response.data['data'];
        log("Fetched Inspiration Category");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get specific Inspiration Category  list >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> allSpecificCategory(
    String categoryId,
    String categoryNam,
  ) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getAllSpecificCategory(categoryId);
      if (response.statusCode == 200) {
        specificCategoryList.value = response.data['data'];
        categoryName.value = categoryNam;
        log("Fetched Inspiration Category");
        Get.toNamed(RoutesName.idea, arguments: false);
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get group Inspiration Category  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> groupCategoryViewAll(
    String categoryId,
    String categoryNam,
  ) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getAllSpecificCategory(categoryId);
      if (response.statusCode == 200) {
        groupCategoryViewAllList.addAll(response.data['data']);
        categoryName.value = categoryNam;
        log("Fetched Inspiration Category========$groupCategoryViewAllList");
        Get.toNamed(RoutesName.idea, arguments: true);
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get group Inspiration Category  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getCategoryDetails(
    String inspirationId, {
    bool isMyPost = false,
  }) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getCategoryDetail(inspirationId);
      if (response.statusCode == 200) {
        inspirationDetailModel.value = InspirationDetailModel.fromJson(
          response.data,
        );
        log("Fetched Inspiration Category");
        Get.toNamed(
          RoutesName.post,
          arguments: {
            'id': inspirationId,
            'type': "Inspiration",
            "isMyPost": isMyPost,
          },
        )?.then((value) {
          getInspirationMyPost();
        });
      } else {
        Get.snackbar("Error Category", response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get inspiration my post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getInspirationMyPost() async {
    isLoading.value = true;
    try {
      final response = await businessRepository.getInspirationMyPOst();
      if (response.statusCode == 200 || response.statusCode == 201) {
        inspirationMyPost.value = response.data['data'];
        log("Fetched Inspiration my post");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration my post: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


  RxList<InspirationItem> latestList = <InspirationItem>[].obs;

  /// Fetch latest inspirations
  Future<void> fetchLatestInspirations() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.leatestUrl);
      if (response.statusCode == 200) {
        final latestResponse = LatestInspirationData.fromJson(response.data);
        latestList.value = latestResponse.data;
        log("Latest Inspirations Fetched: ${latestList.length}");
      } else {
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error fetching latest inspirations: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getInspirationCategory();
    getInspirationCategoryGroup();
    getInspirationMyPost();
     fetchLatestInspirations();
  }
}
