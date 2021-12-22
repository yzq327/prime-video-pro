import 'package:get/get.dart';

import '../controllers/mine_activities_controller.dart';

class MineActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineActivitiesController>(
      () => MineActivitiesController(),
    );
  }
}
