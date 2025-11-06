import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OtherHelper {
  static RegExp emailRegexp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp passRegExp = RegExp(r'(?=.*[a-z])(?=.*[0-9])');

  static String? validator(value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  static String? emailValidator(value) {
    if (value!.isEmpty) {
      return "This field is required".tr;
    } else if (!emailRegexp.hasMatch(value)) {
      return "Enter valid email".tr;
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required".tr;
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters long".tr;
    }

    // final RegExp passRegExp = RegExp(
    //   r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    // );

    // if (!passRegExp.hasMatch(value)) {
    //   return "Password must contain at least:\n- 1 uppercase letter\n- 1 lowercase letter\n- 1 number\n- 1 special character (@\$!%*?&)"
    //       .tr;
    // }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required".tr;
    }

    if (value.length < 10) {
      return "Phone number must be at least 10 digits long".tr;
    }
    return null;
  }

  static String? confirmPasswordValidator(value, passwordController) {
    if (value.isEmpty) {
      return "This field is required".tr;
    } else if (value != passwordController.text) {
      return "The password does not match".tr;
    } else {
      return null;
    }
  }

  //Pick Image
  static Future<String> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      return pickedFile?.path ?? "";
    } catch (e) {
      log("Error selecting image: $e");
    }
    return "";
  }

  static Future<List<String>> pickMultipleImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      if (source == ImageSource.camera) {
        log("Multiple image picking from camera is not supported.");
        return [];
      }
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      return pickedFiles.map((file) => file.path).toList();
    } catch (e) {
      log("Error selecting multiple images: $e");
      return [];
    }
  }

  // Pick Single File
  static Future<String> pickSingleFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      return result?.files.single.path ?? "";
    } catch (e) {
      log("Error selecting file: $e");
    }
    return "";
  }

  static String getDate({required String serverDate}) {
    try {
      DateTime parsedDate =
          DateTime.parse(serverDate).toLocal(); // Convert to local time
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return 'Invalid date format';
    }
  }

  // Select a date with the DatePicker widget
  static Future<DateTime> selectDate(
    BuildContext context,
    DateTime? initialDate,
  ) async {
    try {
      DateTime? pickedDate =
          (await showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          )) ??
          DateTime.now();

      return pickedDate;
    } catch (e, s) {
      log("Error selecting date: $e");
      log("Error selecting date: $s");
    }
    return DateTime.now();
  }

  // Pick a time with the TimePicker widget
  static Future<TimeOfDay> pickTime(
    BuildContext context,
    TimeOfDay? initialTime,
  ) async {
    try {
      TimeOfDay? pickedTime =
          (await showTimePicker(
            context: context,
            initialTime: initialTime ?? TimeOfDay.now(),
          )) ??
          TimeOfDay.now();
      return pickedTime;
    } catch (e) {
      log("Error selecting time: $e");
    }
    return TimeOfDay.now();
  }

  static Future<String> openTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (picked != null) {
      final period = picked.period == DayPeriod.am ? "am" : "pm";
      return "${picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod}:${picked.minute < 10 ? "0${picked.minute}" : picked.minute} $period";
    }
    return '';
  }

  static String formatTo12Hour(String utcTimeString) {
    DateTime utcTime = DateTime.parse(utcTimeString);
    DateTime localTime = utcTime.toLocal();
    String formattedTime = DateFormat(
      'hh:mm a',
    ).format(localTime); // e.g., "12:53 PM"
    return formattedTime;
  }

  static String formatTime(String utcTimeString) {
    // Ensure it's treated as UTC
    DateTime utcTime = DateTime.parse(utcTimeString).toUtc();
    DateTime localTime = utcTime.toLocal();
    String formattedTime = DateFormat(
      'hh:mm a',
    ).format(localTime); // e.g., "12:53 PM"
    return formattedTime;
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(", ");

        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      print("❌ Error in reverse geocoding: $e");
      return "Unknown location";
    }
  }
}
