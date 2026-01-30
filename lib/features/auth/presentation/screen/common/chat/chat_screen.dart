import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/controller/chat/chatting_controller.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/chat_model.dart';
import 'package:event_ease/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/helper/other_helper.dart';
import '../../../../../../core/routers/routes_name.dart';
import '../../../controller/chat/chat_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_search_field.dart';
import '../../../widgets/regular/custom_chat_list_tile.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    controller.getChatListDetails();
    controller.initializeChat();

    log(">>>>>>>>>>>>>>>>>> Socket status ${SocketServices.socket.connected}");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          AppString.chat,
                          style: styleForBoldText.copyWith(
                            fontSize: 24.h,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomSearchField(
                          prefixIcon: Icon(Icons.search, size: 20.r),
                          hintText: AppString.search,
                          controller: controller.searchCtl.value,
                          onChanged: (value) {
                            setState(() {
                              controller.searchUsersByFullName(value);
                            });
                          },
                        ),

                        SizedBox(height: 10.h),

                        // Chat List View
                        Expanded(
                          child:
                              (controller.chatListData.isEmpty)
                                  ? Center(
                                    child: Text(
                                      "No Chat Found".tr,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 21,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,

                                    itemCount:
                                        controller.searchCtl.value.text.isEmpty
                                            ? controller.chatListData.length
                                            : controller.filterUsers.length,
                                    itemBuilder: (context, index) {
                                      ChatModel data =
                                          controller
                                                  .searchCtl
                                                  .value
                                                  .text
                                                  .isEmpty
                                              ? controller.chatListData[index]
                                              : controller.filterUsers[index];

                                      final user =
                                          data.chat.users.isNotEmpty
                                              ? data.chat.users[0]
                                              : null;

                                      return InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            RoutesName.chatting,
                                            arguments: {
                                              "chatId": data.chat.id,
                                              'isAdmin': user?.role == "admin",
                                              "name":
                                                  user?.role == "admin"
                                                      ? data.chat.chatName
                                                      : (PrefsHelper.userId ==
                                                          data
                                                              .chat
                                                              .contextOwner)
                                                      ? data.chat.userName
                                                      : data.chat.chatName,
                                              "chatName":
                                                  user?.role == "admin"
                                                      ? ""
                                                      : (PrefsHelper.userId !=
                                                          data
                                                              .chat
                                                              .contextOwner)
                                                      ? ""
                                                      : data.chat.chatName,
                                              "image":
                                                  ((PrefsHelper.userId ==
                                                          data
                                                              .chat
                                                              .contextOwner)
                                                      ? "${user?.profileImage}"
                                                      : data.chat.chatImage),
                                              "closed":
                                                  data.chat.status == "closed",
                                            },
                                          );

                                          ChattingController.instance
                                              .getMessage();
                                        },
                                        child: CustomChatListTile(
                                          isClosed:
                                              data.chat.status == "closed",
                                          bgColor:
                                              user?.role == "admin"
                                                  ? AppColors.textFieldBg
                                                  : Colors.transparent,
                                          borderColor:
                                              user?.role == "admin"
                                                  ? AppColors.primary
                                                  : Colors.transparent,
                                          profileImage:
                                              ((PrefsHelper.userId ==
                                                      data.chat.contextOwner)
                                                  ? "${user?.profileImage}"
                                                  : data.chat.chatImage),
                                          name:
                                              user?.role == "admin"
                                                  ? data.chat.chatName
                                                  : (PrefsHelper.userId ==
                                                      data.chat.contextOwner)
                                                  ? data.chat.userName
                                                  : data.chat.chatName,
                                          chatname:
                                              user?.role == "admin"
                                                  ? ""
                                                  : (PrefsHelper.userId !=
                                                      data.chat.contextOwner)
                                                  ? ""
                                                  : data.chat.chatName,
                                          msg:
                                              data.message.isNotEmpty
                                                  ? data.message
                                                  : "New connection",
                                          time:
                                              data
                                                      .lastMessageCreatedAt
                                                      .isNotEmpty
                                                  ? OtherHelper.formatTo12Hour(
                                                    data.lastMessageCreatedAt,
                                                  )
                                                  : OtherHelper.formatTo12Hour(
                                                    data.chat.createdAt,
                                                  ),
                                        ),
                                      );
                                    },
                                  ),
                        ),

                        SizedBox(height: 90.h),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
