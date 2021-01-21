import 'package:dio/dio.dart';

class APIException implements Exception {
  final int code;
  final String message;

  APIException(this.code, this.message);

  factory APIException.fromResponse(Map<String, dynamic> response) {
    var code = response['code'];
    var message = response['msg'];
    if (code == 401) {
      return UnauthorisedException(code, "没有权限");
    }
    return APIException(code, message);
  }

  factory APIException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return BadRequestException(-1, "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return BadRequestException(-1, "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return BadRequestException(-1, "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return BadRequestException(-1, "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  // "请求语法错误"
                  return BadRequestException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 401:
                {
                  // "没有权限"
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
                  // "无效的请求"
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 503:
                {
                  // "服务器挂了"
                  return UnauthorisedException(
                      errCode, error.response.statusMessage);
                }
                break;
              case 505:
                {
                  // "不支持HTTP协议请求"
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
