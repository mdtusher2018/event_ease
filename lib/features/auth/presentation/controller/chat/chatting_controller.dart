import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/data/repository/chat_repository.dart';
import 'package:event_ease/features/auth/presentation/controller/chat/chat_controller.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helper/prefs_helper.dart';
import '../../../../../services/socket_service.dart';
import '../../models/my_model/chatting_model.dart';

class ChattingController extends GetxController {
  static ChattingController get instance => Get.find<ChattingController>();

  RxBool isLoading = false.obs;
  final Rx<TextEditingController> msgController = TextEditingController().obs;
  final ScrollController scrollController = ScrollController();

  ChatRepository chatRepository = ChatRepository();
  RxList<ChattingModel> messages = <ChattingModel>[].obs;

  RxString chatId = "".obs;
  RxString name = "".obs;
  RxString chatname = "".obs;
  RxBool isAdmin = false.obs;

  RxString image = "".obs;
  RxBool closed=false.obs;

  RxList<String> uploadedImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    chatId.value = Get.arguments['chatId']??"";
    name.value = Get.arguments['name']??"";
    image.value = Get.arguments['image']??"";
    closed.value=Get.arguments['closed']??false;
    chatname.value=Get.arguments['chatName']??"";
    isAdmin.value=Get.arguments['isAdmin']??false;
    _initializeChat();
    
  }

  void _initializeChat() async {
    if (!SocketServices.socket.connected) {
      SocketServices.connectToSocket();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    await getChattingData();
    getMessage();
    chatConnect();
  }

  Future<void> getChattingData() async {
    isLoading.value = true;
    try {
      var response = await chatRepository.getChatMsg(chatId.value);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> rawData = response.data;
        messages.clear();
        for (var data in rawData) {
          messages.add(
            ChattingModel(
              text: data["text"] ?? "",
              images: data["images"] ?? [],
              sender: data["sender"],
              createdAt: data["createdAt"],
            ),
          );
        }

        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        scrollToBottom();
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }






  Future<void> chatConnect() async {

    try {
      if (SocketServices.socket.connected == false) {
        SocketServices.connectToSocket();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final data = {
      "userId": PrefsHelper.userId
      };


      SocketServices.socket.emitWithAck(
        "chatConnected",
        data,ack: (response){}
      );
      log("Chat Connected");
    } catch (error, stackTrace) {
      log("Send Message Error: $error\n$stackTrace");
    }
  }



  Future<void> chatDisConnect() async {

    try {
      if (SocketServices.socket.connected == false) {
        SocketServices.connectToSocket();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final data = {
      "userId": PrefsHelper.userId
      };


      SocketServices.socket.emitWithAck(
        "chatDisConnected",
        data,ack: (response){}
      );
      log("Chat DisConnected");
    } catch (error, stackTrace) {
      log("Send Message Error: $error\n$stackTrace");
    }
  }





  Future<void> sendMessage({required String chatId,required String name,required String image}) async {
    final messageText = msgController.value.text.trim();
    if (messageText.isEmpty && uploadedImages.isEmpty) return;

    try {
      if (SocketServices.socket.connected == false) {
        SocketServices.connectToSocket();
        log("Socket ttt========${SocketServices.socket.connected}");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final data = {
        "text": messageText,
        "images": uploadedImages,
        "sender":PrefsHelper.userId,
        "sendenName":name,
        "senderImage":image,
        "chatId": chatId,
      };
      log("sendmessagedata========$data");
      log("Socket========${SocketServices.socket.connected}");

      SocketServices.socket.emitWithAck(
        "send-message",
        data,
        ack: (response) {
          log("Sending Response: $response");
          String userId = PrefsHelper.userId;
          log("PrefsHelper.userId : $userId");
          if (response != null && response['success'] == true) {
            messages.add(
              ChattingModel(
                text: response["message"]["message"],
                images: response["message"]["images"],
                sender: userId,
                createdAt: response["message"]["createdAt"],
              ),
            );
            scrollToBottom();

            msgController.value.clear();
            uploadedImages.clear();
          } else {
            Get.snackbar('Error', 'Failed to send message');
          }
        },
      );
      SocketServices.socket.emitWithAck("my-chat-list", {}, ack: (response) {});
    } catch (error, stackTrace) {
      log("Send Message Error: $error\n$stackTrace");
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  Future<void> pickFile() async {
    final pickedImages = await OtherHelper.pickMultipleImage(
      ImageSource.gallery,
    );
    log("pickedImages===========$pickedImages");

    if (pickedImages.isNotEmpty) {
      uploadFiles(pickedImages);
    }
  }

  Future<void> uploadFiles(List<String> files) async {
    log("filesImages===========$files");
    isLoading.value = true;
    try {
      Map<String, String> body = {};
      List<MultipartBody> multipartBody = <MultipartBody>[];

      for (var filePath in files) {
        multipartBody.add(MultipartBody("images", File(filePath)));
      }

      final response = await chatRepository.postFile(
        body: body,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Success");
        final List<dynamic> uploaded = response.data;
        uploadedImages.assignAll(uploaded.map((e) => e.toString()).toList());
        log("Uploaded URLs: $uploadedImages");
      } else {
        Get.snackbar("Upload Failed", response.message);
      }
    } catch (e, s) {
      log("Upload Error: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMessage() async {
    if (SocketServices.socket.connected) {
      SocketServices.socket.off("message_received");

      SocketServices.socket.on("message_received", (data) {
        if (data != null) {
          messages.add(
            ChattingModel(
              text: data["message"] ?? "",
              images: data["images"] ?? [],
              sender: data["sender"],
              createdAt: data["createdAt"],
            ),
          );
          messages.refresh();
          scrollToBottom();
        }
      });
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    if (ChatController.instance.chatId.value.isNotEmpty) {
      SocketServices.socket.off(
        "receive_message::${ChatController.instance.chatId.value}",
      );
    }
    msgController.value.dispose();
    scrollController.dispose();
    chatDisConnect();
    super.onClose();
  }
}
