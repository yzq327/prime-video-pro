import 'package:flutter/material.dart';
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

class DetailController extends GetxController {
  //TODO: Implement DetailController

  final VideoService _videoService = Get.find();
  final RxBool isPageLoading = false.obs;
  final RxBool isCollected = false.obs;
  final RxInt currentSelectCollection = 0.obs;

  late VideoDetail getVideoDetail;
  TabController? tabController;
  String? videoUrl;
  List? urlInfo = [];
  List<VideoHistoryItem> videoHistoryList = [];
  late DBUtil dbUtil;
  String currentEpo = '';
  late StoreDuration durations;
  RxBool showSheet = false.obs;
  List<MyCollectionItem> myCollectionsList = [];
  List<int> collectedVideoNumbers = [];
  TextEditingController userEtController = TextEditingController();
  List<bool> checkBoxStates = [];

  late VideoDetailPageParams videoDetailPageParams;

  // bool get isFullScreen =>
  //     MediaQuery.of(context).orientation == Orientation.landscape

  bool isFullScreen (context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  void _playWithIndex(int index) {
    videoUrl = urlInfo![index][1];
    currentEpo = urlInfo![index][0];
  }


  @override
  void onInit() {
    videoDetailPageParams = Get.arguments;
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _getVideoDetailById();
    initDB();
    userEtController.addListener(() {
      // setState(() {});
    });
  }

  void _getVideoDetailById() async {
    Map<String, Object> params = {
      'ac': 'detail',
      'ids': videoDetailPageParams.vodId,
    };
    isPageLoading.value = true;
    getVideoDetail = await _videoService.getVideoDetailById(params);
    String vodPlayUrl = getVideoDetail.vodPlayUrl;
    if (vodPlayUrl.isNotEmpty) {
      urlInfo = vodPlayUrl.split('#').map((e) => e.split('\$')).toList();
      _playWithIndex(0);
    }
    isPageLoading.value = false;
    print('getVideoDetail-------${getVideoDetail.vodName}');
  }

  void initDB() async {
    TablesInit tables = TablesInit();
    tables.init();
    dbUtil = new DBUtil();
    queryData();
  }

  void queryData() async {
    await dbUtil.open();
    List<Map> collectedDate = await dbUtil.queryListByHelper(
        'collection_detail', ['vod_id'], 'vod_id=?', [videoDetailPageParams.vodId]);
    List<Map> data = await dbUtil
        .queryList("SELECT * FROM video_play_record ORDER By create_time DESC");
    videoHistoryList = data.map((i) => VideoHistoryItem.fromJson(i)).toList();
    isCollected.value = collectedDate.length > 0;
    await dbUtil.close();
  }

  Future<void> insertData(StoreDuration item) async {
    await dbUtil.open();
    List<VideoHistoryItem> searchedList = videoHistoryList
        .where((element) => element.vodId == getVideoDetail.vodId)
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

  @override
  void dispose() {
    tabController!.dispose();
    insertData(durations);
    userEtController.dispose();
    super.dispose();
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
    // setState(() {});
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
    if(data.isEmpty) {
      Map<String, Object> par = Map<String, Object>();
      par['create_time'] = StringsHelper.getCurrentTimeMillis();
      par['collect_name'] = '默认收藏夹';
      par['img'] = AssetsData.collectionDefaultImg;
      await dbUtil.insertByHelper('my_collections', par);
      data = await dbUtil
          .queryList("SELECT * FROM my_collections ORDER By create_time DESC");
    }
    myCollectionsList =
        data.map((i) => MyCollectionItem.fromJson(i)).toList();
    initCheckBoxStates();
    initVideoNumbers();
    await dbUtil.close();
  }

  void insertCollectionData(context) async {
    if(userEtController.text.trim() == '') {
      CommonToast.show(
          context: context,
          message: "创建失败，不能输入空的文件夹名",
          type: ToastType.fail
      );
    } else {
      await dbUtil.open();
      List<MyCollectionItem> searchedList = myCollectionsList
          .where((element) => element.collectName == userEtController.text)
          .toList();
      if (searchedList.length > 0) {
        await dbUtil.update(
            'UPDATE my_collections SET create_time = ? WHERE collect_name = ?',
            [StringsHelper.getCurrentTimeMillis(), userEtController.text]);
        CommonToast.show(
            context: context,
            message: "创建失败，文件夹名已存在",
            type: ToastType.fail);
      } else {
        Map<String, Object> par = Map<String, Object>();
        par['create_time'] = StringsHelper.getCurrentTimeMillis();
        par['collect_name'] = userEtController.text;
        par['img'] = AssetsData.collectionDefaultImg;
        await dbUtil.insertByHelper('my_collections', par);
        CommonToast.show(context: context, message: "创建成功");
      }
      userEtController.text = '';
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
    await dbUtil.close();
  }

  void cancelCollection(context) async {
    await dbUtil.open();
    await dbUtil.delete('DELETE FROM collection_detail WHERE vod_id = ?',
        [videoDetailPageParams.vodId]);
    CommonToast.show(context: context, message: "取消收藏成功");
    isCollected.value = false;
    currentSelectCollection.value = 0;
    await dbUtil.close();
  }

  void handleOnCollect(bool value, context) {
    if (value) {
      queryCollectionData();
      showSheet.value = value;
    } else {
      CommonDialog.showAlertDialog(context,
          title: '提示',
          content: '确定要取消收藏吗？',
          onConfirm: () => cancelCollection(context));
    }
  }

  void setShowSSheet(value) => showSheet.value = value;


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
