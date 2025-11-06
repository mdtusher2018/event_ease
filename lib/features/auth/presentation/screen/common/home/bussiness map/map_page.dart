import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPreview extends StatelessWidget {
  final double lat;
  final double lng;

  const MapPreview({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    log("==================== $lat \n $lng");
    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14,
    );

    return SizedBox(
      height: 218,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: {
          Marker(
            markerId: const MarkerId("selected-location"),
            position: LatLng(lat, lng),
          ),
        },
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
