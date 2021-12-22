import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';

import 'app/core/values/languages.dart';
import 'app/routes/app_pages.dart';

void main() {
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
