import 'package:dio/dio.dart';

var version = '';
var entry = 'https://dev.api.ramboo.live/api/';
var dio = Dio();

void setApiIO(io) {
  dio = io;
}

Future<Map<String, dynamic>> api(path, data) async {
  Response rsp = await dio.post('$entry$path',
      data: data, options: Options(headers: {'x-token': ''}));
  return rsp.data;
  // if (rsp.data['code'] == 0) {
  //   return rsp.data['data'];
  // }
  // throw rsp.data['msg'];
}
