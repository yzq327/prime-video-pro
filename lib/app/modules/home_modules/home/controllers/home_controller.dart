import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_video_pro/app/data/model/video_type_list_model.dart';
import 'package:prime_video_pro/app/data/service/video_service.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/tab_content_controller.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin  {
  //TODO: Implement HomeController
  RxList<VideoType> getTypeList = <VideoType>[].obs;
  RxList<TabContentController> tabContentControllerList = <TabContentController>[].obs;
  final VideoService _videoService = Get.find();
  late TabController tabController;
  int currentTabIndex = 0;

  @override
  void onInit() {
    tabController = TabController(length: getTypeList.length, vsync: this);
    getVideoTypeList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  getVideoTypeList() async {
    final typeList = await _videoService.getTypeList();
    getTypeList.assignAll(typeList);
    tabContentControllerList.assignAll(
        List.generate(getTypeList.length, (index) {
          return TabContentController(getTypeList[index].typeId);
        })
    );
    tabContentControllerList[0].onRefresh();
    tabController =
    TabController(length: typeList.length, vsync: this)
      ..addListener(() {
        if ( currentTabIndex == tabController.index) {
          return;
        }
        currentTabIndex = tabController.index;
        tabContentControllerList[tabController.index].onRefresh();
      });
  }
}
