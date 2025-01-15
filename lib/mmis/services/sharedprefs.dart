import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceService {
  static SharePreferenceService _instance = SharePreferenceService._();

  late SharedPreferences _prefs; // Declare _prefs as non-nullable and late

  // Private constructor
  SharePreferenceService._() {
    initPrefs(); // Initialize _prefs in the constructor
  }

  factory SharePreferenceService() {
    return _instance;
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setStringValue(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getStringValue(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBoolValue(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBoolValue(String key) {
    return _prefs.getBool(key);
  }
}
