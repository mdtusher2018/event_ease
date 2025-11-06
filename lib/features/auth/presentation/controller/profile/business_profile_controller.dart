import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/features/auth/data/repository/auth_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/business_profile_model.dart';
// import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helper/other_helper.dart';
import '../../../../../core/helper/prefs_helper.dart';
import '../../../data/repository/business_repository.dart';
import '../../utils/app_string.dart';

class BusinessProfileController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  BusinessRepository repository = BusinessRepository();
  RxBool isLoading = false.obs;

  Rx<BusinessProfileModel> businessProfileModel = BusinessProfileModel().obs;

  Rx<TextEditingController> businessNameController = TextEditingController().obs;
  Rx<TextEditingController> shortDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> detailedDescriptionController = TextEditingController().obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>> Image & Media
  RxString businessLogo = ''.obs;
  RxString businessLogoNetwork = ''.obs;
  RxString coverLogo = ''.obs;
  RxString coverLogoNetwork = ''.obs;
  RxBool logoUploaded = false.obs;
  RxBool logoUploadedNetwork = false.obs;
  RxList<File> galleryLogoLocal = <File>[].obs;
  RxList<String> galleryLogoNetwork = <String>[].obs;

  void businessImage() async {
    businessLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
    if (businessLogo.value.isNotEmpty) {
      logoUploaded.value = true;
    }
  }

  void coverImage() async {
    coverLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  void galleryImage() async {
    final List<String> paths = await OtherHelper.pickMultipleImage(
      ImageSource.gallery,
    );
    galleryLogoLocal.value = paths.map((path) => File(path)).toList();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>> contact info
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> websiteController = TextEditingController().obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>> social network
  Rx<TextEditingController> facebookController = TextEditingController().obs;
  Rx<TextEditingController> instagramController = TextEditingController().obs;
  Rx<TextEditingController> twitterController = TextEditingController().obs;
  Rx<TextEditingController> tikTokController = TextEditingController().obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Business hours

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Address & Map
  Rx<TextEditingController> addressSearchController = TextEditingController().obs;
  RxString geoLocation = "".obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Business hours
  RxList<bool> selectedDays = List.generate(7, (_) => false).obs;
  RxList<String> selectedDayNames = <String>[].obs;

  RxString startTime = ''.obs;
  RxString endTime = ''.obs;

  final List<String> dayNames = [
    AppString.sunday,
    AppString.monday,
    AppString.tuesday,
    AppString.wednesday,
    AppString.thursday,
    AppString.friday,
    AppString.saturday,
  ];

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formatted = picked.format(context);
      if (isStartTime) {
        startTime.value = formatted;
      } else {
        endTime.value = formatted;
      }
    }
  }

  ///>>>>>>>>>>>>>> Service DETAILS

  RxInt guestCount = 1.obs;
  Rx<TextEditingController> maxCountController = TextEditingController().obs;
  RxString selectedPriceRange = ''.obs;

  RxList<dynamic> providerList = <dynamic>[].obs;
  RxString selectedProviderType = ''.obs;

  RxList<dynamic> supportedServiceList = <dynamic>[].obs;
  RxList<String> selectedSupportedServices = <String>[].obs;
  RxList<bool> selectedSupportedStates = <bool>[].obs;
  RxBool showSupportedServiceList = false.obs;

  RxList<dynamic> additionalServiceList = <dynamic>[].obs;
  RxList<String> selectedAdditionalServices = <String>[].obs;
  RxList<bool> selectedAdditionalStates = <bool>[].obs;
  RxBool showAdditionalServiceList = false.obs;

  final List<Map<String, String>> priceOptions = [
    {"label": "€-Budget", "value": "budget"},
    {"label": "€€-Medium", "value": "medium"},
    {"label": "€€€-High", "value": "high"},
    {"label": "€€€€-Luxury", "value": "luxury"},
  ];

  void incrementGuestCount() {
    guestCount.value++;
    maxCountController.value.text = guestCount.value.toString();
  }

  void decrementGuestCount() {
    if (guestCount.value > 0) {
      guestCount.value--;
      maxCountController.value.text = guestCount.value.toString();
    }
  }

  void handlePriceRangeChange(String value) {
    selectedPriceRange.value = value;
  }


  ///>>>>>>>>>>>>>>>>>>>>> FAQ
  RxList<Map<String, String>> faqList = <Map<String, String>>[].obs;
  RxList<TextEditingController> questionControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> answerControllers =
      <TextEditingController>[].obs;

  void addFAQField() {
    faqList.add({'question': '', 'answer': ''});
    questionControllers.add(TextEditingController());
    answerControllers.add(TextEditingController());
  }

  void deleteFAQField(int index) {
    if (faqList.length > index) faqList.removeAt(index);
    if (questionControllers.length > index) questionControllers.removeAt(index);
    if (answerControllers.length > index) answerControllers.removeAt(index);
  }

  void setFaqFromModel(List<FaqItem> items) {
    faqList.clear();
    questionControllers.clear();
    answerControllers.clear();

    for (var item in items) {
      faqList.add({'question': item.question, 'answer': item.answer});
      questionControllers.add(TextEditingController(text: item.question));
      answerControllers.add(TextEditingController(text: item.answer));
    }

    if (faqList.isEmpty) {
      addFAQField(); // at least one empty field
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>> Promotion
  RxString promotionLogo = "".obs;
  RxString promotionLogoNetwork = "".obs;

  void promotionImage() async {
    promotionLogo.value = await OtherHelper.pickImage(ImageSource.gallery);
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  /// Get Provider Type
  Future<void> getProviderType() async {
    isLoading.value = true;
    try {
      final response = await repository.getProviderType();
      if (response.statusCode == 200|| response.statusCode == 201) {
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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all business profile information >>>>>>>>>>>>>>
  Future<void> getBusinessProfile() async {
    isLoading.value = true;
    try {
      var response = await authRepository.getBusinessProfileData();
      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.value = BusinessProfileModel.fromJson(
          response.data,
        );

        // Populate text fields after model is set
        businessNameController.value.text = businessProfileModel.value.name;
        shortDescriptionController.value.text =
            businessProfileModel.value.description;
        detailedDescriptionController.value.text =
            businessProfileModel.value.detailDescription;

        // image media ..............
        businessLogoNetwork.value = businessProfileModel.value.logo;
        log(">>>>>>>> Logo ======== ${businessLogo.value}");
        coverLogoNetwork.value = businessProfileModel.value.coverImage;
        log(">>>>>>>>Cover  Logo ======== ${businessLogo.value}");
        galleryLogoNetwork.value = businessProfileModel.value.gallery;

        // contact info
        emailController.value.text = businessProfileModel.value.email;
        phoneNumberController.value.text = businessProfileModel.value.phoneNumber;
        websiteController.value.text = businessProfileModel.value.website;

        // Social links
        facebookController.value.text = businessProfileModel.value.socialLinks.facebook;
        instagramController.value.text = businessProfileModel.value.socialLinks.instagram;
        twitterController.value.text = businessProfileModel.value.socialLinks.twitter;
        tikTokController.value.text = businessProfileModel.value.socialLinks.tiktok;

        // Business hour
        // Set availabilities
        final avail = businessProfileModel.value.availabilities;

        selectedDayNames.value = avail.day;
        selectedDays.value = List.generate(
          dayNames.length,
          (i) => avail.day.contains(dayNames[i]),
        );
        startTime.value = avail.startTime;
        endTime.value = avail.endTime;

        /////////////////// service details
        selectedProviderType.value = businessProfileModel.value.providerType;
        selectedPriceRange.value = businessProfileModel.value.priceRange;
        guestCount.value = businessProfileModel.value.maxGuest;
        maxCountController.value.text = guestCount.value.toString();

        selectedSupportedServices.assignAll(businessProfileModel.value.supportedServices);
        selectedAdditionalServices.assignAll(businessProfileModel.value.additionalServices);

        // ensure state arrays match list length
        selectedSupportedStates.assignAll(List.generate(supportedServiceList.length,
                (i) => selectedSupportedServices.contains(supportedServiceList[i]['name'])));
        selectedAdditionalStates
            .assignAll(List.generate(additionalServiceList.length,
                (i) => selectedAdditionalServices.contains(additionalServiceList[i]['name'])));

        // Set FAQs
        setFaqFromModel(businessProfileModel.value.faq);

        //...................... promotion
        promotionLogoNetwork.value =
            businessProfileModel.value.promotionImage[0];

        log(">>>>>>>>>> Successful : ===== ${response.message}");
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update General Info >>>>>>>>>>>>
  Future<void> updateGeneralInfo(String id) async {
    isLoading.value = true;
    try {
      var body = {
        "data": jsonEncode({
          "name": businessNameController.value.text,
          "description": shortDescriptionController.value.text,
          "detailDescription": detailedDescriptionController.value.text,
        }),
      };
      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.value.name = businessNameController.value.text;
        businessProfileModel.value.description =
            shortDescriptionController.value.text;
        businessProfileModel.value.detailDescription =
            detailedDescriptionController.value.text;
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update Image & Media Info >>>>>>>>>>>>
  Future<void> updateImageMediaInfo(String id) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {};
      final multipartBody = <MultipartBody>[];

      if (coverLogo.value.isNotEmpty) {
        multipartBody.add(MultipartBody("cover", File(coverLogo.value)));
      }
      if (businessLogo.value.isNotEmpty) {
        multipartBody.add(MultipartBody("logo", File(businessLogo.value)));
      }

      if (galleryLogoLocal.isNotEmpty) {
        for (var i = 0; i < galleryLogoLocal.length; i++) {
          multipartBody.add(
            MultipartBody("gallery", File(galleryLogoLocal[i].path)),
          );
        }
      }

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipartBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.value.logo = businessLogo.value;
        businessProfileModel.value.coverImage = coverLogo.value;
        businessProfileModel.value.gallery =
            galleryLogoLocal.map((file) => file.path).toList();

        log(">>>>>>>>>> Successful : ===== ${response.message}");

        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update contact Info >>>>>>>>>>>>
  Future<void> updateContactInfo(String id) async {
    isLoading.value = true;
    try {
      var body = {
        "data": jsonEncode({
          "email": emailController.value.text,
          "phoneNumber": phoneNumberController.value.text,
          "website": websiteController.value.text,
        }),
      };
      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.value.email = emailController.value.text;
        businessProfileModel.value.phoneNumber =
            phoneNumberController.value.text;
        businessProfileModel.value.website = websiteController.value.text;
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update social network Info >>>>>>>>>>>>
  Future<void> updateSocialInfo(String id) async {
    isLoading.value = true;
    try {
      final Map<String, String> socialLinksMap = {
        "facebook": facebookController.value.text,
        "instagram": instagramController.value.text,
        "twitter": twitterController.value.text,
        "tiktok": tikTokController.value.text,
      };

      final body = {
        "data": jsonEncode({"socialLinks": socialLinksMap}),
      };

      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.update((val) {
          if (val != null) {
            val.socialLinks = SocialLinks.fromJson(socialLinksMap);
          }
        });
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update Address & Map Info >>>>>>>>>>>>
  Future<void> updateAddressMapInfo(String id) async {
    isLoading.value = true;
    try {
      final Map<String, String> addressMap = {
        "address": addressSearchController.value.text,
        // "location": {
        //   "type": "Point",
        //   "coordinates": [
        //     90.38071025805662,
        //     23.780449418610477
        //   ]
        // },
      };

      final body = {"data": jsonEncode(addressMap)};

      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> updatePromotion Info >>>>>>>>>>>>
  Future<void> updatePromotionInfo(String id) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {};
      final multipartBody = <MultipartBody>[];
      log(">>>>>>>>>>>>>>>>>>>> Promotion : =======${promotionLogo.value}");
      if (promotionLogo.value.isNotEmpty) {
        multipartBody.add(
          MultipartBody("promotionImage", File(promotionLogo.value)),
        );
      }

      var header = {
        "Content-Type": "application/json",
        "token": PrefsHelper.token,
      };

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipartBody,
        header: header,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update FAQ Info >>>>>>>>>>>>
  Future<void> updateFaqInfo(String id) async {
    isLoading.value = true;
    try {
      List<Map<String, String>> updatedFaqList = List.generate(
        questionControllers.length,
        (index) => {
          "question": questionControllers[index].text.trim(),
          "answer": answerControllers[index].text.trim(),
        },
      );

      final body = {
        "data": jsonEncode({"faq": updatedFaqList}),
      };

      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        businessProfileModel.update((val) {
          if (val != null) {
            val.faq = updatedFaqList.map((e) => FaqItem.fromJson(e)).toList();
          }
        });
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update Business hour Info >>>>>>>>>>>>
  Future<void> updateSBusinessHourInfo(String id) async {
    isLoading.value = true;
    try {
      final body = {
        "data": jsonEncode({
          "availabilities": {
            "day": selectedDayNames.toList(),
            "startTime": startTime.value,
            "endTime": endTime.value,
          },
        }),
      };

      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>> Successful response : ===== ${response.data}");
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> update Business hour Info >>>>>>>>>>>>
  Future<void> updateServiceDetailInfo(String id) async {
    isLoading.value = true;
    try {
      final body = {
        "data": jsonEncode({
          "providerType": selectedProviderType.value,
          "supportedServices": selectedSupportedServices.toList(),
          "additionalServices": additionalServiceList.toList(),
          "priceRange": selectedPriceRange.value,
          "maxGuest": guestCount.toString(),
        }),
      };

      final multipart = <MultipartBody>[];

      var response = await authRepository.updateBusinessProfileData(
        id,
        body,
        multipart,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>> Successful response : ===== ${response.data}");
        log(">>>>>>>>>> Successful : ===== ${response.message}");
        Get.back();
        Get.snackbar("Success".tr, response.message);
      } else {
        log(">>>>>>>>>> Error : ===== ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>> Error e : === $e");
      log(">>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProviderType();
    getBusinessProfile();
  }
}
