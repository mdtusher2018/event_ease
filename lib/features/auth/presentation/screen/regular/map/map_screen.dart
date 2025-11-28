// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'dart:io';

import 'package:event_ease/features/auth/presentation/controller/map/map_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../../utils/app_url.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapController mapController = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                log("back button pressing");
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          _buildGoogleMap(),
          _buildSearchBar(context),
          _buildLoadingIndicator(),
          _buildMyLocationButton(), // ✅ added here
          _buildZoomButtons(),
        ],
      ),
    );
  }

  /// Google Map Widget
  Widget _buildGoogleMap() {
    return Obx(() {
      return GoogleMap(
        initialCameraPosition: mapController.initialCameraPosition.value,
        onMapCreated: mapController.onMapCreated,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        markers:
            mapController.selectedCategory.value == 0
                ? Set<Marker>.from(mapController.allBusinessMarkers)
                : mapController.selectedCategory.value == 1
                ? Set<Marker>.from(mapController.allEventMarkers)
                : Set<Marker>.from(mapController.allJobMarkers),
      );
    });
  }

  /// Zoom Controls (Top Right)
  Widget _buildZoomButtons() {
    return Positioned(
      bottom: 80, // adjust position
      right: 30,
      child: Column(
        children: [
          // Zoom In
          _zoomButton(
            icon: Icons.add,
            onTap: () {
              mapController.googleMapController.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
          ),

          // Zoom Out
          _zoomButton(
            icon: Icons.remove,
            onTap: () {
              mapController.googleMapController.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Reusable square button styled like default Google Maps controls
  Widget _zoomButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      top: 140,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.my_location, color: Colors.black),
        onPressed: () async {
          await goToMyLocation();
        },
      ),
    );
  }

  Future<void> goToMyLocation() async {
    mapController.isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      mapController.googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );
    } catch (e) {
      print("Error fetching location: $e");
    } finally {
      mapController.isLoading.value = false;
    }
  }

  /// Search Bar with Google Places Autocomplete
  Widget _buildSearchBar(BuildContext context) {
    return Positioned(
      top: Platform.isIOS ? 70 : 30,
      left: 20,
      right: 20,
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, size: 18),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: GooglePlaceAutoCompleteTextField(
                    containerHorizontalPadding: 10,
                    textEditingController: mapController.searchController.value,
                    googleAPIKey: AppUrl.googleMapPlaceKey,
                    debounceTime: 800,
                    focusNode: FocusNode(),
                    isLatLngRequired: true,
                    inputDecoration: InputDecoration(
                      hintText: AppString.searchLocation,
                      border: InputBorder.none,
                    ),
                    getPlaceDetailWithLatLng: (prediction) {
                      mapController.updateLocation(
                        double.parse("${prediction.lat}"),
                        double.parse("${prediction.lng}"),
                      );
                    },
                    itemClick: (prediction) {
                      FocusScope.of(context).unfocus();
                      mapController.selectedAddress.value =
                          prediction.description!;
                      mapController.searchController.value.text =
                          prediction.description!;
                    },
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton("Business", 0),
                _buildCategoryButton("Event", 1),
                _buildCategoryButton("Job", 2),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, int index) {
    final isSelected = mapController.selectedCategory.value == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: OutlinedButton(
        onPressed: () {
          mapController.selectedCategory.value = index;
          // mapController.updateMarkers();
          mapController.loadMapData();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isSelected ? Theme.of(Get.context!).primaryColor : Colors.white,
          foregroundColor:
              isSelected ? Colors.white : Theme.of(Get.context!).primaryColor,
          side: BorderSide(color: Theme.of(Get.context!).primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 28),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Loading Spinner
  Widget _buildLoadingIndicator() {
    return Obx(() {
      return mapController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink();
    });
  }

  // /// Custom Marker Popup
  // Widget _buildMarkerPopup() {
  //   return Obx(() {
  //     return SizedBox();
  //   });
  // }
}
