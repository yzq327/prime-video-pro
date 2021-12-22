import 'package:get/get.dart';

class MainController extends GetxController {
  //TODO: Implement MainController
  var currentIndex = 0.obs;
  var  stackIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void onItemTapped (index) {
    // currentIndex = index;
    stackIndex = index;
    update();
  }
}
