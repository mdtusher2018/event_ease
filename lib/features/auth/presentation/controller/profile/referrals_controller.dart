import 'dart:developer';
import 'dart:io';

import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReferralsController extends GetxController {
  final referralController = TextEditingController();
  final amountController = TextEditingController();

  UserRepository userRepository = UserRepository();

  RxBool isLoading = false.obs;

  final selectedSupplier = ''.obs;
  final selectedSupplierId = ''.obs;

  RxString invitedFriends = "".obs;
  RxString creditEarned = "".obs;
  RxString referralCode = "".obs;
    var suppliers = <BusinessNameModel>[].obs;

  @override
  void onClose() {
    referralController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void resetAmountInput() {
    amountController.clear();
    selectedSupplier.value="";
    selectedImage.value=null;
    getReferral();
  }

  @override
  void onInit() {
    super.onInit();
    // Call both APIs when controller is initialized
    getReferral();
    fetchBusinesses();
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> all folder >>>>>>>>>>>>>>>>>>>>>>>





  Rx<File?> selectedImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

RxBool isSubmitting=false.obs;
Future<void> submitCredit() async {
  isSubmitting.value = true;
  try {
    final enteredAmount = double.tryParse(amountController.text.trim()) ?? -1;

    // ✅ Validation checks
    if (enteredAmount <= 0) {
      Get.snackbar("Error".tr,"Please enter a valid amount greater than 0.");
      isSubmitting.value = false;
      return;
    }

    if (enteredAmount > 15) {
      Get.snackbar("Error".tr,"You cannot use more than 15 credits.");
      isSubmitting.value = false;
      return;
    }

    final response = await ApiService.to.multipartData(
      AppUrl.useCredit,
      {
        "type": "discount",
        "usedCredits": enteredAmount, // ✅ Double value
        "businessId": selectedSupplierId.value,
      },
      multipartBody: [
        MultipartBody("image", selectedImage.value!),
      ],
    );

    if (response.success) {
      Get.back();
      Get.snackbar("Success".tr, response.message);
    } else {
      log("Error : === ${response.message}");
      Get.snackbar("Error".tr,response.message);
    }
  } catch (e) {
    Get.snackbar("Error".tr,e.toString());
  } finally {
    isSubmitting.value = false;
  }
}





  Future<void> getReferral() async {
    isLoading.value = true;
    try {
      var response = await userRepository.getReferral();
      if (response.statusCode == 200 || response.statusCode == 201) {
        invitedFriends.value = response.data["friendsInvited"].toString();
        creditEarned.value = response.data["creditsEarned"].toString();
        referralCode.value = response.data["customId"];

        log("Response controller invitedFriends : === ${invitedFriends.value}");
        log("Response controller creditEarned : === ${creditEarned.value}");
        log("Response controller referralCode : === ${referralCode.value}");
        log("Success : === ${response.message}");
      } else {
        log("Error : === ${response.message}");
        // Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>>>>>>> Error e : === $e");
      log(">>>>>>>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }
void fetchBusinesses() async {
    try {
      isLoading.value = true;
      final response = await ApiService.to.getApi(
        AppUrl.fetchAllBusinessName,
      );

      if (response.success && response.data != null) {
        final List<dynamic> list = response.data;
        suppliers.value =
            list.map((json) => BusinessNameModel.fromJson(json)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }


}
