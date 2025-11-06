import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../utils/app_string.dart';

class LocationSelectionPage extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onLocationSelected;

  const LocationSelectionPage({
    super.key,
    required this.onNext,
    required this.onLocationSelected,
  });

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final TextEditingController locationController = TextEditingController();
  WizardController wizardController = Get.find<WizardController>();
  String? selectedLocation;
  bool noSpecificLocation = false;
  int? selectedIndex = 0;
  final List<String> cities = [
    "Rome",
    "Milan",
    "Florence",
    "Venice",
    "Bologna",
    "Naples",
  ];
  RxString city = "".obs;
  bool allowScroll = true; // <-- new state to control scroll
  GoogleMapController? _mapController;

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        // Build a readable address
        String address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        updateCityFromAddress(address);
        // save in your controller
        wizardController.searchCtl.value.text = address;

        wizardController.state.value =
            place.name ??
            "${place.locality}"; // Sets the displayed state or locality
        wizardController.city.value =
            place.administrativeArea ?? ""; // Updates city
        wizardController.town.value = place.country ?? ""; // Updates town

        print("Address: $address");
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  }

  void updateCityFromAddress(String address) {
    final parts = address.split(',').map((e) => e.trim()).toList();
    city.value = parts.length > 1 ? parts[1] : "";
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.only(left: 14, right: 14, top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.grey, width: 0.4),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "${AppString.whereWillTheEventTakePlace}?",
                            style: styleForBoldText.copyWith(fontSize: 24.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Places Tab
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildTabButton("Rome ", 0),
                              _buildTabButton("Milan", 1),
                              _buildTabButton("Florence", 2),
                              _buildTabButton("Venice", 3),
                              _buildTabButton("Bologna", 4),
                              _buildTabButton("Naples", 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Google Map with interaction handling
                        GestureDetector(
                          onPanDown: (_) {
                            setState(() {
                              allowScroll = false;
                            });
                          },
                          onPanCancel: () {
                            setState(() {
                              allowScroll = true;
                            });
                          },
                          onPanEnd: (_) {
                            setState(() {
                              allowScroll = true;
                            });
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Listener(
                                onPointerDown: (_) {
                                  wizardController.allowPageSwipe.value = false;
                                },
                                onPointerUp: (_) {
                                  wizardController.allowPageSwipe.value = true;
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: GoogleMap(
                                          onMapCreated: (controller) {
                                            _mapController = controller;
                                          },

                                          initialCameraPosition:
                                              wizardController
                                                  .initialCameraPosition
                                                  .value,
                                          // myLocationEnabled: true,
                                          myLocationButtonEnabled: true,

                                          zoomGesturesEnabled: true,
                                          scrollGesturesEnabled: true,

                                          tiltGesturesEnabled: true,
                                          rotateGesturesEnabled: true,

                                          markers: Set<Marker>.of(
                                            wizardController.markers,
                                          ),
                                          gestureRecognizers: <
                                            Factory<
                                              OneSequenceGestureRecognizer
                                            >
                                          >{
                                            Factory<
                                              OneSequenceGestureRecognizer
                                            >(() => EagerGestureRecognizer()),
                                          },
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () async {
                                          // 1. Get current location
                                          Position position =
                                              await Geolocator.getCurrentPosition();

                                          // 3. Convert to CameraPosition
                                          final newCameraPosition =
                                              CameraPosition(
                                                target: LatLng(
                                                  position.latitude,
                                                  position.longitude,
                                                ),
                                                zoom: 16,
                                              );

                                          // 4. Get address
                                          getAddressFromLatLng(
                                            position.latitude,
                                            position.longitude,
                                          );

                                          // 5. Add marker
                                          wizardController.markers.clear();
                                          wizardController.markers.add(
                                            Marker(
                                              markerId: const MarkerId(
                                                'current_location',
                                              ),
                                              position: LatLng(
                                                position.latitude,
                                                position.longitude,
                                              ),
                                              infoWindow: const InfoWindow(
                                                title: 'My Location',
                                              ),
                                            ),
                                          );

                                          // 6. Move camera
                                          if (_mapController != null) {
                                            await _mapController!.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                newCameraPosition,
                                              ),
                                            );
                                          }
                                          setState(() {
                                            selectedIndex = null;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.my_location,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location summary box
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Center(
                                child: Text(
                                  selectedIndex != null
                                      ? "Within ${wizardController.distance.toInt()} km of ${cities[selectedIndex!]}"
                                      : "Within ${wizardController.distance.toInt()} ${(city.isNotEmpty) ? "km of ${city.value}" : ""}",
                                  style: styleForNormalText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }),

                            Slider(
                              value: wizardController.distance.value,
                              min: 1,
                              max: 100,
                              divisions: 99,
                              activeColor: Theme.of(context).primaryColor,
                              inactiveColor: Colors.grey.shade300,
                              label:
                                  "${wizardController.distance.value.toInt()} km",
                              onChanged: (value) {
                                setState(() {
                                  wizardController.distance.value = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // TextField
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBg,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),

                          child: GooglePlaceAutoCompleteTextField(
                            textEditingController:
                                wizardController.searchCtl.value,
                            focusNode: FocusNode(),
                            googleAPIKey: AppUrl.googleMapPlaceKey,
                            boxDecoration: BoxDecoration(
                              border: Border.all(width: 0),
                            ),
                            inputDecoration: InputDecoration(
                              hintText: AppString.searchLocation,
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            debounceTime: 800,

                            isCrossBtnShown: false,
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (prediction) {
                              final lat = double.parse("${prediction.lat}");
                              final lng = double.parse("${prediction.lng}");
                              wizardController.latitude.value =
                                  prediction.lat.toString();
                              wizardController.longitude.value =
                                  prediction.lng.toString();

                              wizardController.markers.clear();
                              wizardController.markers.add(
                                Marker(
                                  markerId: MarkerId('selected_location'),
                                  position: LatLng(lat, lng),
                                  infoWindow: InfoWindow(
                                    title: 'Selected Location',
                                  ),
                                ),
                              );

                              _mapController?.animateCamera(
                                CameraUpdate.newLatLng(LatLng(lat, lng)),
                              );
                              log(
                                "lat=======${wizardController.latitude.value}\nlng=============${wizardController.longitude.value}",
                              );
                              log(wizardController.searchCtl.value.text+"=========>>>>>>>>> searchCtl");

                              // getAddressFromLatLng(lat, lng);
                              
                            },
                            itemClick: (prediction) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              wizardController.searchCtl.value.text =
                                  prediction.description!;
                              wizardController.latitude.value =
                                  prediction.lat.toString();
                              wizardController.longitude.value =
                                  prediction.lng.toString();
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // No specific location
                        GestureDetector(
                          onTap: () {
                            widget.onNext();
                            wizardController.latitude.value = "";
                            wizardController.longitude.value = "";
                            wizardController.searchCtl.value.clear();

                            log(
                              "lat=======${wizardController.latitude.value}\nlng=============${wizardController.longitude.value}",
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0xFFE1E1E1),
                                ),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 40,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              AppString.iDoNotHaveSpecificLocation,
                              style: styleForNormalText.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 180),

                  // NEXT button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppString.next,
                        style: styleForBoldText.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            selectedIndex = index;
          });
          wizardController.manageCountryLatLng(index: index);

          final newCameraPosition =
              wizardController.initialCameraPosition.value;

          final LatLng targetLatLng =
              wizardController.initialCameraPosition.value.target;

          

          wizardController.markers.clear();
          wizardController.markers.add(
            Marker(
              markerId: MarkerId('selected_location'),
              position: targetLatLng,
              infoWindow: InfoWindow(title: 'Selected Location'),
            ),
          );
          if (_mapController != null) {
            await _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(newCameraPosition),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        ),
        child: Text(
          text,
          style: styleForBoldText.copyWith(
            fontSize: 14.sp,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
