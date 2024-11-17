import 'package:dio/dio.dart';

class HttpServices {
  final _dio = Dio();

  Future<Response> getData(String path) async {
    try {
      final data = await _dio.get(path);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
