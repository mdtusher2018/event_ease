import 'dart:developer';

import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import 'common_image.dart';

class CustomDialog {
  static void showCustomDialog(BuildContext context,
      {required String image, required String name, required String address, required String time, Function()? onTap, RxBool? isLoading}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SizedBox(
          width: 150.w,
          child: Center(
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5.0,
              child: AnimatedDialogContent(
                image: image,
                name: name,
                time: time,
                address: address,
                isLoading: isLoading,
                onTap: onTap,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class AnimatedDialogContent extends StatelessWidget {
  String image;
  String name;
  String address;
  String time;
  RxBool? isLoading;
  Function()? onTap;
  AnimatedDialogContent(
      {super.key,
        required this.image,
        required this.name,
        required this.time,
         this.onTap,
        this.isLoading,
        required this.address});

  @override
  Widget build(BuildContext context) {
    log(">>>>>>>>>>>>>>>>>>>>> Name : ========== $name");
    return Container(
        height: 500.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: SvgPicture.asset(AppIcons.cancelIcon, height: 24, width: 24),
                ),
              ),
            ),


            Align(
              alignment: Alignment.center,
              child: CommonImage(
                imageSrc: image,
                imageType: ImageType.network,
                height: 180.h,
                width: 260.w,
                borderRadius: 20.r,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              name,
              style: styleForBoldText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black
              )
            ),
            SizedBox(height: 5,),
            Text(
              address,
              style: styleForNormalText.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey
              ),
            ),
            SizedBox(height: 10,),
            Text(
              time,
              style:  styleForNormalText.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary
              ),
            ),
            SizedBox(height: 10,),
            Obx(() => CustomButton(
              text: "View Details",
              onTap: onTap,
              isLoading: isLoading?.value ?? false,
            ))

          ],
        ));
  }
}