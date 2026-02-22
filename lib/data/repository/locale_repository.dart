import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  static const String _localeCodeKey = 'app_locale_code';

  Future<String?> getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeCodeKey);
  }

  Future<void> saveLocaleCode(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, localeCode);
  }

  Future<void> clearLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeCodeKey);
  }
}
