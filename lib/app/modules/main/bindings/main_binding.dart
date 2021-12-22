import 'package:get/get.dart';
import 'package:prime_video_pro/app/modules/home/controllers/home_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut(()=>HomeController());
  }
}
