// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/controller/profile/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditController controller = Get.find<EditController>();

  // Observable to track notification switch state
  final RxBool notificationsEnabled = false.obs;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    notificationsEnabled.value = status.isGranted;
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      notificationsEnabled.value = status.isGranted;
    } else {
      openAppSettings(); // Can't revoke programmatically
      notificationsEnabled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          AppString.editProfile,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Column(
        children: [
          /// **Profile Content with Scrolling**
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// **Profile Picture with Edit Icon**
                  Stack(
                    children: [
                      Obx(() {
                        // Determine image type based on profileImage value
                        final imageSrc = controller.profileImage.value;
                        final isLocalFile =
                            imageSrc.isNotEmpty && File(imageSrc).existsSync();
                        return CommonImage(
                          imageSrc:
                              imageSrc.isNotEmpty
                                  ? imageSrc
                                  : "", // Fallback to default avatar
                          imageType:
                              isLocalFile ? ImageType.file : ImageType.network,
                          borderRadius: 100.r,
                          fill: BoxFit.cover,
                          size: 140.r,
                        );
                      }),
                      Positioned(
                        bottom: 3,
                        right: 3,
                        child: GestureDetector(
                          onTap: () {
                            controller.imagePick();
                          },
                          child: Container(
                            height: 32.h,
                            width: 32.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  // First Name
                  CustomTextField(
                    backgroundColor: AppColors.textFieldBg,
                    hintText: 'Enter First Name',
                    isSuffix: false,
                    controller: controller.firstNameController,
                  ),

                  SizedBox(height: 20),

                  // Last Name
                  CustomTextField(
                    backgroundColor: AppColors.textFieldBg,
                    hintText: 'Enter Last Name',
                    controller: controller.lastNameController,
                    isSuffix: false,
                  ),

                  SizedBox(height: 20),

                  /// **Profile Fields**
                  CustomTextField(
                    backgroundColor: AppColors.textFieldBg,
                    hintText: AppString.enterName,
                    isSuffix: false,
                    controller: controller.nameController,
                  ),
                  if (PrefsHelper.myRole == 'user') const SizedBox(height: 20),

                  // Date of Birth
                  if (PrefsHelper.myRole == 'user')
                    Obx(
                      () => GestureDetector(
                        onTap: () async {
                          // DateTime? selectedDate = await showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime(1900),
                          //   lastDate: DateTime.now(),
                          // );
                          // if (selectedDate != null) {
                          //   controller.selectedDate.value = selectedDate;
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBg,
                            border: Border.all(
                              color: AppColors.lightGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 21.h,
                                      horizontal: 20.w,
                                    ),
                                    child: SizedBox(
                                      height: 16.h,
                                      width: 16.w,
                                      child: CommonImage(
                                        imageSrc: AppIcons.calenderIcon,
                                        imageType: ImageType.svg,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller.selectedDate.value != null
                                        ? DateFormat(
                                          'dd/MM/yyyy',
                                          // 'yyyy-MM-dd',
                                        ).format(controller.selectedDate.value!)
                                        : AppString.dateOfBirth,
                                    style: styleForNormalText.copyWith(
                                      color: AppColors.grey,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBg,
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: CommonImage(
                              imageSrc: AppIcons.genderIcon,
                              imageType: ImageType.svg,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                                value:
                                    controller.selectedGender.value.isNotEmpty
                                        ? controller.selectedGender.value
                                        : null,
                                style: styleForNormalText.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                hint: Text(
                                  AppString.selectGender,
                                  style: styleForNormalText.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                items:
                                    controller.genderItem.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedGender.value = newValue;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  /// **Phone Number Input**
                  CustomPhoneField(controller: controller.phoneController),

                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: notificationsEnabled.value,
                          onChanged: toggleNotifications,
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// **Bottom Button**
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => CustomButton(
                onTap: () {
                  controller.editProfile();
                },
                isLoading: controller.isLoading.value,
                borderRadius: 12,
                text: AppString.save,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;

  const CustomPhoneField({super.key, required this.controller});

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  // Only Italy and USA
  final List<Map<String, String>> countries = [
    {"code": "IT", "dial_code": "+39", "name": "Italy", "flag": "🇮🇹"},
    {"code": "US", "dial_code": "+1", "name": "USA", "flag": "🇺🇸"},
  ];

  late Map<String, String> selectedCountry;

  @override
  void initState() {
    super.initState();
    // Default country = Italy
    selectedCountry = countries[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      child: Row(
        children: [
          // Dropdown for country code
          DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, String>>(
              value: selectedCountry,
              items:
                  countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Row(
                        children: [
                          Text(
                            country["flag"]!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            country["dial_code"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          // Phone number input field
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter phone number",
              ),
              onChanged: (value) {
                String fullNumber = "${selectedCountry["dial_code"]}$value";
                debugPrint("Full number: $fullNumber");
              },
            ),
          ),
        ],
      ),
    );
  }
}
