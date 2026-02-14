import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/helper/prefs_helper.dart';
// import 'package:event_ease/core/routers/routes.dart';
import 'package:event_ease/core/routers/routes_name.dart';
// import 'package:event_ease/features/auth/presentation/controller/home_controller.dart';
// import 'package:event_ease/features/auth/presentation/models/my_model/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/api_service.dart';
import '../../../data/repository/auth_repository.dart';
import '../../utils/app_url.dart';

class EditController extends GetxController {
  RxBool isRemember = false.obs;
  RxBool isAgree = false.obs;
  RxBool isLoading = false.obs;
  final RxBool isCode = false.obs;
  RxString profileImage = "".obs;
  AuthRepository authRepository = AuthRepository();
  String initialCountryCode = 'BD';
  String initialPhoneNumber = '';
  var genderItem = ["male", "female", "others"];
  final RxString selectedGender = "".obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  void imagePick() async {
    profileImage.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  void toggleRememberMe() {
    isAgree.value = !isAgree.value;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Edit Profile >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> editProfile() async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {
        "data": jsonEncode({
          "name": nameController.text,
          'email': emailController.text,
          "phone": phoneController.text,
          "sureName": firstNameController.text,
          "lastName": lastNameController.text,
          "dateOfBirth": selectedDate.value.toString(),
          "gender": selectedGender.value,
          "termsAndConditions": isAgree.value,
          "customId": referralController.text,
        }),
      };

      final Map<String, String> header = {
        "token": PrefsHelper.token,
        'Content-Type': "application/json",
      };

      final multipartBody = <MultipartBody>[];

      if (profileImage.value.isNotEmpty) {
        multipartBody.add(MultipartBody("image", File(profileImage.value)));
      }

      log(">>>>>>>>>>>>>>>>profileImage========:  ${profileImage.value}");

      final response = await ApiService.to.multipartData(
        AppUrl.editProfile,
        body,
        multipartBody: multipartBody,
        extraHeaders: header,
        method: 'PATCH',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        log("data=====$data}");
        log(">>>>>>>>>>>>>>> Success 200");
        PrefsHelper.myImage = data["profileImage"];
        PrefsHelper.myName = data["name"];
        // Get.back();
        Get.offAllNamed(RoutesName.nav);
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Profile >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> getProfile() async {
    isLoading.value = true;
    try {
      final response = await authRepository.getProfile();
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success Additional Service");
        final data = response.data;

        profileImage.value = data['profileImage'];
        nameController.text = data['name'];
        firstNameController.text = data['sureName'];
        lastNameController.text = data['lastName'];
        emailController.text = data['email'];
        selectedGender.value = data['gender'];
        selectedDate.value = DateTime.tryParse(data['dateOfBirth'] ?? "");

        final fullPhone = data['phone'];
        if (fullPhone != null && fullPhone.isNotEmpty) {
          if (fullPhone.startsWith('+880')) {
            initialCountryCode = 'BD';
            initialPhoneNumber = fullPhone.replaceFirst('+880', '');
          } else {
            initialPhoneNumber = fullPhone;
          }

          phoneController.text = initialPhoneNumber;
        }
      } else {
        log(">>>>>>>>>>>>>>> Error Additional Service");
      }
    } catch (e, s) {
      log("Error: $e");
      log("StackTrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
  }
}
