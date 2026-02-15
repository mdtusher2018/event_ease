import 'dart:developer';
import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';

class PermissionController extends GetxController {
  final userRepository = UserRepository();

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxString address = ''.obs;
  final RxBool enableNotification = false.obs;
  final RxBool isLoading = false.obs;

  Future<void> getCurrentLocation() async {
    try {
      final location = loc.Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          log('User did not enable location services.');
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      log("=======>>>> ${latitude.value}, ${longitude.value} <<<<=======");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address.value = '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        address.value = 'Address not found';
      }
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  Future<void> completePermission() async {
    isLoading.value = true;
    try {
      final body = {
        "address": address.value,
        "longitude": longitude.value,
        "latitude": latitude.value,
        "enableNotification": enableNotification.value,
      };

      final response = await userRepository.postPermission(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Success: ${response.message}");
        PrefsHelper.address = address.value;
        PrefsHelper.setString("address", PrefsHelper.address);
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error: $e");
      log("Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }
}
