// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/common_image.dart';


class ImageViewerScreen extends StatelessWidget {
  ImageViewerScreen({super.key});

  var image = Get.arguments["image"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        child: Center(
          child: SizedBox(
            height: Get.height / 2.8 ,
            width: Get.width,
            child: CommonImage(
              height: Get.height,
              width: Get.width,
              imageType: ImageType.network,
              borderRadius: 0,
              imageSrc: image,
              fill: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}