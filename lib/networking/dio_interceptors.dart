import 'package:dio/dio.dart';
import 'package:fans/storage/auth_storage.dart';

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
  Future onRequest(RequestOptions options) {
    final token = AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({
        'x-token': token,
      });
    }
    return super.onRequest(options);
  }
}
