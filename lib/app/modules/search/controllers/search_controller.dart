import 'package:get/get.dart';

class SearchController extends GetxController {
  //TODO: Implement SearchController

  final count = 0.obs;
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
  void increment(index) {
    count.value= index;
  }
}
