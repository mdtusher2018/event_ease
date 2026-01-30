import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/filter_model/wizard_model.dart';
import 'package:event_ease/features/auth/presentation/models/subscription_event_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/service_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/filter_data_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/search/wizard_data_screen.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/search/wizard_event_page.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../models/engagment/comment_model.dart';

class WizardController extends GetxController {
  //=======================================================get event catagory
  RxList locationType = [].obs;
  RxList selectedService = [].obs;
  RxList selectedCatagory = [].obs;
  RxList selectedAdditionalService = [].obs;

  RxString peopleAttend = "".obs;
  RxString selectedBudget = "".obs;
  RxString latitude = "41.902782".obs;
  RxString longitude = "12.496366".obs;
  RxDouble distance = 50.0.obs; // default value
  final SupportedServicesController supportAndAdditionalcontroller = Get.put(
    SupportedServicesController(),
  );
  RxList<String> eventCatagory = <String>[].obs;
  RxBool isCatagory = false.obs;
  Future<void> getCatagory() async {
    isCatagory(true);
    try {
      var response = await ApiService.to.getApi(AppUrl.eventCatagory);
      var data = response.data;
      if (response.statusCode == 200) {
        List catagory = data["data"];
        eventCatagory.clear();
        for (var i = 0; i < catagory.length; i++) {
          String title = catagory[i]["name"];
          eventCatagory.add(title);
        }

        log("event catagory====================$eventCatagory");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isCatagory(false);
    }
  }

  //=====================================================================get buissness name list
  RxBool isgetBuissness = false.obs;
  RxBool isgetEvent = false.obs;
  RxList<Map<String, String>> buissness = <Map<String, String>>[].obs;
  RxList<Map<String, String>> event = <Map<String, String>>[].obs;

  getBuissnessName() async {
    isgetBuissness(true);
    try {
      var response = await ApiService.to.getApi(
        AppUrl.categoryBusinessNameList,
      );

      if (response.statusCode == 200) {
        List data = response.data;
        eventCatagory.clear();
        for (var i = 0; i < data.length; i++) {
          String title = data[i]["name"];
          buissness.add({"name": title});
        }

        log("buissness name ====================$buissness");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isgetBuissness(false);
    }
  }

  getEventName() async {
    isgetEvent(true);
    try {
      var response = await ApiService.to.getApi(AppUrl.categoryEventNameList);

      if (response.success) {
        List data = response.data;
        eventCatagory.clear();
        for (var i = 0; i < data.length; i++) {
          String title = data[i]["name"];
          event.add({"name": title});
        }

        log("event name ====================$event");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isgetEvent(false);
    }
  }

  ////===========================================================get wizard
  RxBool isFilter = false.obs;
  RxBool isEventFilter = false.obs;
  RxList filterData = [].obs;
  RxList<EventModel> eventFilterData = <EventModel>[].obs;

  RxString addressForWizad = "".obs;

  getWizard() async {
    isFilter(true);
    log("selectedService==================$selectedService");
    log("selectedCatagory==================$locationType");
    log(
      "SelectedAdditionalService==================$selectedAdditionalService",
    );
    String catagoryQuery = locationType
        .map(
          (e) =>
              "categoryName=${e.contains('&') ? e.replaceAll('&', '%26') : e}",
        )
        .join("&");
    String serviceQuery = selectedService
        .map(
          (e) => "services=${e.contains('&') ? e.replaceAll('&', '%26') : e}",
        )
        .join("&");
    String additionalServiceQuery = selectedAdditionalService
        .map(
          (e) =>
              "extraServices=${e.contains('&') ? e.replaceAll('&', '%26') : e}",
        )
        .join("&");

    double long = double.parse(longitude.value);
    double lat = double.parse(latitude.value);
    log("lat=======${lat}\nlng=============${long}");
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    String address = "Roma";
    String city = "Lazio";
    String town = "Italy";
    String fullAddress = "";

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      address = "${place.street}, ${place.subLocality}";
      city = "${place.locality}";
      town = "${place.administrativeArea}";
      fullAddress = [
        if (place.street != null && place.street!.isNotEmpty)
          place.street, // e.g. 12
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          place.subLocality, // e.g. Quartiere
        if (place.locality != null && place.locality!.isNotEmpty)
          place.locality, // e.g. Roma
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          place.administrativeArea, // e.g. Lazio
        if (place.postalCode != null && place.postalCode!.isNotEmpty)
          place.postalCode, // e.g. 00100
        if (place.country != null && place.country!.isNotEmpty)
          place.country, // e.g. Italy
      ].join(", ");
    }

    log(
      "Address: $address, City: $city, Town: $town, full address: $fullAddress",
    );

    log(searchCtl.value.text + "=========>>>>>>>>> searchCtl");

    String createdUrl =
        "${AppUrl.getwizard}?$catagoryQuery&longitude=$longitude&latitude=$latitude&maxGuest=$peopleAttend&$serviceQuery&$additionalServiceQuery&priceRange=$selectedBudget&maxDistance=${distance.value}&city=$city&town=$town&address=${searchCtl.value.text}";

    log(createdUrl + "{{}}");

    try {
      var response = await ApiService.to.getApi(createdUrl);
      log(response.data.toString());
      List data = response.data;
      if (response.statusCode == 200) {
        filterData.clear();

        Get.to(WizardDataScreen(), transition: Transition.rightToLeftWithFade);
        filterData.value =
            data.map((value) => WizardModel.fromJson(value)).toList();

        log("wizard list====================$data");
        log("wizard list filterData ====================$filterData");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isFilter(false);
    }
  }

  //=============================================================get free search data
  getFreeSearchData({
    String searchValue = "",
    bool isBusiness = false,
    bool customLocation = false,
    String? customCity,
    String? customTown,
    String? customAddress,
    String? customFulladdress,
    String? customLongitude,
    String? customLatitude,
  }) async {
    isFilter(true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();

      // 2️⃣ Convert lat/lng to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Roma";
      String city = "Lazio";
      String town = "Italy";

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street}, ${place.subLocality}";
        city = "${place.locality}";
        town = "${place.subLocality}";
      }

      log("Address: $address, City: $city, Town: $town");

      // 3️⃣ Call API with location info
      var response = await ApiService.to.getApi(
        AppUrl.freeSearch(
          searchValue: searchValue,
          address:
              (customLocation)
                  ? (customFulladdress != null && customFulladdress.isNotEmpty)
                      ? customFulladdress
                      : customAddress
                  : address,
          city: (customLocation) ? customCity : city,
          town: (customLocation) ? customTown : town,
          latitude:
              (customLocation) ? customLatitude : position.latitude.toString(),
          longitude:
              (customLocation)
                  ? customLongitude
                  : position.longitude.toString(),
        ),
      );
      List data = response.data;
      log("free search data ======$data");
      if (response.statusCode == 200) {
        filterData.clear();

        Get.to(
          WizardDataScreen(isBussiness: isBusiness),
          transition: Transition.rightToLeftWithFade,
        );
        filterData.value =
            data.map((value) => WizardModel.fromJson(value)).toList();

        log("Free search====================$data");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isFilter(false);
    }
  }

  getFreeEventSearchData({
    String searchValue = "",
    bool customLocation = false,
    String? customCity,
    String? customTown,
    String? customAddress,
    String? customFulladdress,
    String? customLongitude,
    String? customLatitude,
  }) async {
    isEventFilter(true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();

      // 2️⃣ Convert lat/lng to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Roma";
      String city = "Lazio";
      String town = "Italy";

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street}, ${place.subLocality}";
        city = "${place.locality}";
        town = "${place.subLocality}";
      }

      log("Address: $address, City: $city, Town: $town");

      var response = await ApiService.to.getApi(
        AppUrl.freeEventSearch(
          searchValue: searchValue,
          address:
              (customLocation)
                  ? (customFulladdress != null && customFulladdress.isNotEmpty)
                      ? customFulladdress
                      : customAddress
                  : address,
          city: (customLocation) ? customCity : city,
          town: (customLocation) ? customTown : town,
          latitude:
              (customLocation) ? customLatitude : position.latitude.toString(),
          longitude:
              (customLocation)
                  ? customLongitude
                  : position.longitude.toString(),
        ),
      );
      List data = response.data['data'];
      log("free search data ======$data");
      if (response.statusCode == 200) {
        filterData.clear();

        Get.to(
          WizarEventdDataScreen(),
          transition: Transition.rightToLeftWithFade,
        );
        eventFilterData.value =
            data.map((value) => EventModel.fromJson(value)).toList();

        log("Free search====================$data");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isEventFilter(false);
    }
  }
  //=============================================================================buissness filter

  RxBool isBuissnessFilter = false.obs;
  RxList bussnessFilter = [].obs;
  RxList eventType = [].obs;
  RxList buissnessBudget = [].obs;
  RxInt maxGuest = 0.obs;
  RxString sortBy = "High to Low".obs;
  RxString buissnessLat = "".obs;
  RxString buissnessLng = "".obs;

  RxString city = "".obs;
  RxString state = "".obs;
  RxString town = "".obs;

  getFilteredBuissness() async {
    isBuissnessFilter(true);
    String sortByQuery = sortBy == "High to Low" ? "dsc" : "asc";
    String categoryName = eventType
        .map(
          (e) =>
              "categoryName=${e.contains('&') ? e.replaceAll('&', '%26') : e}",
        )
        .join("&");
    String budget = buissnessBudget
        .map(
          (e) => "priceRange=${e.contains('&') ? e.replaceAll('&', '%26') : e}",
        )
        .join("&");

    // 2️⃣ Convert lat/lng to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      double.parse(buissnessLat.value),
      double.parse(buissnessLng.value),
    );

    String address = "Roma";
    String city = "Lazio";
    String town = "Italy";

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      address = "${place.street}, ${place.subLocality}";
      city = "${place.locality}";
      town = "${place.subLocality}";
    }

    log("Address: $address, City: $city, Town: $town");

    address =
        (searchCtl.value.text.isNotEmpty) ? searchCtl.value.text : address;
    log(address + ">>>>>>>>>>>>>>>");

    String createdUrl =
        "${AppUrl.buissnessFilter}?$categoryName&priceRange=$budget&maxGuest=$maxGuest&longitude=$buissnessLng&latitude=$buissnessLat&sortPriceRange=$sortByQuery&town=$town&address=$address&city=$city";

    log(createdUrl);

    try {
      var response = await ApiService.to.getApi(createdUrl);
      List data = response.data;
      if (response.statusCode == 200) {
        Get.to(FilterDataScreen(), transition: Transition.rightToLeftWithFade);
        bussnessFilter.value =
            data.map((value) => WizardModel.fromJson(value)).toList();
        log("Buissness list====================$bussnessFilter");
      } else {
        Get.snackbar("Error".tr, "No data found".tr);
      }
    } catch (e) {
      log("Exception while fetching interested users: $e");
    } finally {
      isBuissnessFilter(false);
    }
  }

  budgetManage({required range}) {
    if (range == 1.0) {
      buissnessBudget.clear();
      buissnessBudget.addAll(["budget"]);
    } else if (range == 2.0) {
      buissnessBudget.clear();
      buissnessBudget.addAll(["budget", "medium"]);
    } else if (range == 3.0) {
      buissnessBudget.clear();
      buissnessBudget.addAll(["budget", "medium", "high"]);
    } else if (range == 4.0) {
      buissnessBudget.clear();
      buissnessBudget.addAll(["budget", "medium", "high", "luxury"]);
    }
    log("budgetRange========$buissnessBudget");
  }

  ///================================================================================
  //=============================================================get comment
  RxBool isGetComment = false.obs;
  RxList commentList = [].obs;
  UserRepository userRepository = UserRepository();
  Future<void> getComment({id}) async {
    isGetComment.value = true;
    try {
      final response = await userRepository.getCommentsPersonalized(id: id);
      if (response.statusCode == 200) {
        final List data = response.data as List;
        commentList.value = data.map((e) => CommentModel.fromJson(e)).toList();
        log("Fetched commentList : $commentList");
      } else {
        log("Error : ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error e: $e");
      log("Error s: $s");
      Get.snackbar("Error".tr, "$e\$$s");
    } finally {
      isGetComment.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Comment post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  RxBool isSheet = false.obs;
  RxBool isPostComment = false.obs;
  Rx<TextEditingController> commentController = TextEditingController().obs;

  Future<void> commentPost(String id, BuildContext context) async {
    isPostComment.value = true;
    try {
      final Map<String, String> body = {
        "postId": id,
        "text": commentController.value.text,
      };

      log("commentbody========$body");

      final response = await userRepository.commentPost(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");

        commentController.value.clear();

        // ✅ Only close the bottom sheet
        Navigator.of(context).pop();

        // Get.back(); /============== here back not working
        log("comment success============================================");
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isPostComment.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Post like
  RxBool isLikedPersonalized = false.obs;
  Future<void> likePostPersonalized(
    String id,
    BuildContext context,
    WizardModel data,
  ) async {
    isLikedPersonalized.value = true;
    try {
      final Map<String, String> body = {"businessId": id};

      log("commentbody========$body");

      final response = await userRepository.postPersonalizedLike(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");
        // Get.back(); /============== here back not working
        log("like success============================================");
        data.totalLikes++;
        data.isLiked = true;
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isLikedPersonalized.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Post unlike
  RxBool isUnLikedPersonalized = false.obs;
  Future<void> unLikePostPersonalized(
    String id,
    BuildContext context,
    WizardModel data,
  ) async {
    isUnLikedPersonalized.value = true;
    try {
      final Map<String, String> body = {"businessId": id};

      log("commentbody========$body");

      final response = await userRepository.postPersonalizedUnLike(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(">>>>>>>>>>>>>>> Success 200");
        log(">>>>>>>>>>>>>>> response : ${response.data}");
        // Get.back(); /============== here back not working
        log("unlike success============================================");
        data.totalLikes--;
        data.isLiked = false;
      } else {
        log(">>>>>>>>>>>>>>> Error 200");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Error E : $e");
      log("Error S : $s");
    } finally {
      isUnLikedPersonalized.value = false;
    }
  }

  //=====================================================================================for the address selection screen
  Rx<TextEditingController> searchCtl = TextEditingController().obs;
  RxBool allowPageSwipe = true.obs;
  late GoogleMapController googleMapController;

  Rx<CameraPosition> initialCameraPosition =
      CameraPosition(target: LatLng(41.902782, 12.496366), zoom: 11.0).obs;
  RxList<Marker> markers =
      <Marker>[
        Marker(
          markerId: MarkerId('selected_location'),
          position: LatLng(41.902782, 12.496366),
          infoWindow: InfoWindow(title: 'Selected Location'),
        ),
      ].obs;

  manageCountryLatLng({index = 0}) {
    if (index == 0) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(41.902782, 12.496366),
        zoom: 11.0,
      );
      latitude.value = "41.902782";
      longitude.value = "12.496366";
    } else if (index == 1) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(45.4685, 9.1824),
        zoom: 11.0,
      );
      latitude.value = "45.4685";
      longitude.value = "9.1824";
    } else if (index == 2) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(43.7700, 11.2577),
        zoom: 11.0,
      );
      latitude.value = "43.7700";
      longitude.value = "11.2577";
    } else if (index == 3) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(45.4404, 12.3160),
        zoom: 11.0,
      );
      latitude.value = "45.4404";
      longitude.value = "12.3160";
    } else if (index == 4) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(44.498955, 11.327591),
        zoom: 11.0,
      );
      latitude.value = "44.498955";
      longitude.value = "11.327591";
    } else if (index == 5) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(40.8518, 14.2681),
        zoom: 11.0,
      );
      latitude.value = "40.8518";
      longitude.value = "14.2681";
    }
  }
}
