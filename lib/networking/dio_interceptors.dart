import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fans/env.dart';
import 'package:fans/storage/auth_storage.dart';
import 'package:uuid/uuid.dart';
import 'api_exceptions.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    APIException exception = APIException.create(err);
    // 错误提示
    err.error = exception;
    return super.onError(err);
  }
}

class TokenInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    var token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({
        'x-token': token,
      });
    }
    // Generate a v4 (random) id
    var nonce = Uuid().v4();
    var sign = _generateMd5(nonce + signKey);
    options.headers.addAll({
      'x-nonce': nonce,
      'x-version': signVersion,
      'x-signature': sign,
    });
    return super.onRequest(options);
  }

  String _generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }
}
