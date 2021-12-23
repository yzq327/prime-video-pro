import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:prime_video_pro/app/core/utils/log_utils.dart';
import 'http_options.dart';

class HttpUtil {
  static void urlPrint(String url,
      {Map<String, dynamic>? params, String? jsonData, FormData? formData}) {
    String urlStr;
    StringBuffer sb = new StringBuffer();
    sb.write(HttpOptions.baseUrl);
    sb.write(url + '?');
    if (params != null && params.isNotEmpty) {
      params.forEach((key, value) {
        sb.write(key + '=' + value.toString() + '&');
      });
    } else if (jsonData != null && jsonData.isNotEmpty) {
      sb.write(jsonData);
    }
    urlStr = sb.toString();
    if ((params != null && params.isNotEmpty) || formData != null)
      urlStr = urlStr.substring(0, urlStr.length - 1);
    LogUtils.printLog("url:  $urlStr");
  }
}
