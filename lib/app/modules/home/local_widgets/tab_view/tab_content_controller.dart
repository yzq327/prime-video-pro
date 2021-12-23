import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/utils/log_utils.dart';
import 'package:prime_video_pro/app/data/model/video_list_model.dart';
import 'package:prime_video_pro/app/data/service/video_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabContentController extends GetxController {
  final int listId;
  final RxList<VideoInfo> videoList = <VideoInfo>[].obs;
  final RxBool isLoading = false.obs;
  final RefreshController refreshController = RefreshController();
  final VideoService _videoService = Get.find();
  int total = 0;
  int currentPage = 1;
  late PageController pageController;
  final currentIndex = 0.obs;
  late Timer timer;
  TabContentController(this.listId);

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: 3), (_) {
      if (pageController.hasClients) {
        currentIndex.value++;
        pageController.animateToPage(currentIndex.value,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void updateCurrentIndex(index) {
    currentIndex.value = index;
  }

  @override
  onClose() {
    refreshController.dispose();
    if (videoList.length > 1) {
      timer.cancel();
    }
  }
  bool get enablePullUp {
    return videoList.length != total;
  }

  void onRefresh() async {
    try {
      pageController = PageController(
        initialPage: currentIndex.value,
      );
      currentPage = 1;
      await getVideoTypeDetailList();
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    currentPage = currentPage + 1;
    await getVideoTypeDetailList();
    refreshController.loadComplete();
  }

  getVideoTypeDetailList() async {
    Map<String, Object> params = {
      'ac': 'detail',
      't': listId,
      'pg': currentPage,
    };
    isLoading.value = true;
    VideoListModel model = await _videoService.getVideoList(params);
    if (model.list.length > 0) {
      total = model.total;
      if (currentPage == 1) {
        videoList.assignAll(model.list);
      } else {
        videoList.addAll(model.list);
      }
      if (videoList.length > 1) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          startTimer();
        });
      }
    } else {
      LogUtils.printLog('数据为空！');
    }
    isLoading.value = false;
  }
}
