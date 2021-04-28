import 'package:dio/dio.dart';

class APIException implements Exception {
  final int code;
  final String message;

  APIException(this.code, this.message);

  factory APIException.fromResponse(Map<String, dynamic> response) {
    int code = response['code'];
    var message = response['msg'];
    switch (code) {
      case 401:
      case 402:
      case 403:
        return UnauthorisedException(code, "Token is expired");
      default:
        return APIException(code, message);
    }
  }

  factory APIException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return BadRequestException(-1, "请求取消");
        }
        break;
      case DioErrorType.connectTimeout:
        {
          return BadRequestException(-1, "连接超时");
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return BadRequestException(-1, "请求超时");
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return BadRequestException(-1, "响应超时");
        }
        break;
      case DioErrorType.response:
        {
          if (error.response == null) {
            return BadRequestException(-1, "Response is empty!");
          }
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  return BadRequestException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 401:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 403:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 404:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 405:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 500:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 502:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 503:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 505:
                {
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              default:
                {
                  return APIException(errCode, error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return APIException(-1, error.response.statusMessage);
          }
        }
        break;
      default:
        {
          return APIException(-1, error.response.statusMessage);
        }
    }
  }

  @override
  String toString() => '$message[$code]';
}

/// 请求错误
class BadRequestException extends APIException {
  BadRequestException([int code, String message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends APIException {
  UnauthorisedException([int code, String message]) : super(code, message);
}
