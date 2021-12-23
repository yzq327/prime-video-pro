import 'package:get/get.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/controllers/home_controller.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mine/controllers/mine_controller.dart';
import 'package:prime_video_pro/app/modules/search_modules/search/controllers/search_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut(()=>HomeController());
    Get.lazyPut(()=>SearchController());
    Get.lazyPut(()=>MineController());

  }
}
