import 'english.dart';
import 'hindi.dart';

enum Language {
  English,
  Hindi,
}


Map<Language, String> languageTextMap = {
  Language.English: 'English',
  Language.Hindi: 'हिंदी',
};

Map<Language, String> languageCodeMap = {
  Language.English: 'en',
  Language.Hindi: 'hi',
};

Map<String, Language> languageCodeMapReverse = {
  'en': Language.English,
  'hi': Language.Hindi,
};

Map<Language, Map<String, String>> languageMaps = {
  Language.English: englishText,
  Language.Hindi: hindiText,
};
