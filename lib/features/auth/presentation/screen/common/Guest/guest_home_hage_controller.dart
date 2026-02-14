import 'dart:developer';
import 'dart:io';
import 'package:event_ease/features/auth/presentation/models/InspirationCategoryModel.dart';
import 'package:event_ease/features/auth/presentation/models/ProviderCategoryModel.dart';
import 'package:event_ease/features/auth/presentation/models/business_model.dart';
import 'package:event_ease/features/auth/presentation/models/subscription_event_model.dart';
import 'package:event_ease/features/auth/presentation/screen/common/Guest/guest_home_page_repository.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GuestHomePageController extends GetxController {
  final GuestHomePageRepository _guestHomePageRepository =
      GuestHomePageRepository();

  RxBool isLoading = false.obs;
  RxBool isBusinessLoading = false.obs;
  RxList<Business> businessList = <Business>[].obs;
  var providerCategories = <ProviderCategory>[].obs;
  RxList<EventModel> subscriptionList = <EventModel>[].obs;

  RxList<Business> eventsList = <Business>[].obs;

  RxList<InspirationCategory> inspirationList = <InspirationCategory>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchProviderCategories();
    fetchAllSubscriptionEvents();
    fetchAllInspirationCategory();
    getInspirationCategory();
  }

  Position? position;
  Future<void> fetchAllBusinesses(String? name) async {
    try {
      name = name?.replaceAll("&", "%26");
      isBusinessLoading.value = true;

      if (position == null) {
        // position = await Geolocator.getCurrentPosition();
        // double lat = position!.latitude;
        // double long = position!.longitude;
        double lat;
        double long;
        if ((Platform.isIOS)?await Geolocator.isLocationServiceEnabled():(await Permission.location.isGranted)) {
          position = await Geolocator.getCurrentPosition();
          lat = position!.latitude;
          long = position!.longitude;
        } else {
          lat = 41.9028; // Rome latitude
          long = 12.4964; // Rome longitude
        }

        final response = await _guestHomePageRepository.getAllBusiness(
          name,
          long,
          lat,
        );

        if (response.success && response.data != null) {
          final businessResponse = BusinessDataModel.fromJson(response.data);
          businessList.assignAll(businessResponse.data);
          log(
            "Fetched ${businessList.length} businesses...........................",
          );
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      } else {
        double lat = position!.latitude;
        double long = position!.longitude;
        final response = await _guestHomePageRepository.getAllBusiness(
          name,
          long,
          lat,
        );

        if (response.success && response.data != null) {
          final businessResponse = BusinessDataModel.fromJson(response.data);
          businessList.assignAll(businessResponse.data);
          log(
            "Fetched ${businessList.length} businesses.....................................",
          );
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      }
    } catch (e, s) {
      log("Error in fetchAllBusinesses: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isBusinessLoading.value = false;
    }
  }

  Future<void> fetchAllSubscriptionEvents() async {
    try {
      isLoading.value = true;
      if (position == null) {
        double lat;
        double long;
        if ((Platform.isIOS)?await Geolocator.isLocationServiceEnabled():(await Permission.location.isGranted)) {
          position = await Geolocator.getCurrentPosition();
          lat = position!.latitude;
          long = position!.longitude;
        } else {
          lat = 41.9028; // Rome latitude
          long = 12.4964; // Rome longitude
        }

        final response = await _guestHomePageRepository
            .getALLSubscriptionEvents(long, lat);

        if (response.success && response.data != null) {
          final businessResponse = AllEventResponseModel.fromJson(
            response.data,
          );
          subscriptionList.assignAll(businessResponse.data);
          log("Fetched ${businessList.length} Subscription businesses");
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      } else {
        double lat = position!.latitude;
        double long = position!.longitude;
        final response = await _guestHomePageRepository
            .getALLSubscriptionEvents(long, lat);

        if (response.success && response.data != null) {
          final businessResponse = AllEventResponseModel.fromJson(
            response.data,
          );
          subscriptionList.assignAll(businessResponse.data);
          log("Fetched ${businessList.length} Subscription businesses");
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      }
    } catch (e, s) {
      log("Error in fetchAllSubscriptionEvents: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllInspirationCategory() async {
    try {
      isLoading.value = true;
      final response =
          await _guestHomePageRepository.getALLInspirationCategory();

      if (response.success && response.data != null) {
        final inspirationResponse = InspirationCategoryModel.fromJson(
          response.data,
        );
        inspirationList.assignAll(inspirationResponse.categories);
        log("Fetched ${businessList.length} Subscription businesses");
      } else {
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error in fetchAllBusinesses: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchProviderCategories() {
    isLoading.value = true;

    try {
      // final response = await _businessRepository.getProviderCategories();
      // final catagoryResponse = ProviderCategoryDataModel.fromJson(
      //   response.data,
      // );
      providerCategories.assignAll([
        ProviderCategory(
          name: "Location & Venues",
          banner: "assets/microcatagory/LocationAndVenues.svg",
        ),
        ProviderCategory(
          name: "Food & Catering",
          banner: "assets/microcatagory/FoodAndCatering.svg",
        ),
        ProviderCategory(
          name: "Event Planning & Services",
          banner: "assets/microcatagory/EventPlanningAndServices.svg",
        ),
        ProviderCategory(
          name: "Entertainment & Music",
          banner: "assets/microcatagory/EntertainmentAndMusic.svg",
        ),
        ProviderCategory(
          name: "Beauty & Wellness",
          banner: "assets/microcatagory/BeautyAndWellness.svg",
        ),
        ProviderCategory(
          name: "Design & Decorations",
          banner: "assets/microcatagory/DesignAndDecorations.svg",
        ),
        ProviderCategory(
          name: "Logistics & Rentals",
          banner: "assets/microcatagory/LogisticsRentals.svg",
        ),
        ProviderCategory(
          name: "Professionals & Training",
          banner: "assets/microcatagory/ProfessionalsTraining.svg",
        ),
      ]);
      fetchAllBusinesses(providerCategories.first.name);
    } catch (e, s) {
      log("Error in fetchAllBusinesses: $e\n$s");
      Get.snackbar("Error".tr, "Error in fetch Catagories: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  RxList inspirationCategoryList = [].obs;
  RxList specificCategoryList = [].obs;
  RxString categoryName = "".obs;

  Future<void> getInspirationCategory() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.inspirationCategory);

      if (response.statusCode == 200) {
        log(
          ">>>>>>>>>>>>>>>>>>>>>>>>>  Response : ==============${response.data['data']} ",
        );
        inspirationCategoryList.value = response.data['data'];
        log("Fetched Inspiration Category");
      } else {
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error in fetch Inspiration Category: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
