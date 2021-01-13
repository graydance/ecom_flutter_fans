import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'fans_token';

  static String token = '';

  static void setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String> readToken() async {
    token = await _storage.read(key: _tokenKey);
    return token;
  }
}
