import 'package:get/get.dart';

import '../controllers/mine_about_controller.dart';

class MineAboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineAboutController>(
      () => MineAboutController(),
    );
  }
}
