import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/routers/routes_name.dart';
import '../../../../utils/app_images.dart';
import '../../../../widgets/common_image.dart';


class EventProfileScreen extends StatelessWidget {
  const EventProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Marco & Lisa", style: styleForBoldText,),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'report') {
                Get.toNamed(RoutesName.report);
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "report",
                child: Row(
                  children: [
                    Icon(
                      Icons.report,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(
                        width: 10), // Add space between icon and text
                    Text(AppString.report, style: styleForNormalText),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonImage(imageSrc: AppImages.serviceCoverImage, imageType: ImageType.network, width: double.infinity, height: 180,),
        );
      },),
    );
  }
}
