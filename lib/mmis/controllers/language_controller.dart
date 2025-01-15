import 'dart:ui';

import 'package:flutter_app/mmis/helpers/shared_preference_helper.dart';
import 'package:flutter_app/mmis/models/language_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {

  final Rx<Locale> locale = Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    //loadCurrentLanguage();
  }

  void changeLocale(Locale newLocale) {
    Get.updateLocale(newLocale);
    //locale.value = newLocale;
    //_locale = newLocale;
    //changeLocale(newLocale);
    //selectedLanguage = _locale.languageCode == "en" ? "English" : "हिंदी";
    //saveLanguage(_locale);
  }

  String? selectedLanguage = "English";
  //Locale _locale = Locale(Strings.languages[0].languageCode, Strings.languages[0].countryCode);

  // void setSelectedLanguage(Locale locale) {
  //    Get.updateLocale(locale);
  //   _locale = locale;
  //   changeLocale(locale);
  //   selectedLanguage = _locale.languageCode == "en" ? "English" : "हिंदी";
  //   saveLanguage(_locale);
  //   //update();
  // }


  // void loadCurrentLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   locale.value = Locale(prefs.getString(SharedPreferenceHelper.languageCode) ?? Strings.languages[0].languageCode, prefs.getString(SharedPreferenceHelper.countryCode) ?? Strings.languages[0].countryCode);
  //   _locale = Locale(prefs.getString(SharedPreferenceHelper.languageCode) ?? Strings.languages[0].languageCode, prefs.getString(SharedPreferenceHelper.countryCode) ?? Strings.languages[0].countryCode);
  //   selectedLanguage = (prefs.containsKey('selectlanguage') ? prefs.getString('selectlanguage') : selectedLanguage)!;
  //   update();
  // }



  void saveLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectlanguage', locale.languageCode == "en" ? "English" : "हिंदी");
    prefs.setString(SharedPreferenceHelper.languageCode, locale.languageCode);
    prefs.setString(SharedPreferenceHelper.countryCode, locale.countryCode ?? '');
  }


}
