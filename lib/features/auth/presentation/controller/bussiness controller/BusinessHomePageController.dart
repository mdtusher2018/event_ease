import 'dart:developer';
import 'package:event_ease/features/auth/data/repository/bussiness%20repositories/home_page_repository.dart';
import 'package:event_ease/features/auth/presentation/models/InspirationCategoryModel.dart';
import 'package:event_ease/features/auth/presentation/models/ProviderCategoryModel.dart';
import 'package:event_ease/features/auth/presentation/models/business_like_model.dart';
import 'package:event_ease/features/auth/presentation/models/business_model.dart';
import 'package:event_ease/features/auth/presentation/models/subscription_event_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BusinessController extends GetxController {
  static BusinessController get instance => Get.put(BusinessController());
  final BusinessHomePageRepository _businessRepository =
      BusinessHomePageRepository();

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
    fetchAllEvents();
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
        if (await Permission.location.isGranted) {
          position = await Geolocator.getCurrentPosition();
          lat = position!.latitude;
          long = position!.longitude;
        } else {
          lat = 41.9028; // Rome latitude
          long = 12.4964; // Rome longitude
        }

        final response = await _businessRepository.getAllBusiness(
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
        final response = await _businessRepository.getAllBusiness(
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
        if (await Permission.location.isGranted) {
          position = await Geolocator.getCurrentPosition();
          lat = position!.latitude;
          long = position!.longitude;
        } else {
          lat = 41.9028; // Rome latitude
          long = 12.4964; // Rome longitude
        }

        final response = await _businessRepository.getALLSubscriptionEvents(
          long,
          lat,
        );

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
        final response = await _businessRepository.getALLSubscriptionEvents(
          long,
          lat,
        );

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

  Future<void> fetchAllEvents() async {
    try {
      isLoading.value = true;
      if (position == null) {
        // position = await Geolocator.getCurrentPosition();
        //     double lat = position!.latitude;
        // double long = position!.longitude;
        double lat;
        double long;
        if (await Permission.location.isGranted) {
          position = await Geolocator.getCurrentPosition();
          lat = position!.latitude;
          long = position!.longitude;
        } else {
          lat = 41.9028; // Rome latitude
          long = 12.4964; // Rome longitude
        }
        final response = await _businessRepository.getALLEvents(long, lat);
        if (response.success && response.data != null) {
          final businessResponse = BusinessDataModel.fromJson(response.data);
          eventsList.assignAll(businessResponse.data);
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      } else {
        double lat = position!.latitude;
        double long = position!.longitude;
        final response = await _businessRepository.getALLEvents(long, lat);
        if (response.success && response.data != null) {
          final businessResponse = BusinessDataModel.fromJson(response.data);
          eventsList.assignAll(businessResponse.data);
          log("Fetched ${businessList.length} Subscription businesses");
        } else {
          Get.snackbar("Error".tr, response.message);
        }
      }
    } catch (e, s) {
      log("Error in fetchAllEvents: $e\n$s");
      Get.snackbar("Error".tr, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllInspirationCategory() async {
    try {
      isLoading.value = true;
      final response = await _businessRepository.getALLInspirationCategory();

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

  final Rx<BusinessLikeModel?> businessLikeResponse = Rx<BusinessLikeModel?>(
    null,
  );

  Future<void> likeBusiness(String businessId) async {
    try {
      isLoading.value = true;

      final response = await _businessRepository.likeBusiness(
        businessId: businessId,
      );

      if (response.success) {
        businessLikeResponse.value = BusinessLikeModel.fromJson({
          "success": response.success,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": response.data,
        });
      } else {
        // Handle failure
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
