import 'package:dio/dio.dart';

abstract class HttpProvider {
  Future<dynamic> get(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });
  Future<dynamic> post(String url);
}