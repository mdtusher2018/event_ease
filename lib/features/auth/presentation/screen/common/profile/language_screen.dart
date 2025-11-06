import 'dart:developer';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/helper/prefs_helper.dart';
import '../../../utils/app_string.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = "English"; // Default selected language

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference(); // Uncomment this line to load saved preference
  }

  Future<void> _loadLanguagePreference() async {
    String savedLanguageCode = PrefsHelper.localizationLanguageCode;
    log("Saved Language Code: $savedLanguageCode");
    log("Saved Country Code: ${PrefsHelper.localizationCountryCode}");

    setState(() {
      selectedLanguage = _getLanguageNameFromCode(savedLanguageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          AppString.language,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Column(children: [
        _buildLanguageTile("English", "en", "US"),
        Divider(indent: 10, endIndent: 10),
        _buildLanguageTile("Italian", "it", "IT"),
      ]),
    );
  }

  Widget _buildLanguageTile(String language, String languageCode, String countryCode) {
    return InkWell(
      onTap: () async {
        _changeLanguage(language, languageCode, countryCode);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Text(
              language,
              style: styleForBoldText.copyWith(fontSize: 18.sp, color: AppColors.darkGrey, height: 1.56.h),
            ),
            const Spacer(),
            Radio(
              value: language,
              groupValue: selectedLanguage,
              onChanged: (String? value) {
                _changeLanguage(value!, languageCode, countryCode);
              },
              activeColor: AppColors.primary,
              fillColor: WidgetStatePropertyAll(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(String language, String languageCode, String countryCode) async {
    log("Changing language to: $language ($languageCode-$countryCode)");

    setState(() {
      selectedLanguage = language;
    });

    // Update GetX locale
    Get.updateLocale(Locale(languageCode, countryCode));

    // Save the new language selection to shared preferences
    await PrefsHelper.setString("localizationLanguageCode", languageCode);
    await PrefsHelper.setString("localizationCountryCode", countryCode);

    // Uncomment these lines if needed to update static values immediately
    PrefsHelper.localizationLanguageCode = languageCode;
    PrefsHelper.localizationCountryCode = countryCode;
  }

  String _getLanguageNameFromCode(String code) {
    switch (code) {
      case "it":
        return "Italian";
      case "en":
        return "English";
      default:
        return "English"; // Default fallback to English
    }
  }
}