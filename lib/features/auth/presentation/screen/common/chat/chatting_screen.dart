import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/controller/chat/chat_controller.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/chatting_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/helper/other_helper.dart';
import '../../../controller/chat/chatting_controller.dart';
import '../../../widgets/common_image.dart';

class ChattingScreen extends StatelessWidget {
  ChattingScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ChattingController controller = Get.find<ChattingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Obx(
              () => CommonImage(
                imageSrc: controller.image.value,
                imageType: ImageType.network,
                height: 50.h,
                width: 45.w,
                borderRadius: 100,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.name.value,
                      style: styleForBoldText.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                            
          Obx(
            () {
              if(controller.chatname.isNotEmpty){
              return Text(controller.chatname.value,style: TextStyle(fontSize: 12),);}
              return SizedBox();
            }
          )
                ],
              ),
            ),
          ],
        ),
        actions: [
      //  if (!controller.isAdmin.value)
      if(controller.chatname.isNotEmpty)
  GestureDetector(
    onTap: () async {
      if (PrefsHelper.myRole == "user") {
        return;
      }

      if (controller.closed.value) {
        Get.snackbar(
          "Info",
          "This chat is already closed.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        return; // stop execution
      }

      // ✅ Confirmation Dialog
      Get.defaultDialog(
        title: "Confirm",
        titleStyle: styleForBoldText.copyWith(color: AppColors.primary, fontSize: 21),
        middleText: "Are you sure you want to close this chat?",
        middleTextStyle: styleForNormalText.copyWith(color: Colors.black, fontSize: 18),
        radius: 12,
        barrierDismissible: false,
        textCancel: "Cancel",
        cancelTextColor: Colors.black,
        textConfirm: "Yes, Close",contentPadding: EdgeInsets.all(16),
        confirmTextColor: Colors.white,
        buttonColor: AppColors.primary,
        onConfirm: () async {
          Get.back(); // Close dialog
          final response = await ApiService.to.patchApi(
            "${AppUrl.baseUrl}/chat/dealClose/${controller.chatId}",
            {},
          );
          if (response.success) {
            controller.closed.value = true;
            Get.snackbar(
              "Success".tr,
              "Chat closed successfully",
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            );
          }else{
               Get.snackbar(
              "Failed",
              response.message,
              backgroundColor: AppColors.redPink,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            );
          }
        },
      );
    },
    child: (PrefsHelper.myRole == "user")
        ? const SizedBox()
        : Obx(() {
            return Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: controller.closed.value
                    ? Colors.green
                    : Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                  (PrefsHelper.myRole == "user") ? 50 : 8,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            );
          }),
  ),

          SizedBox(width: 8),
        ],
        leading: IconButton(
          onPressed: () {
            ChatController.instance.getChatListDetails();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                return controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: controller.scrollController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final ChattingModel data = controller.messages[index];
                        final message = data.text;
                        final currentUserId = PrefsHelper.userId;
                        final messageSender = data.sender;
                        final time = OtherHelper.formatTime(data.createdAt);
                        final isSender =
                            currentUserId.isNotEmpty &&
                            messageSender.isNotEmpty &&
                            currentUserId == messageSender;

                        return isSender
                            ? senderMsg(
                              msg: message,
                              time: time,
                              images: data.images,
                            )
                            : receiverMsg(
                              msg: message,
                              time: time,
                              images: data.images,
                            );
                      },
                    );
              }),
            ),
          ),

          /// Preview selected uploaded images (if any)
          Obx(() {
            if (controller.uploadedImages.isEmpty)
              return const SizedBox.shrink();
            return SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.uploadedImages.length,
                itemBuilder: (context, index) {
                  final imageUrl = controller.uploadedImages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              controller.uploadedImages.removeAt(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 10),
               Container(
                padding: const EdgeInsets.only(
                  left: 1,
                  right: 7,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.pickFile();
                      },
                      icon: const Icon(Icons.attach_file),
                    ),
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: controller.msgController.value,
                          validator:
                              (value) =>
                                  controller.uploadedImages.isNotEmpty
                                      ? null
                                      : OtherHelper.validator(value),
                          decoration: InputDecoration(
                            hintText: "Type a message".tr,
                            hintStyle: styleForNormalText.copyWith(
                              fontSize: 15,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate() ||
                            controller.uploadedImages.isNotEmpty) {
                          controller.sendMessage(
                            chatId: controller.chatId.value,image: (controller.chatname.isEmpty)? PrefsHelper.myImage: "",
                            name: (controller.chatname.isEmpty)? PrefsHelper.myName: controller.chatname.value,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(right:20),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          AppIcons.chat,width:44,
                          colorFilter: ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget senderMsg({
    required String msg,
    required String time,
    required List images,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: styleForBoldText.copyWith(
              fontSize: 12.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5.h),

          /// Show image grid only if images are available
          if (images.isNotEmpty)
            SizedBox(
              width: images.length > 1 ? Get.width / 1.3 : Get.width / 2,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: images.length > 1 ? 2 : 1,
                  childAspectRatio: images.length > 1 ? 1.5 : 2.2,
                  crossAxisSpacing: images.length > 1 ? 5 : 10,
                  mainAxisSpacing: images.length > 1 ? 5 : 10,
                ),
                itemBuilder: (context, index) {
                  String image = images[index];
                  return SizedBox(
                    height: 100,
                    width: 100,
                    child: InkWell(
                      onTap:
                          () => Get.toNamed(
                            RoutesName.imageViewScreen,
                            arguments: {'image': image},
                          ),
                      child: CommonImage(
                        imageSrc: image,
                        imageType: ImageType.network,
                        height: 100,
                        width: 100,
                        fill: BoxFit.cover,
                        borderRadius: 20,
                      ),
                    ),
                  );
                },
              ),
            ),

          if (images.isNotEmpty) SizedBox(height: 10),

          /// Show message bubble only if message is available
          if (msg.trim().isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Text(
                msg,
                style: styleForBoldText.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget receiverMsg({
    required String msg,
    required String time,
    required List images,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: styleForBoldText.copyWith(
                fontSize: 12.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 5.h),

            if (images.isNotEmpty)
              SizedBox(
                width: images.length > 1 ? Get.width / 1.3 : Get.width / 2,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: images.length > 1 ? 2 : 1,
                    childAspectRatio: images.length > 1 ? 1.5 : 2.2,
                    crossAxisSpacing: images.length > 1 ? 5 : 10,
                    mainAxisSpacing: images.length > 1 ? 5 : 10,
                  ),
                  itemBuilder: (context, index) {
                    String image = images[index];
                    return SizedBox(
                      height: 100,
                      width: 100,
                      child: InkWell(
                        onTap:
                            () => Get.toNamed(
                              RoutesName.imageViewScreen,
                              arguments: {'image': image},
                            ),
                        child: CommonImage(
                          imageSrc: image,
                          imageType: ImageType.network,
                          height: 100,
                          width: 100,
                          fill: BoxFit.cover,
                          borderRadius: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (images.isNotEmpty) SizedBox(height: 10),

            if (msg.trim().isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  msg,
                  style: styleForBoldText.copyWith(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
