import 'package:fans/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'fans_token_key';
  static const _userKey = 'fans_user_key';

  static Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  static Future<void> setUser(User user) async {
    final preferences = await SharedPreferences.getInstance();

    var jsonString = user.toJson();
    preferences.setString(_userKey, jsonString);
  }

  static Future<User> getUser() async {
    final preferences = await SharedPreferences.getInstance();

    var jsonString = preferences.getString(_userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return User();
    }
    return User.fromJson(jsonString) ?? User();
  }

  static Future<void> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }
}
