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
                  return BadRequestException(errCode, "请求语法错误");
                }
                break;
              case 401:
                {
                  return UnauthorisedException(errCode, "没有权限");
                }
                break;
              case 403:
                {
                  return UnauthorisedException(errCode, "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return UnauthorisedException(errCode, "无法连接服务器");
                }
                break;
              case 405:
                {
                  return UnauthorisedException(errCode, "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return UnauthorisedException(errCode, "服务器内部错误");
                }
                break;
              case 502:
                {
                  return UnauthorisedException(errCode, "无效的请求");
                }
                break;
              case 503:
                {
                  return UnauthorisedException(errCode, "服务器挂了");
                }
                break;
              case 505:
                {
                  return UnauthorisedException(errCode, "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return APIException(errCode, error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return APIException(-1, "未知错误");
          }
        }
        break;
      default:
        {
          return APIException(-1, error.message);
        }
    }
  }

  @override
  String toString() => 'Something went wrong! [$code][$message]';
}

/// 请求错误
class BadRequestException extends APIException {
  BadRequestException([int code, String message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends APIException {
  UnauthorisedException([int code, String message]) : super(code, message);
}
