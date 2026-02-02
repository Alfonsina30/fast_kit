import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreference {
  //
  static Future<SharedPreferences> _loadPreference() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences;
  }

// methods that can be calling from business logic
  Future<void> savePreferenceTheme(String value) async {
    final prefs = await _loadPreference();
    prefs.setString('themeApp', value);
  }

  Future<String?> readPreferenceTheme() async {
    final prefs = await _loadPreference();
    final getPrefs = prefs.getString('themeApp');
    return getPrefs;
  }

  Future<bool> deletePreferenceTheme() async {
    final prefs = await _loadPreference();
    return prefs.remove('themeApp');
  }
}
