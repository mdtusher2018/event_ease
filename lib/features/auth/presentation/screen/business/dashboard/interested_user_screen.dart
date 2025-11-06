
import 'dart:developer';

import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/interested_user_controller.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';

class InterestedUserScreen extends StatelessWidget {

   InterestedUserScreen({super.key});


  @override
  Widget build(BuildContext context) {
    String id=Get.arguments['id'];
    log(id+"\n\n\n");
      InterestedUsersController controller = Get.put(InterestedUsersController(id: id));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        title: Text(AppString.interestedUsers, style: styleForBoldText.copyWith(fontSize: 24),),
      ),
      body: Obx(
        () {
if(controller.interestedUsers.isEmpty){
  return Center( child: CircularProgressIndicator(),);
}

          return ListView.builder(
            itemCount: controller.interestedUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.black, width: 0.2),
                ),
                leading: CommonImage(imageSrc: controller.interestedUsers[index].user.profileImage,imageType: ImageType.network, size: 45, borderRadius: 100,),
                title: Text(controller.interestedUsers[index].user.name, style: styleForNormalText,),
              ),
            );
          },);
        }
      ),

    );
  }
}
