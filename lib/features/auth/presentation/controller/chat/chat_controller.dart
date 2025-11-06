import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../../models/my_model/chat_model.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  RxString chatId = "".obs;
  RxString sureName = "".obs;
  RxString profileImage = "".obs;

  UserRepository userRepository = UserRepository();
  RxBool isLoading = false.obs;
  RxList<ChatModel> chatListData = <ChatModel>[].obs;


  Rx<TextEditingController> searchCtl = TextEditingController().obs;
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 300));
  RxBool isFilter = false.obs;
  RxList filterUsers = [].obs;

  void searchUsersByFullName(String query) {
    isFilter(true);

    _debouncer(() {
      if (query.isEmpty) {
        isFilter(false);
      } else {
        final result = chatListData.where((chat) {
          if (chat.chat.users.isNotEmpty) {
            final name = chat.chat.users[0].sureName.toLowerCase();
            return name.contains(query.toLowerCase());
          }
          return false;
        }).toList();

        filterUsers.assignAll(result);
        isFilter(false);
      }
    });
  }

  Future<void> getChatListDetails() async {
    isLoading.value = true;
    try {
      var response = await userRepository.getChatList();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = response.data ?? [];
        chatListData.value = data.map((e) => ChatModel.fromJson(e)).toList();
        log(">>>>>>>>>>>>>>Chat detail : $chatListData");
        log(">>>>>>>>>>>>>> ${response.message}");
      } else {
        log(">>>>>>>>>>>>>>Error : ${response.message}");
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>>>>>>>>>>>>> e :$e");
      log(">>>>>>>>>>>>>>>> s :$s");
    } finally {
      isLoading.value = false;
    }
  }

  void initializeChat() async {
    log("socket Status=============${SocketServices.socket.connected}");

    if (SocketServices.socket.connected) {
      SocketServices.socket.on("active-users", (data) {
        print("================> get Data on socket for active user: $data");
        if(data != null){
          List activeUser = data["data"];
          for (String activeId in activeUser) {
            for (ChatModel chatModel in chatListData) {
              bool isMatch = chatModel.chat.users.any((user) => user.id == activeId);
              if (isMatch) {
                chatModel.isActive.value = true;
                log("active user====${chatModel.isActive.value}");
              } else {
                chatModel.isActive.value = false;
                log("inactive user====${chatModel.isActive.value}");
              }
            }
          }


        }
      });
    } else {
      debugPrint("Socket not connected or not initialized.");
    }
  }

  @override
  void onClose() {
    searchCtl.value.dispose();
    super.onClose();
  }
}
