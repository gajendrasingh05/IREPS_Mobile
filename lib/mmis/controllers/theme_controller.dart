
import 'package:flutter_app/mmis/themes/ThemeProvider.dart';
import 'package:flutter_app/mmis/themes/theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // Reactive variable to manage theme mode
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Method to toggle between light and dark themes
  void toggleTheme() {
    debugPrint("theme call");
    if (themeMode.value == ThemeMode.light) {
      debugPrint("theme call2");
      themeMode.value = ThemeMode.dark;
    } else {
      debugPrint("theme call");
      themeMode.value = ThemeMode.light;
    }
  }

  // Get the current theme data based on the mode
  ThemeData get themeData {
    return themeMode.value == ThemeMode.light ? light : dark;
  }

  // Reactive variable to manage theme mode
  //Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Method to toggle between light and dark themes
  // void toggleTheme() {
  //   if (themeMode.value == ThemeMode.light) {
  //     themeMode.value = ThemeMode.dark;
  //   } else {
  //     themeMode.value = ThemeMode.light;
  //   }
  // }

  // Get the current theme data based on the mode
  // ThemeData get themeData {
  //   return themeMode.value == ThemeMode.light ? light : dark;
  // }

  var isDarkMode = false;


  @override
  void onInit() {
    super.onInit();
    getThemePreference();
  }

  // void toggleTheme() {
  //   isDarkMode = !isDarkMode;
  //   Get.changeTheme(isDarkMode ? darkTheme : lightTheme);
  //   saveThemePreference(isDarkMode);
  // }

  Future<void> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    update();
  }


  Future<void> saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}