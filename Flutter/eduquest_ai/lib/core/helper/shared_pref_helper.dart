import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<String?> getString(String key) async {
    if (_prefs == null) await init();
    return _prefs?.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    if (_prefs == null) await init();
    await _prefs?.setString(key, value);
  }

  static Future<void> clear() async {
    if (_prefs == null) await init();
    await _prefs?.clear();
  }
}
