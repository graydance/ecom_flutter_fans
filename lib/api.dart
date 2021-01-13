import 'package:dio/dio.dart';
import 'package:fans/env.dart';
import 'package:fans/storage/auth_storage.dart';

var version = '';
var dio = Dio();

void setApiIO(io) {
  dio = io;
}

Future<Map<String, dynamic>> api(path, data) async {
  var token = await AuthStorage.readToken();
  // TEST code
  if (token == null || token.isEmpty) {
    token = 'aa10fc17-e4db-4237-b644-9a7aa7223eec';
  }
  Response rsp = await dio.post('$apiEntry$path',
      data: data, options: Options(headers: {'x-token': token}));
  return rsp.data;
  // if (rsp.data['code'] == 0) {
  //   return rsp.data['data'];
  // }
  // throw rsp.data['msg'];
}
