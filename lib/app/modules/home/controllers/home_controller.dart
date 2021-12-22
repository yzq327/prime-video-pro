import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/http/http_options.dart';
import 'package:prime_video_pro/app/core/http/http_util.dart';
import 'package:prime_video_pro/app/core/utils/log_utils.dart';
import 'package:prime_video_pro/app/data/model/video_list_model.dart';
import 'package:prime_video_pro/app/data/model/video_type_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin  {
  //TODO: Implement HomeController
  List<VideoType> getTypeList = [];
  late TabController tabController;
  RefreshController refreshController = RefreshController();
  int currentTabIndex = 0;
  List<VideoInfo> getVideoList = [];
  int total = 0;
  int currentPage = 1;
  bool isLoading = false;

  bool get enablePullUp {
    return getVideoList.length != total;
  }


  @override
  void onInit() {
    tabController = TabController(length: getTypeList.length, vsync: this);
    // refreshController = RefreshController();
    _getVideoTypeList();
    super.onInit();
  }

  @override
  void onReady() {
    refreshController = new RefreshController();
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  _getVideoTypeList() {
    print('_getVideoTypeList---');
    HttpUtil.request(HttpOptions.baseUrl, HttpUtil.GET).then((value) {
      VideoTypeListModel model = VideoTypeListModel.fromJson(value);
      if (model.typeList != null && model.typeList.length > 0) {
        getTypeList = model.typeList;
        tabController =
        TabController(length: model.typeList.length, vsync: this)
          ..addListener(() {
            currentTabIndex = tabController.index;
            _getVideoTypeDetailList();
          });
      } else {
        LogUtils.printLog('数据为空！');
      }
    });
    update();
  }

  _getVideoTypeDetailList() async {
    Map<String, Object> params = {
      'ac': 'detail',
      't': getTypeList[currentTabIndex].typeId,
      'pg': currentPage,
    };
    isLoading = true;

    // refreshController = RefreshController();
    HttpUtil.request(HttpOptions.baseUrl, HttpUtil.GET, params: params)
        .then((value) {
      VideoListModel model = VideoListModel.fromJson(value);
      if (model.list.length > 0) {
        total = model.total;
        getVideoList = currentPage == 1
            ? model.list
            : (getVideoList..addAll(model.list));
      } else {
        LogUtils.printLog('数据为空！');
      }
    }).whenComplete((){
      isLoading = false;
    });
  }

  void onRefresh() async {
    try {
      currentPage = 1;
      await _getVideoTypeList();
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update();
  }

  void onLoading() async {
    currentPage = currentPage + 1;
    await _getVideoTypeDetailList();
    refreshController.loadComplete();
    update();
  }
}
