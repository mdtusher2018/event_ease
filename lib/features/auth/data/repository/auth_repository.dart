import 'dart:developer';
import 'package:event_ease/core/helper/prefs_helper.dart';

import '../../../../services/api_service.dart';
import '../../presentation/utils/app_url.dart';

class AuthRepository {



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Google Login >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> loginWithGoogle(var body) async {
    final response = await ApiService.to.postApi(AppUrl.googleLogin, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Sign Up >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> createUser({
    var body
  }) async {
    final response = await ApiService.to.postApi(AppUrl.createUser, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Otp >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> otp({
    var body
  }) async {
    final response = await ApiService.to.postApi(AppUrl.otp, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Resend  Otp >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> resendOtp({
    required Map<String, dynamic> body
  }) async {
    final response = await ApiService.to.patchApi(AppUrl.resendOtp, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Otp >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> newPassword({
    var body
  }) async {
    final response = await ApiService.to.patchApi(AppUrl.newPassword, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Login >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> loginUser({
    var body
  }) async {
    final response = await ApiService.to.postApi(AppUrl.login, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Forget Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> forgetPassword({
    var body
  }) async {
    final response = await ApiService.to.postApi(AppUrl.forgetPassword, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Forget Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> forgetPasswordOtp({
    var body
  }) async {
    final response = await ApiService.to.patchApi(AppUrl.forgetPasswordOtp, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Forget Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> editProfile({
    var body,
    var multipartBody,
    var header
  }) async {
    final response = await ApiService.to.multipartData(
        AppUrl.editProfile,
        body, multipartBody: multipartBody,
        extraHeaders: header,
        method: 'PATCH',

    );
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Change Password >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> changePassword({
    var body
  }) async {
    final response = await ApiService.to.patchApi(AppUrl.changePassword, body);
    log(">>>> Response : $response");
    log(">>>> Response : ${response.toString()}");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Profile >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getProfile() async {
    final url = AppUrl.myProfile;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Privacy Policy >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getPrivacyPolicy() async {
    final url = AppUrl.privacy;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Privacy Policy >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getPrivacyPolicySignUpUser() async {
    final url = AppUrl.userPrivacySignUp;

    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url,extraHeaders: {});
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Privacy Policy >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getPrivacyPolicySignUpBusiness() async {
    final url = AppUrl.businessPrivacySignUp;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Terms & Condition >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getTermsCondition() async {
    final url =(PrefsHelper.myRole=="user")? AppUrl.usertermCondition:AppUrl.termCondition;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FAQ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getFAQ() async {
    final url = AppUrl.faq;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Business Profile Data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getBusinessProfileData() async {
    final url = AppUrl.businessProfile;
    log("Support Service URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update Business Profile Data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> updateBusinessProfileData(String id, var body, var multipartBody,
      {var header}) async {
    final url = AppUrl.updateBusinessProfile+id;
    log("Support Service URL: $url");
    final response = await ApiService.to.multipartData(url, body, multipartBody: multipartBody, extraHeaders: header,method: "PATCH");
    log(">>>> Response : $response");
    return response;
  }




}