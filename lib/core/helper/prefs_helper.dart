import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper extends GetxController {
  static String token = "";
  static bool isLogIn = false;
  static bool adminVerified = false;
  static bool subscription = false;
  static String refreshToken = "";
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myRole = "";
  static String accountStatus = "";
  static String about = "";
  static String phone = "";
  static String phoneCountryCode = "";
  static String gender = "";
  static String address = "";
  static String paypalEmail = "";
  static String latitude = "";
  static String longitude = "";
  static String parentBusinessId = "";
  static double rating = 0;
  static double points = 0;
  static List<String> interests = [];
  static List<String> photos = [];

  static String localizationLanguageCode = 'en';
  static String localizationCountryCode = 'US';

  static String businessName = "";
  static String shortDescription = "";
  static String detailDescription = "";
  static String businessLogo = "";
  static String coverLogo = "";
  static List<dynamic> galleryLogo = [];
  static String email = "";
  static String phoneNumber = "";
  static String website = "";
  static String facebook = "";
  static String instagram = "";
  static String tiktok = "";
  static String startTime = "";
  static String endTime = "";

  static Future<void> getAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    parentBusinessId = preferences.getString("parentbusinessid") ?? "";
    token = preferences.getString("token") ?? "";
    refreshToken = preferences.getString("refreshToken") ?? "";
    userId = preferences.getString("userId") ?? "";
    myImage = preferences.getString("myImage") ?? "";
    myName = preferences.getString("myName") ?? "";
    myEmail = preferences.getString("myEmail") ?? "";
    myRole = preferences.getString("myRole") ?? "";
    isLogIn = preferences.getBool("isLogIn") ?? false;
    adminVerified = preferences.getBool("adminVerified") ?? false;
    subscription = preferences.getBool("subscription") ?? false;
    about = preferences.getString("about") ?? "";
    phone = preferences.getString("phone") ?? "";
    phoneCountryCode = preferences.getString("phoneCountryCode") ?? "";
    address = preferences.getString("address") ?? "";
    paypalEmail = preferences.getString("paypalEmail") ?? "";
    latitude = preferences.getString("latitude") ?? "";
    longitude = preferences.getString("longitude") ?? "";
    gender = preferences.getString("gender") ?? "";
    rating = preferences.getDouble("rating") ?? 0;
    points = preferences.getDouble("points") ?? 0;

    interests = preferences.getStringList("interests") ?? [];
    photos = preferences.getStringList("photos") ?? [];

    localizationCountryCode =
        preferences.getString("localizationCountryCode") ?? "IT";
    localizationLanguageCode =
        preferences.getString("localizationLanguageCode") ?? "it";

    businessName = preferences.getString("businessName") ?? "";
    shortDescription = preferences.getString("shortDescription") ?? "";
    detailDescription = preferences.getString("detailDescription") ?? "";
    businessLogo = preferences.getString("businessLogo") ?? "";
    coverLogo = preferences.getString("coverLogo") ?? "";
    galleryLogo = preferences.getStringList("galleryLogo") ?? [];
    email = preferences.getString("email") ?? "";
    phoneNumber = preferences.getString("phoneNumber") ?? "";
    website = preferences.getString("website") ?? "";
    facebook = preferences.getString("facebook") ?? "";
    instagram = preferences.getString("instagram") ?? "";
    tiktok = preferences.getString("tiktok") ?? "";
    startTime = preferences.getString("startTime") ?? "";
    endTime = preferences.getString("endTime") ?? "";

    if (kDebugMode) {
      print(userId);
    }
  }

  static Future<void> clearDraft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove only draft-related keys instead of clearing all preferences
    await prefs.remove("businessName");
    await prefs.remove("shortDescription");
    await prefs.remove("detailDescription");

    await prefs.remove("businessLogo");
    await prefs.remove("coverLogo");
    await prefs.remove("galleryLogo");

    await prefs.remove("email");
    await prefs.remove("phoneNumber");
    await prefs.remove("website");

    await prefs.remove("facebook");
    await prefs.remove("instagram");
    await prefs.remove("tiktok");

    await prefs.remove("startTime");
    await prefs.remove("endTime");
    await prefs.remove("selectedDays");

    await prefs.remove("address");
    await prefs.remove("latitude");
    await prefs.remove("longitude");

    await prefs.remove("priceRange");
    await prefs.remove("guestCount");

    await prefs.remove("faqList");
  }

  // static Future<void> removeAllPrefData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.clear();
  //
  //   preferences.setString("token", "");
  //   preferences.setString("refreshToken", "");
  //   preferences.setString("userId", "");
  //   preferences.setString("myImage", "");
  //   preferences.setString("myName", "");
  //   preferences.setString("myEmail", "");
  //   preferences.setBool("isLogIn", false);
  //   preferences.setBool("adminVerified", false);
  //   preferences.setBool("subscription", false);
  //   preferences.setString("phoneCountryCode", "");
  //   preferences.setString("address", "");
  //   preferences.setString("paypalEmail", "");
  //   preferences.setString("latitude", "");
  //   preferences.setString("longitude", "");
  //   preferences.setDouble("rating", 0);
  //   preferences.setDouble("points", 0);
  //   preferences.setStringList("interests", []);
  //   preferences.setStringList("photos", []);
  //   preferences.setStringList("galleryLogo", []);
  //
  //   // optional reloading after logout
  //   getAllPrefData();
  // }
  static Future<void> removeAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    PrefsHelper.clearDraft();

    // Remove or reset all keys explicitly:
    await preferences.remove("parentbusinessid");
    await preferences.remove("token");
    await preferences.remove("refreshToken");
    await preferences.remove("userId");
    await preferences.remove("myImage");
    await preferences.remove("myName");
    await preferences.remove("myEmail");
    await preferences.remove("myRole");
    await preferences.remove("isLogIn");
    await preferences.remove("adminVerified");
    await preferences.remove("subscription");
    await preferences.remove("phoneCountryCode");
    await preferences.remove("phone");
    await preferences.remove("address");
    await preferences.remove("paypalEmail");
    await preferences.remove("latitude");
    await preferences.remove("longitude");
    await preferences.remove("gender");
    await preferences.remove("rating");
    await preferences.remove("points");
    await preferences.remove("interests");
    await preferences.remove("photos");
    await preferences.remove("businessName");
    await preferences.remove("shortDescription");
    await preferences.remove("detailDescription");
    await preferences.remove("businessLogo");
    await preferences.remove("coverLogo");
    await preferences.remove("galleryLogo");
    await preferences.remove("email");
    await preferences.remove("phoneNumber");
    await preferences.remove("website");
    await preferences.remove("facebook");
    await preferences.remove("instagram");
    await preferences.remove("tiktok");
    await preferences.remove("startTime");
    await preferences.remove("endTime");

    // Clear static variables in memory:
    token = "";
    refreshToken = "";
    userId = "";
    myImage = "";
    myName = "";
    myEmail = "";
    myRole = "";
    isLogIn = false;
    adminVerified = false;
    subscription = false;
    phoneCountryCode = "";
    phone = "";
    address = "";
    paypalEmail = "";
    latitude = "";
    longitude = "";
    gender = "";
    rating = 0;
    points = 0;
    interests = [];
    photos = [];
    businessName = "";
    shortDescription = "";
    detailDescription = "";
    businessLogo = "";
    coverLogo = "";
    galleryLogo = [];
    email = "";
    phoneNumber = "";
    website = "";
    facebook = "";
    instagram = "";
    tiktok = "";
    startTime = "";
    endTime = "";

    if (kDebugMode) {
      print("Prefs cleared and reset.");
    }
  }

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }

  static Future<String?> getParentBusinessId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("parentbusinessid") ?? "";
    log("$id -------------------");
    return id;
  }

  static void setParentBusinessId(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("parentbusinessid", value);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? 0;
  }

  static Future<double> getDouble(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(key) ?? 0;
  }

  static Future<List<String>> getStringList(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key) ?? [];
  }

  static Future<void> setStringList(String key, List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(key, value);
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(key, value);
  }

  static Future<void> remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
