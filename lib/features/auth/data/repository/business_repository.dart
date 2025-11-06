import 'dart:developer';

import '../../../../services/api_service.dart';
import '../../presentation/utils/app_url.dart';

class BusinessRepository {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Provider business >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getProviderType() async {
    final url = AppUrl.providerType;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Supported Service  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postFindProviderType({var body}) async {
    final url = AppUrl.findProvider;
    log("Support Service URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Supported Service  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getSupportedServiceType() async {
    final url = AppUrl.supportedService;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Additional Service  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getAdditionalServiceType() async {
    final url = AppUrl.extraServices;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create Complete Business >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> createCompleteBusiness({
    var body,
    var multipartBody,
    var header,
  }) async {
    final url = AppUrl.businessCreate;
    log("Support Service URL: $url");
    final response = await ApiService.to.multipartData(
      url,
      body,
      multipartBody: multipartBody,
      extraHeaders: header,
      showMessage: true,
    );
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create Chat  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> createChat(Map<String, dynamic> body) async {
    final url = AppUrl.createChat;
    log(" URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create Blog >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> createBlog({
    var body,
    var multipartBody,
    var header,
  }) async {
    final url = AppUrl.inspirationCreate;
    log(" Service URL: $url");
    final response = await ApiService.to.multipartData(
      url,
      body,
      multipartBody: multipartBody,
      extraHeaders: header,
      showMessage: true,
    );
    log(">>>> Response : $response");
    return response;
  }


  Future<ApiResponse> updateBlog({
  required String blogId,
  var body,
  var multipartBody,
  var header,
}) async {
  final url = AppUrl.inspirationUpdate(blogId); // 👈 append id
  log(" Service URL (PATCH): $url");

  final response = await ApiService.to.multipartData(
    url,
    body,
    multipartBody: multipartBody,
    extraHeaders: header,
    showMessage: true,
    method: "PATCH", // 👈 tell ApiService to use PATCH
  );

  log(">>>> Update Response : $response");
  return response;
}


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get inspiration my post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getInspirationMyPOst() async {
    final url = AppUrl.inspirationMyPost;
    log(" Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> patch interest  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> patchInterest(
    Map<String, dynamic> body, {
    required String id,
  }) async {
    final url = AppUrl.getCreateInterest(id);
    log(" URL: $url");
    final response = await ApiService.to.patchApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Notification Count  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getNotificationCount(String type, String id) async {
    final url = AppUrl.notificationCount(type, id);
    log(" Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }
}
