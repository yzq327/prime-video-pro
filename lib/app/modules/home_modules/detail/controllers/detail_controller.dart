import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/values/assets_data.dart';
import 'package:prime_video_pro/app/core/values/constants.dart';
import 'package:prime_video_pro/app/core/values/string.dart';
import 'package:prime_video_pro/app/data/model/common/common_model.dart';
import 'package:prime_video_pro/app/data/model/video_detail_list_model.dart';
import 'package:prime_video_pro/app/data/service/video_service.dart';
import 'package:prime_video_pro/app/data/table/db_util.dart';
import 'package:prime_video_pro/app/data/table/table_init.dart';
import 'package:prime_video_pro/app/global_widgets/common_dialog.dart';
import 'package:prime_video_pro/app/global_widgets/common_toast.dart';
import 'package:prime_video_pro/app/global_widgets/coomom_video_player.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/local_widgets/video_info/same_type_video_controller.dart';
import 'package:rive/rive.dart';

class VideoDetailPageParams {
  final int vodId;
  final String vodName;
  final String vodPic;
  final int watchedDuration;

  VideoDetailPageParams(
      {required this.vodId,
      this.vodName = '',
      this.vodPic = '',
      this.watchedDuration = 0});
}

class DetailController extends GetxController with GetTickerProviderStateMixin {
  //TODO: Implement DetailController
  final VideoService _videoService = Get.find();
  final RxBool isPageLoading = true.obs;
  final RxInt currentSelectCollection = 0.obs;
  final Rx<TabController?> tabController = Rx(null);
  final Rx<String?> videoUrl = Rx(null);
  final RxList<MyCollectionItem> myCollectionsList = <MyCollectionItem>[].obs;
  final RxList<int> collectedVideoNumbers = <int>[].obs;
  final RxBool showSheet = false.obs;
  final Rx<TextEditingController> userEtController =
      TextEditingController().obs;
  final RxList<bool> checkBoxStates = <bool>[].obs;
  final RxString currentEpo = ''.obs;
  final RxBool isCollected = false.obs;
  final Rx<Artboard?> artboard = Rx(null);
  final Rx<VideoDetail?> getVideoDetail = Rx(null);
  final RxBool reverse = false.obs;
  final RxInt currentIndex = 0.obs;
  // final RxList<SameTypeVideoController> sameTypeVideoControllerList = <SameTypeVideoController>[].obs;
  final Rx<SameTypeVideoController?> sameTypeVideoController = Rx(null);

  List<VideoHistoryItem> videoHistoryList = [];
  List? urlInfo = [];
  late DBUtil dbUtil;
  late StoreDuration durations;
  // StoreDuration durations = ;
  late VideoDetailPageParams videoDetailPageParams;
  RiveAnimationController? _controller1;
  RiveAnimationController? _controller2;

  bool isFullScreen(context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  void playWithIndex(int index) {
    videoUrl.value = urlInfo![index][1];
    currentEpo.value = urlInfo![index][0];
  }

  @override
  void onInit() {
    sameTypeVideoController.value = SameTypeVideoController(init);
    tabController.value = TabController(length: 2, vsync: this);
    rootBundle.load('assets/riv/collect.riv').then((data) {
      final file = RiveFile.import(data);
      final tempArtboard = file.mainArtboard;
      tempArtboard.addController(SimpleAnimation(
          isCollected.value ? 'idle_selected' : 'idle_unselected'));
      artboard.value = tempArtboard;
    });
    init(Get.arguments!);
    super.onInit();
  }

  void init(VideoDetailPageParams _videoDetailPageParams) {
    // 销毁
    // 清理
    videoDetailPageParams = _videoDetailPageParams;
    // videoDetailPageParams = Get.arguments;
    _getVideoDetailById();
    initDB();
    userEtController.value.addListener(() {});
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.value!.dispose();
    // insertData(durations);
    userEtController.value.dispose();
    _controller1?.dispose();
    _controller2?.dispose();
  }

  // @override
  // void dispose() {
  //   tabController.value!.dispose();
  //   insertData(durations);
  //   userEtController.value.dispose();
  //   _controller1?.dispose();
  //   _controller2?.dispose();
  //   super.dispose();
  // }

  void _getVideoDetailById() async {
    Map<String, Object> params = {
      'ac': 'detail',
      'ids': videoDetailPageParams.vodId,
    };
    isPageLoading.value = true;
    // List<VideoDetail> model =  await _videoService.getVideoDetailById(params);
    // getVideoDetail.value = model[0];
    getVideoDetail.value = await _videoService.getVideoDetailById(params);
    sameTypeVideoController.value!.setVideoDetail(getVideoDetail.value!);
    sameTypeVideoController.value!.onRefresh();
    String vodPlayUrl = getVideoDetail.value!.vodPlayUrl;
    if (vodPlayUrl.isNotEmpty) {
      urlInfo = vodPlayUrl.split('#').map((e) => e.split('\$')).toList();
      playWithIndex(0);
    }
    isPageLoading.value = false;
  }

  void initDB() async {
    TablesInit tables = TablesInit();
    tables.init();
    dbUtil = new DBUtil();
    queryData();
  }

  void queryData() async {
    return;
    await dbUtil.open();
    List<Map> collectedDate = await dbUtil.queryListByHelper(
        'collection_detail',
        ['vod_id'],
        'vod_id=?',
        [videoDetailPageParams.vodId]);
    List<Map> data = await dbUtil
        .queryList("SELECT * FROM video_play_record ORDER By create_time DESC");
    videoHistoryList = data.map((i) => VideoHistoryItem.fromJson(i)).toList();
    isCollected.value = collectedDate.length > 0;
    togglePlay();
    await dbUtil.close();
  }

  Future<void> insertData(StoreDuration item) async {
    await dbUtil.open();
    List<VideoHistoryItem> searchedList = videoHistoryList
        .where((element) => element.vodId == getVideoDetail.value!.vodId)
        .toList();
    if (searchedList.length > 0) {
      await dbUtil.update(
          'UPDATE video_play_record SET create_time = ? , vod_epo = ?, watched_duration = ?, total = ?  WHERE vod_id = ?',
          [
            StringsHelper.getCurrentTimeMillis(),
            currentEpo,
            item.currentPosition,
            item.totalDuration,
            videoDetailPageParams.vodId
          ]);
    } else if (item.currentPosition > 0) {
      Map<String, Object> par = Map<String, Object>();
      par['create_time'] = StringsHelper.getCurrentTimeMillis();
      par['vod_id'] = videoDetailPageParams.vodId;
      par['vod_name'] = videoDetailPageParams.vodName;
      par['vod_pic'] = videoDetailPageParams.vodPic;
      par['vod_epo'] = currentEpo;
      par['total'] = item.totalDuration.toString();
      par['watched_duration'] = item.currentPosition;
      await dbUtil.insertByHelper('video_play_record', par);
    }
    await dbUtil.close();
    queryData();
  }

  void setDurations(StoreDuration item) {
    durations = item;
  }

  void initCheckBoxStates({int? index, bool? value}) {
    checkBoxStates.clear();
    for (int i = 0; i < myCollectionsList.length; i++) {
      if (index == i) {
        checkBoxStates.add(value!);
      } else {
        checkBoxStates.add(false);
      }
    }
  }

  void initVideoNumbers() async {
    await dbUtil.open();
    collectedVideoNumbers.clear();
    for (int i = 0; i < myCollectionsList.length; i++) {
      var allData = await dbUtil.queryList(
          "SELECT count(vod_id) as count FROM collection_detail where collect_id = ${myCollectionsList[i].collectId}");
      collectedVideoNumbers.add(allData[0]['count']);
    }
    // setState(() {});
    await dbUtil.close();
  }

  queryCollectionData() async {
    await dbUtil.open();
    List<Map> data;
    data = await dbUtil
        .queryList("SELECT * FROM my_collections ORDER By create_time DESC");
    if (data.isEmpty) {
      Map<String, Object> par = Map<String, Object>();
      par['create_time'] = StringsHelper.getCurrentTimeMillis();
      par['collect_name'] = '默认收藏夹';
      par['img'] = AssetsData.collectionDefaultImg;
      await dbUtil.insertByHelper('my_collections', par);
      data = await dbUtil
          .queryList("SELECT * FROM my_collections ORDER By create_time DESC");
    }
    myCollectionsList.value =
        data.map((i) => MyCollectionItem.fromJson(i)).toList();
    initCheckBoxStates();
    initVideoNumbers();
    await dbUtil.close();
  }

  void insertCollectionData(context) async {
    if (userEtController.value.text.trim() == '') {
      CommonToast.show(
          context: context, message: "创建失败，不能输入空的文件夹名", type: ToastType.fail);
    } else {
      await dbUtil.open();
      List<MyCollectionItem> searchedList = myCollectionsList
          .where(
              (element) => element.collectName == userEtController.value.text)
          .toList();
      if (searchedList.length > 0) {
        await dbUtil.update(
            'UPDATE my_collections SET create_time = ? WHERE collect_name = ?',
            [
              StringsHelper.getCurrentTimeMillis(),
              userEtController.value.text
            ]);
        CommonToast.show(
            context: context, message: "创建失败，文件夹名已存在", type: ToastType.fail);
      } else {
        Map<String, Object> par = Map<String, Object>();
        par['create_time'] = StringsHelper.getCurrentTimeMillis();
        par['collect_name'] = userEtController.value.text;
        par['img'] = AssetsData.collectionDefaultImg;
        await dbUtil.insertByHelper('my_collections', par);
        CommonToast.show(context: context, message: "创建成功");
      }
      userEtController.value.text = '';
      await dbUtil.close();
      queryCollectionData();
    }
  }

  void insertCollectionDetailData(context) async {
    await dbUtil.open();
    Map<String, Object> par = Map<String, Object>();
    par['create_time'] = StringsHelper.getCurrentTimeMillis();
    par['collect_id'] = currentSelectCollection.value;
    par['vod_id'] = videoDetailPageParams.vodId;
    par['vod_pic'] = videoDetailPageParams.vodPic;
    par['vod_name'] = videoDetailPageParams.vodName;
    await dbUtil.insertByHelper('collection_detail', par);
    CommonToast.show(context: context, message: "收藏成功");
    isCollected.value = true;
    togglePlay();
    await dbUtil.close();
  }

  void cancelCollection(context) async {
    await dbUtil.open();
    await dbUtil.delete('DELETE FROM collection_detail WHERE vod_id = ?',
        [videoDetailPageParams.vodId]);
    CommonToast.show(context: context, message: "取消收藏成功");
    isCollected.value = false;
    togglePlay();
    currentSelectCollection.value = 0;
    await dbUtil.close();
  }

  void handleOnCollect(context) {
    if (!isCollected.value) {
      queryCollectionData();
      showSheet.value = !isCollected.value;
    } else {
      CommonDialog.showAlertDialog(context,
          title: '提示',
          content: '确定要取消收藏吗？',
          onConfirm: () => cancelCollection(context));
    }
  }

  void setShowSSheet(value) => showSheet.value = value;

  void setReverse() => reverse.value = !reverse.value;
  void setCurrentIndex(index) => currentIndex.value = index;

  void togglePlay() {
    if (isCollected.value) {
      doSelect();
    } else {
      doUnSelect();
    }
  }

  void doSelect() {
    if (_controller1 != null) {
      artboard.value?.removeController(_controller1!);
    }
    _controller1 = SimpleAnimation('selected');
    artboard.value?.addController(_controller1!);
  }

  void doUnSelect() {
    if (_controller2 != null) {
      artboard.value?.removeController(_controller2!);
    }
    _controller2 = SimpleAnimation('unselected');
    artboard.value?.addController(_controller2!);
  }
}
