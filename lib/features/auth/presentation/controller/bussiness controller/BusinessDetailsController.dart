import 'dart:developer';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/data/repository/business_repository.dart';
import 'package:event_ease/features/auth/data/repository/bussiness%20repositories/home_page_repository.dart';
import 'package:event_ease/features/auth/presentation/models/business_details_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../../core/routers/routes_name.dart';
import '../../models/my_model/extra_business_model.dart';

class BusinessDetailsController extends GetxController {
  static BusinessDetailsController get instance =>
      Get.put(BusinessDetailsController());
  final BusinessHomePageRepository _businessRepository =
      BusinessHomePageRepository();
  BusinessRepository businessRepository = BusinessRepository();

  RxBool isLoading = false.obs;

  Rx<BusinessDetailModel?> businessDetail = Rx<BusinessDetailModel?>(null);
  Rx<ExtraBusinessModel> extraBusinessDetail = ExtraBusinessModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchBusinessesDetailsById();
    fetchExtraBusinessesDetailsById();
  }

  Future<void> fetchBusinessesDetailsById({String? id}) async {
    id ??= Get.arguments;
    try {
      isLoading.value = true;
      final response = await _businessRepository.getBusinessDetailsById(
        id ?? Get.arguments,
      );

      if (response.success && response.data != null) {
        businessDetail.value = BusinessDetailModel.fromJson(response.data);
        log("Fetched businesses details");
        log(businessDetail.value!.location.coordinates.first.toString());
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch Businesses Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExtraBusinessesDetailsById({String? id}) async {
    id ??= Get.arguments;

    log("token=======${PrefsHelper.token}---------id=====$id");
    try {
      isLoading.value = true;
      final response = await _businessRepository.getExtraBusinessDetailsById(
        id ?? Get.arguments,
      );

      if (response.success && response.data != null) {
        extraBusinessDetail.value = ExtraBusinessModel.fromJson(response.data);
        log(
          "Fetched extra details======${extraBusinessDetail.value.inspirationBlogs.length}",
        );
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetch extraBusinesses Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createChat() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "users": [businessDetail.value?.author ?? ""],
        "chatName": businessDetail.value?.name ?? "testing",
        "chatImage": businessDetail.value?.logo ?? "",
        "contextType": "business", // event || job
        "contextId": businessDetail.value?.id ?? "",
      };
      final response = await businessRepository.createChat(body);

    
      if (response.success && response.data != null) {
log(">>>> Response : $response...................");
        final userRole = response.data?['users']?[0]?['role'] ?? "";
        final chatName = response.data?['chatName'] ?? "";
        final contextOwner = response.data?['contextOwner']??"";
        final userName = response.data?['userName'] ?? "";
        log("Fetched businesses details");
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
      log("Error in fetch Businesses Details: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> postComment({required String id, required String text}) async {
    try {
      final Map<String, dynamic> body = {"businessId": id, "text": text};

      final ApiResponse response = await ApiService.to.postApi(
        AppUrl.postBusinessComment,
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
}
