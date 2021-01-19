import 'package:dio/dio.dart';
import 'package:fans/env.dart';
import 'package:fans/networking/api.dart';
import 'package:fans/networking/api_exceptions.dart';
import 'package:fans/networking/dio_interceptors.dart';
import 'package:fans/storage/auth_storage.dart';

class Networking {
  static var _dio = Dio(
    BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: _getAuthorizationHeader(),
      baseUrl: apiEntry,
    ),
  )..interceptors.addAll([
      ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
    ]);

  static Map<String, dynamic> _getAuthorizationHeader() {
    var headers;
    var token = AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers = {
        'x-token': token,
      };
    }
    return headers;
  }

  static Future<Map<String, dynamic>> request<T extends TargetType>(
      T targetType) async {
    _dio.options.method = targetType.method.value;

    Response rsp = (targetType.method == HttpMethod.POST)
        ? await _dio.post(targetType.path, data: targetType.parameters)
        : await _dio.get(targetType.path,
            queryParameters: targetType.parameters);
    if (rsp.data['code'] == 0) {
      return rsp.data;
    }
    throw APIException.fromResponse(rsp.data);
  }
}
