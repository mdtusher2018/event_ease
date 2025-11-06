import 'package:get/get.dart';

class ChatModel {
  Chat chat;
  String message;
  RxBool isActive = false.obs;
  int unreadMessageCount;
  String lastMessageCreatedAt;

  ChatModel({
    Chat? chat,
    this.message = '',
    RxBool? isActive,
    this.unreadMessageCount = 0,
    this.lastMessageCreatedAt = '',
  }): chat = chat ?? Chat(),
        isActive = isActive ?? false.obs;

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chat: Chat.fromJson(json['chat'] ?? {}),
      message: json['message'] ?? '',
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
      lastMessageCreatedAt: json['lastMessageCreatedAt'] ?? '',
    );
  }
}


class Chat {
  String id;
  String userName;
  String chatName;
  String chatImage;
  String? contextOwner;
  String? contextType;
  String? contextId;
  String status;
  String chatType;
  List<ChatUser> users;
  String createdBy;
  bool isGroupChat;
  int unreadCounts;
  dynamic blockedUsers; // can be null
  String createdAt;
  String updatedAt;
  int v;

  Chat({
    this.id = '',
    this.userName = '',
    this.chatName = '',
    this.chatImage="",
    this.contextOwner,
    this.contextType,
    this.contextId,
    this.status = '',
    this.chatType = '',
    this.users = const [],
    this.createdBy = '',
    this.isGroupChat = false,
    this.unreadCounts = 0,
    this.blockedUsers,
    this.createdAt = '',
    this.updatedAt = '',
    this.v = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      chatName: json['chatName'] ?? '',
      chatImage: json['chatImage']??"",
      contextOwner: json['contextOwner'],
      contextType: json['contextType'],
      contextId: json['contextId'],
      status: json['status'] ?? '',
      chatType: json['chatType'] ?? '',
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => ChatUser.fromJson(e))
              .toList() ??
          [],
      createdBy: json['createdBy'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,
      unreadCounts: json['unreadCounts'] ?? 0,
      blockedUsers: json['blockedUsers'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
class ChatUser {
  String id;
  String sureName;
  String name;
  String email;
  String profileImage;
  String role;

  ChatUser({
    this.id = '',
    this.sureName = '',
    this.name = '',
    this.email = '',
    this.profileImage = '',
    this.role = '',
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'] ?? '',
      sureName: json['sureName'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
