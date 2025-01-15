import 'package:get/get.dart';
import 'package:flutter_app/mmis/localizations/english.dart';
import 'package:flutter_app/mmis/localizations/hindi.dart';

enum Language {
  English,
  Hindi,
}

Map<Language, String> languageTextMap = {
  Language.English: 'English',
  Language.Hindi: 'हिंदी',
};

class Languages extends Translations {

  // final Map<String, Map<String, String>> languages;
  // Languages({required this.languages});

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': English.translations,
    'hi_IN': Hindi.translations,
  };
}