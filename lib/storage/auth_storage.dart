import 'package:fans/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static SharedPreferences preferences;
  static Future<void> getInstance() async {
    preferences = await SharedPreferences.getInstance();
  }

  static const _tokenKey = 'fans_token_key';
  static const _userKey = 'fans_user_key';

  static void setToken(String token) {
    preferences.setString(_tokenKey, token);
  }

  static String getToken() {
    return preferences.getString(_tokenKey);
  }

  static void setUser(User user) {
    var jsonString = user.toJson();
    preferences.setString(_userKey, jsonString);
  }

  static User getUser() {
    var jsonString = preferences.getString(_userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return User();
    }
    return User.fromJson(jsonString) ?? User();
  }
}
