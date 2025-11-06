import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';

class BusinessHomePageRepository {
  Future<ApiResponse> getAllBusiness(String? name,double long,double lat) async {//&longitude=$long&latitude=$lat
    final response = await ApiService.to.getApi((name!=null)?"${AppUrl.getAllBusiness}?microCatogory=$name&longitude=$long&latitude=$lat&limit=10000":AppUrl.getAllBusiness);
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }



Future<ApiResponse> getExtraEventData(String eventId) async {
  final response = await ApiService.to.getApi("${AppUrl.baseUrl}/event/extra/$eventId");
  return response;
}






  Future<ApiResponse> getBusinessDetailsById(String id) async {
    final response = await ApiService.to.getApi(
      AppUrl.getBusinessDetailsById(id),
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }
  Future<ApiResponse> postBusinessLikeById(String id) async {
    final response = await ApiService.to.postApi(
      AppUrl.getBusinessDetailsById(id),{
        
      }
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }

  Future<ApiResponse> getExtraBusinessDetailsById(String id) async {
    final response = await ApiService.to.getApi(
      AppUrl.getExtraBusinessDetailsById(id),
    );
    log(">>>>Extra Business Response : $response");
    log(">>>>Extra Business Response Body : ${response.toString()}");
    return response;
  }


  Future<ApiResponse> getEventDetailsById(String id) async {
    final response = await ApiService.to.getApi(
      AppUrl.geEventDetailsById(id),
    );
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
  }





  Future<ApiResponse> getProviderCategories() async {
    final response = await ApiService.to.getApi(
      AppUrl.categoryProvider,
    ); // Replace with actual path
    return response;
  }

    Future<ApiResponse> getEventCategories() async {
    final response = await ApiService.to.getApi(
      AppUrl.categoryEvent,
    ); // Replace with actual path
    return response;
  }

    Future<ApiResponse> getJobCategories() async {
    final response = await ApiService.to.getApi(
      AppUrl.categoryJob,
    ); // Replace with actual path
    return response;
  }


  Future<ApiResponse> getALLSubscriptionEvents(double long,double lat) async {
    final response = await ApiService.to.getApi("${AppUrl.getAllSubscriptionEvent}?longitude=$long&latitude=$lat&limit=10000");
    log(">>>> Business Response : $response");
    log(">>>> Business Response Body : ${response.toString()}");
    return response;
    
  }


    Future<ApiResponse> getALLEvents(double long,double lat) async {
    final response = await ApiService.to.getApi("${AppUrl.getAllEvent}?longitude=$long&latitude=$lat&limit=10000");
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




Future<ApiResponse> likeBusiness({required String businessId}) async {
    final body = {
      "businessId": businessId,
    };

    final response = await ApiService.to.postApi(
      "${AppUrl.baseUrl}/business/like",
      body,
    );

    log(">>>> Like Business Response : ${response.data}");
    return response;
  }
}
