import 'dart:async';
import 'dart:developer';
import 'package:event_ease/features/auth/presentation/models/my_model/map_model.dart';
import 'package:event_ease/core/helper/other_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../../../../../core/routers/routes_name.dart';
import '../../../../controller/map/map_controller.dart';
import '../../../../widgets/custom_dialog.dart';

class MarkerHelper {
  static Future<List<Marker>> buildMarkersFromModel(
      MapModel mapModel,
      GoogleMapController mapController,
      ) async {
    final List<Marker> newMarkers = [];

    for (final business in mapModel.businesses) {
      final icon = await MapController().getCustomMarkerIcon(business.coverImage);
      newMarkers.add(
        Marker(
          markerId: MarkerId(business.id),
          position: LatLng(
            business.location.coordinates[1],
            business.location.coordinates[0],
          ),
          icon: icon,
          consumeTapEvents: true,
          onTap: () async {
            log('Business tapped: ${business.name}');
            final address = await OtherHelper.getAddressFromLatLng(
              business.location.coordinates[1],
              business.location.coordinates[0],
            );
            CustomDialog.showCustomDialog(
              Get.context!,
              image: business.coverImage,
              name: business.name,
              time: '',
              address: address,
              isLoading: false.obs,
              onTap: () => Get.toNamed(RoutesName.businessDetail, arguments: business.id),
            );
          },
        ),
      );
    }

    for (final event in mapModel.events) {
      final icon = await MapController().getCustomMarkerIcon(event.coverImage);
      newMarkers.add(
        Marker(
          markerId: MarkerId(event.id),
          position: LatLng(
            event.location.coordinates[1],
            event.location.coordinates[0],
          ),
          icon: icon,
          consumeTapEvents: true,
          onTap: () async {
            log('Event tapped: ${event.name}');
            final address = await OtherHelper.getAddressFromLatLng(
              event.location.coordinates[1],
              event.location.coordinates[0],
            );
            CustomDialog.showCustomDialog(
              Get.context!,
              image: '${event.coverImage}',
              name: event.name,
              isLoading: false.obs,
              time: '',
              address: address,
              onTap: () => Get.snackbar('Success', 'Event Profile Details'),
            );
          },
        ),
      );
    }

    return newMarkers;
  }
}
