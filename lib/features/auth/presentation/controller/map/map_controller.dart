import 'dart:developer';
import 'dart:ui' as ui;
import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/map_model.dart';
// import 'package:event_ease/features/auth/presentation/screen/common/home/business_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/custom_dialog.dart';

class MapController extends GetxController {
  // static MapController get instance => Get.put(MapController());

  final UserRepository userRepository = UserRepository();
  late GoogleMapController googleMapController;

  RxList<Marker> markers = <Marker>[].obs;
  Rx<MapModel> mapModel = MapModel(businesses: [], events: [], jobs: []).obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  var selectedAddress = "".obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var selectedLocation = LatLng(0.0, 0.0).obs;
  RxBool isLoading = false.obs;
  RxBool isViewProfileLoading = false.obs;

  Rx<CameraPosition> initialCameraPosition =
      CameraPosition(target: LatLng(0.0, 0.0), zoom: 12.0).obs;

  /// Fetches and builds a custom marker icon from a network image
  Future<BitmapDescriptor> getCustomMarkerIcon(String imageUrl) async {
    try {
      final byteData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
      final codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: 40,
        targetHeight: 40,
      );
      final frame = await codec.getNextFrame();

      final width = 40.0;
      final height = 50.0;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      final imageRect = Rect.fromLTWH(0, 0, width, 30);
      canvas.drawImageRect(
        frame.image,
        Rect.fromLTWH(
          0,
          0,
          frame.image.width.toDouble(),
          frame.image.height.toDouble(),
        ),
        imageRect,
        paint,
      );

      final RRect borderRect = RRect.fromRectAndRadius(
        imageRect,
        const Radius.circular(4),
      );
      paint
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawRRect(borderRect, paint);

      //>>>>>>>>>>>>>>> boltu size and position
      final Path pointerPath =
          Path()
            ..moveTo(width / 2 - 10, 30)
            ..lineTo(width / 2 + 10, 30)
            ..lineTo(width / 2, height - 8)
            ..close();

      paint
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawPath(pointerPath, paint);

      final image = await recorder.endRecording().toImage(
        width.toInt(),
        height.toInt(),
      );
      final byteDataMarker = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteDataMarker != null) {
        return BitmapDescriptor.bytes(byteDataMarker.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint("❌ Error creating marker icon: $e");
    }

    return BitmapDescriptor.defaultMarker;
  }

  @override
  void onInit() {
    super.onInit();

    _setInitialLocation();
    getMapData().then((value) {
      selectedCategory.value = 0;
    });

    // You can optionally enable this:
    // setCurrentLocationAsInitialCamera();
  }

  /// Get user current location and set camera
  Future<void> _setInitialLocation() async {
    isLoading.value = true;
    try {
      // 🔹 Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      // 🔹 Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      selectedLocation.value = LatLng(position.latitude, position.longitude);

      updateLocation(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("❌ Error getting location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds a marker to the map
  void addMarker({
    required String markerId,
    required double lat,
    required double lng,
    required BitmapDescriptor icon,
    Function()? onTap,
  }) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(lat, lng),
      icon: icon,
      consumeTapEvents: true,
      onTap: onTap,
    );
    markers.add(marker);
    markers.refresh();
  }

  /// Called when the map is created
  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    if (latitude.value != 0.0 && longitude.value != 0.0) {
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude.value, longitude.value),
          14.0,
        ),
      );
    }
  }

  /// Updates the selected location on the map
  void updateLocation(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
    selectedLocation.value = LatLng(lat, lng);
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0),
    );
  }

  /// Sets the current device location as the initial map camera position
  Future<void> setCurrentLocationAsInitialCamera() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Error", "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Error",
          "Location permission permanently denied.",
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      selectedLocation.value = LatLng(position.latitude, position.longitude);

      initialCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      log("📍 Current location: (${position.latitude}, ${position.longitude})");
    } catch (e) {
      log("❌ Failed to get current location: $e");
    }
  }

  void updateCameraPosition(double lat, double lng, {double zoom = 14.0}) {
    final newPosition = CameraPosition(target: LatLng(lat, lng), zoom: zoom);

    // Update reactive state
    initialCameraPosition.value = newPosition;

    // Animate Google Map
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
  }

  var selectedCategory = 0.obs;

  RxList<Marker> allBusinessMarkers = <Marker>[].obs;
  RxList<Marker> allEventMarkers = <Marker>[].obs;
  RxList<Marker> allJobMarkers = <Marker>[].obs;

  Future<void> getMapData() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getMapData();
      if (response.statusCode == 200) {
        mapModel.value = MapModel.fromJson(response.data);

        // clear old markers
        allBusinessMarkers.clear();
        allEventMarkers.clear();
        allJobMarkers.clear();

        // Businesses
        for (final business in mapModel.value.businesses) {
          final imageUrl = business.coverImage;
          final icon = await getCustomMarkerIcon(imageUrl);
          // if (mapModel.value.businesses.first == business) {
          //   updateCameraPosition(
          //     business.location.coordinates[1],
          //     business.location.coordinates[0],
          //   );
          // }
          allBusinessMarkers.add(
            Marker(
              markerId: MarkerId(business.id),
              position: LatLng(
                business.location.coordinates[1],
                business.location.coordinates[0],
              ),
              icon: icon,
              onTap: () async {
                log(">>>>>>>>>>>>> Name : ${business.name}");
                String address = await OtherHelper.getAddressFromLatLng(
                  business.location.coordinates[1],
                  business.location.coordinates[0],
                );

                CustomDialog.showCustomDialog(
                  Get.context!,
                  image: imageUrl,
                  name: business.name,
                  time: "",
                  address: address,
                  isLoading: isViewProfileLoading,
                  onTap: () async {
                    // Get.snackbar("Success".tr, "Business Profile Details");
                    Get.toNamed(
                      RoutesName.businessDetail,
                      arguments: business.id,
                    );
                  },
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getMapData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  loadMapData() async {
    if (selectedCategory.value == 1) {
      // Events
      for (final event in mapModel.value.events) {
        final imageUrl = event.coverImage;
        final icon = await getCustomMarkerIcon(imageUrl);
        // if (mapModel.value.events.first == event) {
        //   updateCameraPosition(
        //     event.location.coordinates[1],
        //     event.location.coordinates[0],
        //   );
        // }
        allEventMarkers.add(
          Marker(
            markerId: MarkerId(event.id),
            position: LatLng(
              event.location.coordinates[1],
              event.location.coordinates[0],
            ),
            icon: icon,
            onTap: () async {
              log(">>>>>>>>>>>>> Name : ${event.name}");
              String address = await OtherHelper.getAddressFromLatLng(
                event.location.coordinates[1],
                event.location.coordinates[0],
              );

              CustomDialog.showCustomDialog(
                Get.context!,
                image: imageUrl,
                name: event.name,
                isLoading: isViewProfileLoading,
                time: "",
                address: address,
                onTap: () {
                  // Get.snackbar("Success".tr, "Event Profile Details");
                  Get.toNamed(
                    RoutesName.eventDetailScreen,
                    arguments: event.id,
                  );
                },
              );
            },
          ),
        );
      }
    } else if (selectedCategory.value == 2) {
      // // Jobs
      for (final job in mapModel.value.jobs) {
        final icon = await getCustomMarkerIcon(job.coverImage);
        // if (mapModel.value.jobs.first == job) {
        //   updateCameraPosition(
        //     job.location.coordinates[1],
        //     job.location.coordinates[0],
        //   );
        // }
        allJobMarkers.add(
          Marker(
            markerId: MarkerId(job.id),
            position: LatLng(
              job.location.coordinates[1],
              job.location.coordinates[0],
            ),
            icon: icon,
            onTap: () async {
              String address = await OtherHelper.getAddressFromLatLng(
                job.location.coordinates[1],
                job.location.coordinates[0],
              );
              CustomDialog.showCustomDialog(
                Get.context!,
                image: job.coverImage,
                name: job.title,
                time: "",
                address: address,
                isLoading: isViewProfileLoading,
                onTap: () {
                  Get.toNamed(RoutesName.jobDetailScreen, arguments: job.id);
                },
              );
            },
          ),
        );
      }
    }
  }

  // Add this in MapController

  // New method to update visible markers
  void updateMarkers() {
    switch (selectedCategory.value) {
      case 0: // Business
        markers.value = List<Marker>.from(allBusinessMarkers);
        break;
      case 1: // Event
        markers.value = List<Marker>.from(allEventMarkers);
        break;
      case 2: // Job
        markers.value = List<Marker>.from(allJobMarkers);
        break;
    }
    markers.refresh();
  }
}
