import 'package:dio/dio.dart';
import 'package:fans/env.dart';

var version = '';
var dio = Dio();

void setApiIO(io) {
  dio = io;
}

Future<Map<String, dynamic>> api(path, data) async {
  Response rsp = await dio.post('$apiEntry$path',
      data: data,
      options: Options(
          headers: {'x-token': '43811a7a-150d-47e5-836c-878fa9fec8a2'}));
  return rsp.data;
  // if (rsp.data['code'] == 0) {
  //   return rsp.data['data'];
  // }
  // throw rsp.data['msg'];
}
