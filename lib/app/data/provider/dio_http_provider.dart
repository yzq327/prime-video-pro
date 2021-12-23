import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:prime_video_pro/app/data/provider/http_options.dart';
import 'package:prime_video_pro/app/data/provider/http_provider.dart';

import 'http_util.dart';

class DioHttpProvider implements HttpProvider {
  final Dio _dio = new Dio(HttpOptions.getInstance);

  DioHttpProvider() {
    _dio.interceptors
        .add(InterceptorsWrapper(onResponse: (response, handle) {
          if (response.data is String) {
            response.data = json.decode(response.data);
          }
          handle.next(response);
    }));
  }

  @override
  Future<dynamic> get(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    if (HttpOptions.isInDebugMode) HttpUtil.urlPrint(url, params: queryParameters);
    return _dio.get<dynamic>(url, queryParameters: queryParameters);
  }

  @override
  Future post(String url) {
    // TODO: implement post
    throw UnimplementedError();
  }
}
