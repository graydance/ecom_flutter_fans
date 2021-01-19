import 'package:dio/dio.dart';

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