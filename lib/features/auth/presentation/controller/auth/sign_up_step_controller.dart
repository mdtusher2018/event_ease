import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/routers/routes_name.dart';
import '../../../../../services/api_service.dart';
import '../../../data/repository/business_repository.dart';
import 'package:get_storage/get_storage.dart';


class SignUpStepController extends GetxController {
  BusinessRepository repository = BusinessRepository();

  final PageController pageController = PageController();
  final currentPage = 0.obs;
  RxBool isLoading = false.obs;

  final businessNameController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final detailedDescriptionController = TextEditingController();

  /// Image & Media
  RxString businessLogo = ''.obs;
  RxString coverLogo = ''.obs;
  final RxList<File> galleryLogo = <File>[].obs;
  RxString promotionLogo = ''.obs;

  /// Contact Information
  final emailController2 = TextEditingController();
  final phoneNumberController = TextEditingController();
  final websiteController = TextEditingController();

  /// Social Network
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final tilTokController = TextEditingController();

  /// Business Hour
  RxList selectedDays = [].obs;
  RxList selectedDay = [].obs;
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;

  /// Address & Map
  final addressSearchController = TextEditingController();
  String lat = "23.8103";
  String long = "90.4125";

  /// Provider Type
  RxList providerList = [].obs;
  RxString selectedProviderType = "".obs;
  final findProviderController = TextEditingController();

  /// Supported Service Type
  final findSupportServiceController = TextEditingController();
  RxList supportedServiceList = [].obs;
  RxList selectedSupportedServices = [].obs;
  RxList selectedSupportedStates = [].obs;
  RxBool showSupportedServiceList = false.obs;

  /// Additional Service Type
  final findAdditionalServiceController = TextEditingController();
  RxBool showAdditionalServiceList = false.obs;
  RxList additionalServiceList = [].obs;
  RxList selectedAdditionalStates = [].obs;
  RxList selectedAdditionalServices = [].obs;

  /// Price Range
  RxString selectedPriceRange = ''.obs;

  /// Guest Capacity
  final maxCountController = TextEditingController();

  /// FAQ
  List<TextEditingController> questionControllers = [TextEditingController()];
  List<TextEditingController> answerControllers = [TextEditingController()];





  final storage = GetStorage(); // local storage for draft

  // Save current FAQ as draft
  // void saveDraft(List<Map<String, String>> faqList) {
  //   List<Map<String, String>> draft = faqList
  //       .map((faq) => {
  //             'question': faq['question'] ?? '',
  //             'answer': faq['answer'] ?? '',
  //           })
  //       .toList();
  //   storage.write('faqDraft', draft);
  //   Get.snackbar(
  //     "Saved",
  //     "Draft Saved!",
  //     backgroundColor: Colors.black,
  //     colorText: Colors.white,
  //   );
  // }

  // Load draft into controllers
  List<Map<String, String>> loadDraft() {
    List<Map<String, String>> draft =
        (storage.read('faqDraft') as List<dynamic>?)?.cast<Map<String, String>>() ?? [];
    
    // Initialize controllers with draft
    questionControllers.clear();
    answerControllers.clear();
    for (var faq in draft) {
      questionControllers.add(TextEditingController(text: faq['question']));
      answerControllers.add(TextEditingController(text: faq['answer']));
    }

    return draft;
  }









  void handlePriceRangeChange(String value) {
    selectedPriceRange.value = value;
    log("Selected Price Range: $value");
  }

  void goToNextPage() {
    if (currentPage.value < 8) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  void goToPreviousPage() {
  if (currentPage > 0) {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
 
  }
}


  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void submitForm() {
    Get.defaultDialog(
      title: 'Form Submitted',
      middleText: 'Your business information has been submitted.',
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    );
  }

  /// Get Provider Type
  Future<void> getProviderType() async {
    isLoading.value = true;
    try {
      final response = await repository.getProviderType();
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        providerList.clear();
        for (int i = 0; i < response.data['data'].length; i++) {
          providerList.add({
            "_id": response.data['data'][i]["_id"],
            "name": response.data['data'][i]["name"],
          });
          log(">>>>>>>>>>>>>>>>> Provider List : $providerList");
        }
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }
  RxBool findProviverLoading=false.obs;
  RxBool findSupportLoading=false.obs;

  /// Post Find Provider
  Future<void> postFindProvider() async {
    isLoading.value = true;
    findProviverLoading.value=true;
    try {
      final Map<String, String> body = {
        "name": findProviderController.text,
        "type": "Provider",
      };

      log("provide type body data =>>>$body");
      final response = await repository.postFindProviderType(body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success");
        Get.snackbar("Successful".tr, response.message);
        findProviderController.clear();
      } else {
        log(">>>>>>>>>>>>>>> Error");
        log(">>>>>>>>>>>>>>> text : ${findProviderController.text}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
      findProviverLoading.value=false;
    }
  }

  /// Get Supported Service
  Future<void> getSupportedType() async {
    isLoading.value = true;

    try {
      final response = await repository.getSupportedServiceType();
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success 200");
        supportedServiceList.clear();
        selectedSupportedStates.clear();
        for (int i = 0; i < response.data.length; i++) {
          final name = response.data["data"][i]["name"]??"";
          supportedServiceList.add({"name": name});
          selectedSupportedStates.add(false);
        }
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
   
    }
  }

  /// Post Find Support Service
  Future<void> postFindSupportService() async {
    isLoading.value = true;
        findSupportLoading.value=true;
    try {
      final Map<String, String> body = {
        "name": findSupportServiceController.text,
        "type": "sopportedServices",
      };

      log("provide type body data =>>>$body");
      final response = await repository.postFindProviderType(body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success");
        Get.snackbar("Successful".tr, response.message);
        findSupportServiceController.clear();
      } else {
        log(">>>>>>>>>>>>>>> Error");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      
      isLoading.value = false;   findSupportLoading.value=false;
    }
  }

  /// Get Additional Service
  Future<void> getAdditionalType() async {
    isLoading.value = true;
    try {
      final response = await repository.getAdditionalServiceType();
      if (response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success Additional Service");
        additionalServiceList.clear();
        selectedAdditionalStates.clear();
        for (int i = 0; i < response.data['data'].length; i++) {
          final name = response.data['data'][i]["name"];
          additionalServiceList.add({"name": name});
          selectedAdditionalStates.add(false);
        }
      } else {
        log(">>>>>>>>>>>>>>> Error Additional Service");
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  /// Post Find Additional Service
  Future<void> postFindAdditionalService() async {
    isLoading.value = true;
    try {
      final Map<String, String> body = {
        "name": findAdditionalServiceController.text,
        "type": "extraServices",
      };

      log("provide type body data =>>>$body");
      final response = await repository.postFindProviderType(body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success");
        Get.snackbar("Successful".tr, response.message);
      } else {
        log(">>>>>>>>>>>>>>> Error");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLoading.value = false;
    }
  }

  /// Create Complete Business
  Future<void> createCompleteBusiness() async {
    log(">>>Business Name ===== : ${businessNameController.text}");
    log(">>>shortDescription  ===== : ${shortDescriptionController.text}");
    log(">>>description  ===== : ${detailedDescriptionController.text}");
    log(">>>phoneNumber  ===== : ${phoneNumberController.text}");
    log(">>>website  ===== : ${websiteController.text}");
    log(">>>facebook  ===== : ${facebookController.text}");
    log(">>>instagram  ===== : ${instagramController.text}");
    log(">>>tiktok  ===== : ${tilTokController.text}");
    log(">>>selectedDay  ===== : $selectedDay");
    log(">>>startTime  ===== : ${startTime.value}");
    log(">>>endTime  ===== : ${endTime.value}");
    log(">>>address  ===== : ${addressSearchController.text}");
    log(">>>lat  ===== : $lat");
    log(">>>long  ===== : $long");
    log(">>>Provider type id   ===== : ${selectedProviderType.value}");
    log(">>>notFoundProvider    ===== : ${findProviderController.text}");
    log(">>>supportedServices   ===== : $selectedSupportedServices");
    log(">>>notFoundSupported    ===== : ${findSupportServiceController.text}");
    log(">>>Additional Services    ===== : $selectedAdditionalServices");
    log(
      ">>>notFoundAdditional   ===== : ${findAdditionalServiceController.text}",
    );
    log(">>>priceRange   ===== : ${selectedPriceRange.value}");
    log(">>>maxGuest   ===== : ${maxCountController.text}");
    log(">>>logo   ===== : ${businessLogo.value}");
    log(">>>galleryImages   ===== : $galleryLogo");
    log(">>>cover   ===== : ${coverLogo.value}");
    log(">>>promotion   ===== : ${promotionLogo.value}");

    isLoading.value = true;
    try {
      // Prepare supportedServices from selectedSupportedServices
      final supportedServicesNames =
          selectedSupportedServices
              .map((service) => service.toString())
              .toList();

      final Map<String, String> header = {
        "token": PrefsHelper.token,
        'Content-Type': "application/json",
      };

      final Map<String, String> body = {
        "data": jsonEncode({
          "name": businessNameController.text,
          "shortDescription": shortDescriptionController.text,
          "description": detailedDescriptionController.text,
          "email": emailController2.text,
          "phoneNumber": phoneNumberController.text,
          "website": websiteController.text,
          "socialLinks": {
            "facebook": facebookController.text,
            "instagram": instagramController.text,
            "twitter": "twitter",
            "tiktok": tilTokController.text,
          },
          "availabilities": {
            "day": selectedDay.toList(),
            "startTime": startTime.value,
            "endTime": endTime.value,
          },
          "address": addressSearchController.text,
          "longitude": long,
          "latitude": lat,
          "providerType": selectedProviderType.value,
          "notFoundProvideType": findProviderController.text,
          "supportedServices": supportedServicesNames.toList(),
          "notFoundSupported": findSupportServiceController.text,
          "additionalServices": selectedAdditionalServices.toList(),
          "notFoundAdditional": findAdditionalServiceController.text,
          "priceRange": selectedPriceRange.value,
          "maxGuest": int.tryParse(maxCountController.text) ?? 0,
          "faq": List.generate(
            questionControllers.length,
            (index) => {
              "question": questionControllers[index].text,
              "answer": answerControllers[index].text,
            },
          ),
        }),
      };

      final multipartBody = <MultipartBody>[];

      if (coverLogo.value.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverLogo.value)));
      }
      if (businessLogo.value.isNotEmpty) {
        multipartBody.add(
          MultipartBody("logo", File(businessLogo.value)),
        );
      }
      if (promotionLogo.value.isNotEmpty) {
        multipartBody.add(
          MultipartBody("promotionImage", File(promotionLogo.value)),
        );
      }
      if (galleryLogo.isNotEmpty) {
        for (var i = 0; i < galleryLogo.length; i++) {
          multipartBody.add(
            MultipartBody("gallery", File(galleryLogo[i].path)),
          );
        }
      }

      log("provide type body data =>>>$body");
      var response = await ApiService.to.multipartData(
        AppUrl.businessCreate,
        body,
        multipartBody: multipartBody,
        extraHeaders: header,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        log(">>>>>>>>>>>>>>> Success");
        Get.snackbar("Successful".tr, response.message);
        
        log(response.data.toString());
        PrefsHelper.setParentBusinessId(response.data["_id"]);
        // Get.offAllNamed(RoutesName.signIn);
        Get.offAllNamed(RoutesName.nav);

PrefsHelper.clearDraft();




      } else {
        log(
          ">>>>>>>>>>>>>>> Error: ${response.statusCode} - ${response.message}",
        );
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
      Get.snackbar("Error".tr,"Failed to create business: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProviderType();
    getSupportedType();
    getAdditionalType();
  }
}
