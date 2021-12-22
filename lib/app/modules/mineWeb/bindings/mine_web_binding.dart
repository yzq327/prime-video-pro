import 'package:get/get.dart';

import '../controllers/mine_web_controller.dart';

class MineWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineWebController>(
      () => MineWebController(),
    );
  }
}
