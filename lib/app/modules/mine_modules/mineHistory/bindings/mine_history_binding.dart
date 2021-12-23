import 'package:get/get.dart';

import '../controllers/mine_history_controller.dart';

class MineHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineHistoryController>(
      () => MineHistoryController(),
    );
  }
}
