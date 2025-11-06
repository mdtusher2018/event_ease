import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // Reactive variable to hold the current theme
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Function to toggle theme
  void toggleTheme() {
    themeMode.value = (themeMode.value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
  }
}
