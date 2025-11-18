import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';

class GuestHomePageRepository {
  Future<ApiResponse> getAllBusiness(
    String? name,
    double long,
    double lat,
  ) async {
    //&longitude=$long&latitude=$lat
    final response = await ApiService.to.getApi(
      (name != null)
          ? "${AppUrl.getAllGuestBusiness}?microCatogory=$name&longitude=$long&latitude=$lat&limit=10000"
          : AppUrl.getAllGuestBusiness,
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }

  Future<ApiResponse> getALLSubscriptionEvents(double long, double lat) async {
    final response = await ApiService.to.getApi(
      "${AppUrl.getAllGuestSubscriptionEvent}?longitude=$long&latitude=$lat&limit=10000",
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }

  Future<ApiResponse> getALLEvents(double long, double lat) async {
    final response = await ApiService.to.getApi(
      "${AppUrl.getGuestAllEvent}?longitude=$long&latitude=$lat&limit=10000",
    );
    // final response = await ApiService.to.getApi("${AppUrl.getAllEvent}?longitude=12.1607116&latitude=42.0979882&limit=10000");
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }

  Future<ApiResponse> getALLInspirationCategory() async {
    final response = await ApiService.to.getApi(
      AppUrl.getAllInspirationCategory,
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }
}
