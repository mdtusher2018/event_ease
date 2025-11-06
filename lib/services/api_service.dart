import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/helper/prefs_helper.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });
}

class ApiService extends GetxService {
  static ApiService get to => Get.find<ApiService>();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getApi(
    String endpoint, {
    Map<String, String>? extraHeaders,
    bool showMessage = false,
  }) async {
    final url = Uri.parse(endpoint);
    log(">>>>>>>>>>> URL : $url");
    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(extraHeaders),
      );
      return _processResponse(response, showMessage);
    } catch (e, s) {
      log("GET failed: $e\n$s");
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postApi(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? extraHeaders,
    bool showMessage = false,
  }) async {
    final url = Uri.parse(endpoint);
    log(">>>>>>>>>>> URL : $url");
    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(extraHeaders),
        body: json.encode(body),
      );
      return _processResponse(response, showMessage);
    } catch (e, s) {
      log("POST failed: $e\n$s");
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Patch >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> patchApi(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? extraHeaders,
    bool showMessage = false,
  }) async {
    final url = Uri.parse(endpoint);
    log(">>>>>>>>>>> URL : $url");
    try {
      final response = await http.patch(
        url,
        headers: _buildHeaders(extraHeaders),
        body: json.encode(body),
      );
      return _processResponse(response, showMessage);
    } catch (e, s) {
      log("PATCH failed: $e\n$s");
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Put >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> putApi(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? extraHeaders,
    bool showMessage = false,
  }) async {
    final url = Uri.parse(endpoint);
    log(">>>>>>>>>>> URL : $url");
    try {
      final response = await http.put(
        url,
        headers: _buildHeaders(extraHeaders),
        body: json.encode(body),
      );
      return _processResponse(response, showMessage);
    } catch (e, s) {
      log("PUT failed: $e\n$s");
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Multipart Request >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<ApiResponse> multipartData(
      String uri,
      Map<String, dynamic> body, {
        required List<MultipartBody> multipartBody,
        Map<String, String>? extraHeaders,
        String method = "POST",
        bool showMessage = false,
      }) async {
    try {
      var mainHeaders = {'token': PrefsHelper.token};

      log('====> API Call: $uri\nHeader: ${extraHeaders ?? mainHeaders}');
      log('====> API Body: $body with ${multipartBody.length} files');

      var request = http.MultipartRequest(method, Uri.parse(uri));
      request.headers.addAll(extraHeaders ?? mainHeaders);

      // Add files to request
      for (MultipartBody element in multipartBody) {
        if (element.file.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
          ));
        }
      }

      // ✅ Convert body values to Strings before adding
      request.fields.addAll(
        body.map((key, value) => MapEntry(key, value.toString())),
      );


      http.Response response =
      await http.Response.fromStream(await request.send());

      return _processResponse(response, showMessage);
    } catch (e) {
      log(e.toString());
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Delete >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> deleteApi(
    String endpoint, {
    Map<String, dynamic>? body,
    var extraHeaders,
    bool showMessage = false,
  }) async {
    final url = Uri.parse(endpoint);
    log(">>>>>>>>>>> URL : $url");
    try {
      final response = await http.delete(
        url,
        headers: _buildHeaders(extraHeaders),
        body: body != null ? json.encode(body) : null,
      );
      return _processResponse(response, showMessage);
    } catch (e, s) {
      log("DELETE failed: $e\n$s");
      return _errorResponse(e, showMessage);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Header >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Map<String, String> _buildHeaders(extraHeaders) {
    log(">>>>>>>>>>>>>>> Token ${PrefsHelper.token}");
    return extraHeaders != null? extraHeaders : {
      "Content-Type": extraHeaders ?? "application/json",
      "token": PrefsHelper.token,
    };
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Process Response >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ApiResponse _processResponse(http.Response response, bool showMessage) {
    log("StatusCode: ${response.statusCode}");
    log("ResponseBody: ${response.body}");
    try {
      final decoded = json.decode(response.body);
      final success =
          (response.statusCode >= 200 && response.statusCode < 300) &&
          (decoded['status'] == 'OK' ||
              decoded['status'] == 'success' ||
              decoded['success'] == true);

      final message = decoded['message'] ?? 'Request completed';
      final data = decoded['data'] ?? decoded;

      return ApiResponse(
        success: success,
        message: message,
        data: data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (showMessage) {
        Get.snackbar(
          'Error',
          'Failed to parse response',
          backgroundColor: Get.theme.colorScheme.errorContainer,
          snackPosition: SnackPosition.TOP,
        );
      }
      return ApiResponse(
        success: false,
        message: 'Failed to parse response',
        data: null,
        statusCode: response.statusCode,
      );
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Error Response >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ApiResponse _errorResponse(dynamic error, bool showMessage) {
    if (showMessage) {
      Get.snackbar(
        'Error',
        error.toString(),
        backgroundColor: Get.theme.colorScheme.errorContainer,
        snackPosition: SnackPosition.TOP,
      );
    }
    return ApiResponse(
      success: false,
      message: error.toString(),
      data: null,
      statusCode: 0,
    );
  }

}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

