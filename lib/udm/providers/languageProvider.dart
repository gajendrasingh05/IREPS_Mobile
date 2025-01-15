import 'package:flutter/material.dart';
import 'package:flutter_app/udm/localization/english.dart';
import 'package:flutter_app/udm/localization/hindi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/languageHelper.dart';

class LanguageProvider extends ChangeNotifier {
  Language language = Language.English;
  late SharedPreferences? prefs;

  Future<void> fetchLanguage() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs == null) {
      language = Language.English;
      print('SHARED PREFERENCES ARE NULL');
      return;
    }
    String? val = prefs!.getString('language');
    language = val == null ? Language.English : languageCodeMapReverse[val]!;
  }

  Future<void> updateLanguage(Language language) async {
    this.language = language;
    notifyListeners();
    if(prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    await prefs!.setString('language', languageCodeMap[language] ?? languageCodeMap[Language.English]!);
  }

  String get languageString {
    return languageCodeMap[language] ?? languageCodeMap[Language.English]!;
  }

  Map<String, String> get languageMap {
    return languageMaps[language] ?? languageMaps[Language.English]!;
  }

  String text(String key) {
    if (languageMap[key] == null && englishText[key] == null) {
      throw Exception('No text found for key: ' + key);
    }
    if (languageMap[key] == null) {
      return englishText[key]!;
    }
    return languageMap[key]!;
  }
}