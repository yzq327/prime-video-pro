import 'package:get/get.dart';

import '../controllers/mine_collection_detail_controller.dart';

class MineCollectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineCollectionDetailController>(
      () => MineCollectionDetailController(),
    );
  }
}
