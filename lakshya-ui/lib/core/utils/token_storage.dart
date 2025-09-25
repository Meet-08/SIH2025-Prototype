import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  static final _prefs = SharedPreferences.getInstance();

  static Future<void> saveToken(String token) async {
    await (await _prefs).setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    return (await _prefs).getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    await (await _prefs).remove(_tokenKey);
  }
}
