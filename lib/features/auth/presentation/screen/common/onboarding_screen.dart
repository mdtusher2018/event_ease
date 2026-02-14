import 'dart:developer';

import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_images.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data for the onboarding pages
  final List<Map<String, String>> onboardingData = [
    {
      "image": AppImages.onBoardingOne,
      "title": "${AppString.planYourPerfectEventWithEase}!",
      "description": "${AppString.discoverTopVenues}!",
      "buttonText": AppString.getStarted,
    },
    {
      "image": AppImages.onBoardingTwo,
      "title": "${AppString.discoverTopEventServices}!",
      "description": AppString.exploreAndBookTheBestVenues,
      "buttonText": AppString.next,
    },
    {
      "image": AppImages.onBoardingThree,
      "title": AppString.seamlessBookingPlanning,
      "description": "${AppString.manageYourEvent}!",
      "buttonText": AppString.finish,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNextPressed() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(RoutesName.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for the onboarding pages
            PageView.builder(

              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                );
              },
            ),

            // Navigation dots at the bottom
            Positioned(
              bottom: 10, // Adjusted to match the image
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 5.h,
                    width: _currentPage == index ? 30.w : 5.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.grey, // Adjusted opacity
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Next/Finish button at the bottom
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: CustomButton(
                paddingVertical: 15.h,
                fontSize: 20,
                text: () {
                  if (_currentPage == onboardingData.length - 1) {
                    return AppString.finish;
                  } else if (_currentPage == 0) {
                    return AppString.getStarted;
                  } else {
                    return AppString.next;
                  }
                }(),
                onTap: _onNextPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    log(Get.height.toString());
    log(Get.width.toString());
    return Padding(
      padding:  EdgeInsets.only(left: 14.w, right: 14.w, bottom: 10.h, top: 140.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImage(
            imageSrc: image,
            imageType: ImageType.svg,
            width: 370.w,
            height: 237.h,
          ),
           SizedBox(height: 90.h), // Added spacing between image and title
          Center(
            child: Text(
              title,
              style: styleForBoldText.copyWith(
                fontSize: 36.sp,
                height: 1.22.h,
                color: AppColors.primary, // Purple color to match the image
              ),
              textAlign: TextAlign.center,
            ),
          ),
           SizedBox(height: 25.h),
          Text(
            description,
            style: styleForNormalText.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              height: 1.5.h,
              color: AppColors.primary, // Black color for description
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(), // Pushes content to the top, leaving space for the button and dots
        ],
      ),
    );
  }
}