
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateHelper {
  /// Get formatted time only (e.g., 01:05 PM)
  static String getTime({required String serverDate}) {
    try {
      DateTime parsedDate = DateTime.parse(serverDate).toLocal(); // Convert to local time
      return DateFormat('hh:mm a').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  /// Get formatted day only (e.g., Wednesday)
  static String getDay({required String serverDate}) {
    try {
      DateTime parsedDate = DateTime.parse(serverDate).toLocal(); // Convert to local time
      return DateFormat('EEEE').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  /// Get formatted date only (e.g., 2024-11-27)
  static String getDate({required String serverDate}) {
    try {
      DateTime parsedDate = DateTime.parse(serverDate).toLocal(); // Convert to local time
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  /// Get time and day together (e.g., 01:05 PM, Wednesday)
  static String getTimeAndDay({required String serverDate}) {
    try {
      DateTime parsedDate = DateTime.parse(serverDate).toLocal(); // Convert to local time
      String formattedTime = DateFormat('hh:mm a').format(parsedDate);
      String day = DateFormat('EEEE').format(parsedDate);
      return '$day $formattedTime';
    } catch (e) {
      return '';
    }
  }

  static Future<String> openTimePicker(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);

    if (picked != null) {
      final period = picked.period == DayPeriod.am ? "AM" : "PM";
      controller.text =
          "${picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod} : ${picked.minute < 10 ? "0${picked.minute}" : picked.minute} $period";
      return "${picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod}:${picked.minute < 10 ? "0${picked.minute}" : picked.minute} $period";
    }
    return '';
  }
}
