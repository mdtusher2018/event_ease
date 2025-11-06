import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';

import '../../../../services/api_service.dart';
import '../../presentation/utils/app_url.dart';

class ChatRepository {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get chat >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getChatMsg(String chatId) async {
    final url = "${AppUrl.chatMsg}$chatId";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post file in chat  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postFile({body, multipartBody}) async {
    final url = AppUrl.chatFileUpload;
    log("Provider URL: $url");
    final response = await ApiService.to.multipartData(url,body, multipartBody: multipartBody, extraHeaders: {
      "token":PrefsHelper.token,
      "Content-Type": "application/json",
    });
    log(">>>> Response : $response");
    return response;
  }


}
