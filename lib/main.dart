import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/core/values/languages.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translationsKeys: AppTranslation.translations,
    ),
  );
}
