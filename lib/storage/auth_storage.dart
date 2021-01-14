import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'fans_token';

  static void setToken(String token) async {
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_tokenKey, token);
  }

  static Future<String> readToken() async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString(_tokenKey);
    return token;
  }
}
