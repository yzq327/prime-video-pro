import 'package:get/get.dart';

import '../controllers/mine_collection_controller.dart';

class MineCollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineCollectionController>(
      () => MineCollectionController(),
    );
  }
}
