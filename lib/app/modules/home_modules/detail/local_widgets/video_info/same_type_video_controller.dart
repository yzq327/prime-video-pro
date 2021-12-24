import 'package:get/get.dart';
import 'package:prime_video_pro/app/data/model/video_detail_list_model.dart';
import 'package:prime_video_pro/app/data/model/video_list_model.dart';
import 'package:prime_video_pro/app/data/service/video_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SameTypeVideoController extends GetxController{
  final  VideoDetail? getVideoDetail;
  final RxBool isLoading = false.obs;
  final VideoService _videoService = Get.find();
  final RxList<RefreshController> RefreshControllerList = <RefreshController>[].obs;
  final Rx<RefreshController> refreshController = RefreshController().obs;
  SameTypeVideoController(this.getVideoDetail);
  RxList<VideoInfo> getVideoList = <VideoInfo>[].obs;

  int total = 0;
  int currentPage = 1;


  _getVideoTypeList() async {
    Map<String, Object> params = {
      'ac': 'detail',
      't': getVideoDetail!.typeId,
      'pg': currentPage,
    };
    isLoading.value = true;
    VideoListModel model = await _videoService.getVideoList(params);
    print('model---${model.total}');
    total = model.total;
    if (currentPage == 1) {
      getVideoList.assignAll(model.list.where((element) =>
      element.vodId != getVideoDetail!.vodId)
          .toList());
    } else {
      getVideoList.addAll(model.list.where((element) =>
      element.vodId != getVideoDetail!.vodId)
          .toList());
    }
    RefreshControllerList.assignAll(
        List.generate(getVideoList.length, (index) {
          return RefreshController();
        })
    );
    isLoading.value = false;
  }

  bool get enablePullUp {
    return getVideoList.length != total - 1;
  }


  void onRefresh() async {
    print('???');
    currentPage = 1;
    await _getVideoTypeList();
    refreshController.value.refreshCompleted();
  }

  void onLoading() async {
    currentPage = currentPage + 1;
    await _getVideoTypeList();
    refreshController.value.loadComplete();
  }
}