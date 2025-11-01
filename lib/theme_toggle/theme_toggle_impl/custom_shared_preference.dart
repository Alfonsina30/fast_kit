import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreference {
  //
  static Future<SharedPreferences> _initPreference() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Future<void> savePreferenceTheme(bool value) async {
    final prefs = await _initPreference();
    prefs.setBool('themeApp', value);
  }

  Future<bool?> readPreferenceTheme() async {
    final prefs = await _initPreference();
    final getPrefs = prefs.getBool('themeApp');
    return getPrefs;
  }

  Future<bool> deletePreferenceTheme() async {
    final prefs = await _initPreference();
    return prefs.remove('themeApp');
  }
}