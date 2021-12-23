import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/data/provider/dio_http_provider.dart';
import 'package:prime_video_pro/app/data/provider/http_provider.dart';
import 'package:prime_video_pro/app/data/service/video_service.dart';

import 'app/core/values/languages.dart';
import 'app/routes/app_pages.dart';

void main() {
  inject();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      theme: ThemeData(
        primarySwatch: SystemColors.themeBgColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        highlightColor: Color.fromRGBO(0, 0, 0, 0),
        splashColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      getPages: AppPages.routes,
      translationsKeys: AppTranslation.translations,
    ),
  );
}

void inject() {
  Get.lazyPut<HttpProvider>(() => DioHttpProvider());
  Get.lazyPut(() => VideoService());
}