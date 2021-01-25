import 'package:fans/storage/auth_storage.dart';
import 'package:flutter/material.dart';

enum HttpMethod { GET, POST }

extension HttpMethodExt on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.GET:
        return 'GET';
      case HttpMethod.POST:
        return 'POST';
      default:
        return 'GET';
    }
  }
}

abstract class TargetType {
  String get path;
  Map<String, String> get headers;
  HttpMethod get method;
  Map<String, dynamic> get parameters;
}

class API extends TargetType {
  @override
  HttpMethod get method {
    return HttpMethod.POST;
  }

  @override
  Map<String, String> get headers {
    var headers;
    var token = AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers = {
        'x-token': token,
      };
    }
    return headers ?? Map();
  }

  @override
  Map<String, dynamic> get parameters => Map();

  @override
  String get path => throw UnimplementedError();
}

@immutable
class LoginAPI extends API {
  final String email;
  final String password;

  LoginAPI({@required this.email, this.password = ''});

  @override
  Map<String, dynamic> get parameters => {'email': email, 'password': password};

  @override
  String get path => '/user/pub/login';
}

class InterestListAPI extends API {
  @override
  String get path => '/user/interest_list';
}

class UploadInterestsAPI extends API {
  final List<String> interestIdList;

  UploadInterestsAPI(this.interestIdList);

  @override
  Map<String, dynamic> get parameters => {'interestIdList': interestIdList};

  @override
  String get path => '/user/interest_updata';
}

class FeedsAPI extends API {
  final int type;
  final int page;

  FeedsAPI({
    this.type = 0,
    this.page = 1,
  });

  @override
  Map<String, dynamic> get parameters => {'type': type, 'page': page};

  @override
  String get path => '/user/following';
}

class RecommendSellerAPI extends API {
  @override
  String get path => '/user/recommend';
}

class TagSearchAPI extends API {
  final String tag;
  final String userId;
  final int page;
  final int limit;

  TagSearchAPI({this.tag, this.userId, this.page, this.limit});

  @override
  Map<String, dynamic> get parameters =>
      {'userId': userId, 'tag': tag, 'page': page, 'limit': limit};

  @override
  String get path => '/user/tag_search';
}

class ShopDetailAPI extends API {
  final String userId;

  ShopDetailAPI(this.userId);

  @override
  Map<String, dynamic> get parameters => {'userId': userId};

  @override
  String get path => '/user/detail';
}

class FollowAPI extends API {
  final String userId;

  FollowAPI(this.userId);

  @override
  Map<String, dynamic> get parameters => {'idolId': userId};

  @override
  String get path => '/user/follow_me';
}

class GoodsAPI extends API {
  final int type;
  final String userId;
  final int page;
  final int limit;

  GoodsAPI({this.type, this.userId, this.page, this.limit});

  @override
  Map<String, dynamic> get parameters =>
      {'userId': userId, 'type': type, 'page': page, 'limit': limit};

  @override
  String get path => '/user/pub/good_list';
}

// var version = '';

// var dio = Dio(
//   BaseOptions(
//     connectTimeout: 30000,
//     receiveTimeout: 30000,
//     headers: getAuthorizationHeader(),
//   ),
// )..interceptors.addAll([
//     ErrorInterceptor(),
//     LogInterceptor(
//       requestBody: true,
//       responseHeader: false,
//       responseBody: true,
//     ),
//   ]);

// Map<String, dynamic> getAuthorizationHeader() {
//   var headers;
//   var token = AuthStorage.getToken();
//   if (token != null && token.isNotEmpty) {
//     headers = {
//       'x-token': token,
//     };
//   }
//   return headers;
// }

// void setApiIO(io) {
//   dio = io;
// }

// Future<Map<String, dynamic>> api(path, data) async {
//   Response rsp = await dio.post('$apiEntry$path', data: data);
//   if (rsp.data['code'] == 0) {
//     return rsp.data;
//   }
//   throw APIException.fromResponse(rsp.data);
// }
