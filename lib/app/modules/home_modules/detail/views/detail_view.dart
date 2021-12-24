import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_icon.dart';
import 'package:prime_video_pro/app/core/values/font_size.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/commom_image.dart';
import 'package:prime_video_pro/app/global_widgets/common_dialog.dart';
import 'package:prime_video_pro/app/global_widgets/common_hint_text_contain.dart';
import 'package:prime_video_pro/app/global_widgets/common_toast.dart';
import 'package:prime_video_pro/app/global_widgets/coomom_video_player.dart';
import 'package:prime_video_pro/app/global_widgets/create_collect_dialog.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/local_widgets/video_info/video_info_content.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/stub_tab_indicator.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  Widget _buildVideoPlayer() {
    return Obx(() => CommonVideoPlayer(
          url: controller.videoUrl.value ?? '',
          vodName: controller.videoDetailPageParams.vodName,
          vodPic: controller.videoDetailPageParams.vodPic,
          height: SpaceData.spaceSizeHeight228,
          onStoreDuration: controller.setDurations,
          watchedDuration: controller.videoDetailPageParams.watchedDuration,
        ));
  }

  Widget _buildVideoTabBar(context) {
    return controller.isFullScreen(context)
        ? SizedBox()
        : Obx(() => TabBar(
              controller: controller.tabController.value,
              labelStyle: TextStyle(fontSize: FontSizes.fontSize20),
              padding: EdgeInsets.only(
                bottom: SpaceData.spaceSizeHeight16,
                left: SpaceData.spaceSizeWidth50,
              ),
              unselectedLabelStyle: TextStyle(fontSize: FontSizes.fontSize20),
              isScrollable: true,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: SpaceData.spaceSizeWidth50),
              labelColor: SystemColors.hoverTextColor,
              unselectedLabelColor: SystemColors.primaryColor,
              indicatorWeight: 0.0,
              indicator:
                  StubTabIndicator(color: SystemColors.hoverThemeBgColor),
              tabs: [Tab(text: '详情'), Tab(text: '猜你喜欢')],
            ));
  }

  Widget _buildCollectionDetail(int index) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: SpaceData.spaceSizeHeight80,
      margin: EdgeInsets.only(
        bottom: SpaceData.spaceSizeWidth10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(()=> Container(
              height: SpaceData.spaceSizeHeight80,
              width: SpaceData.spaceSizeWidth100,
              child: controller.myCollectionsList[index].img.startsWith('http')
                  ? ClipRRect(
                borderRadius:
                BorderRadius.circular(SpaceData.spaceSizeWidth12),
                child: CommonImg(
                    vodPic: controller.myCollectionsList[index].img),
              )
                  : Image.asset(
                controller.myCollectionsList[index].img,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ))),
          SizedBox(width: SpaceData.spaceSizeWidth16),
          Expanded(
            child:Obx(()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.text18(
                    controller.myCollectionsList[index].collectName),
                CommonText.text18(
                    "共 ${controller.collectedVideoNumbers.length > 0 ? controller.collectedVideoNumbers[index] : 0} 部",
                    color: SystemColors.subTextColor),
              ],
            )),
          ),
          Obx(() => GestureDetector(
            onTap: () {
              controller.currentSelectCollection.value = controller.checkBoxStates[index]? 0: controller.myCollectionsList[index].collectId;
              controller.initCheckBoxStates(index: index, value: !controller.checkBoxStates[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: controller.checkBoxStates[index]
                    ? SystemColors.primaryColor
                    : SystemColors.subThemeBgColor,
                borderRadius: BorderRadius.circular(SpaceData.spaceSizeWidth12),
              ),
              width: SpaceData.spaceSizeWidth20,
              height: SpaceData.spaceSizeWidth20,
              alignment: Alignment.center,
              child: !controller.checkBoxStates[index]
                  ? SizedBox()
                  : Container(
                decoration: BoxDecoration(
                  color: SystemColors.hoverThemeBgColor,
                  borderRadius:
                  BorderRadius.circular(SpaceData.spaceSizeWidth12),
                ),
                width: SpaceData.spaceSizeWidth12,
                height: SpaceData.spaceSizeWidth12,
                child: SizedBox(),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(context) {
    return Obx(()=> Positioned.fill(
        child: Offstage(
          offstage: !controller.showSheet.value,
          child: Container(
            color: SystemColors.sheetBgColor,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Container(
              margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
              padding: EdgeInsets.all(SpaceData.spaceSizeWidth24),
              decoration: BoxDecoration(
                color: SystemColors.sheetContentBgColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SpaceData.spaceSizeWidth20),
                    topRight: Radius.circular(SpaceData.spaceSizeWidth20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            controller.setShowSSheet(false);
                          },
                          child: Icon(
                            IconFont.icon_guanbi,
                            color: SystemColors.primaryColor,
                            size: SpaceData.spaceSizeWidth20,
                          )),
                      GestureDetector(
                          onTap: () {
                            CommonDialog.showAlertDialog(
                              context,
                              title: '新建收藏夹',
                              positiveBtnText: '创建',
                              onConfirm: () async {
                                controller.insertCollectionData(context);
                              },
                              onCancel: () => controller.userEtController.value.text = '',
                              content: CreateCollectDialog(
                                userEtController: controller.userEtController.value,
                                handleClear: () =>
                                controller.userEtController.value.text = '',
                              ),
                            );
                          },
                          child: Icon(
                            IconFont.icon_jia,
                            color: SystemColors.primaryColor,
                            size: SpaceData.spaceSizeWidth20,
                          )),
                    ],
                  ),
                  SizedBox(height: SpaceData.spaceSizeHeight24),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: controller.myCollectionsList.length,
                      itemBuilder: (context, index) {
                        return _buildCollectionDetail(index);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.currentSelectCollection == 0) {
                        CommonToast.show(context: context, message: "请选择收藏夹");
                      } else {
                        controller.insertCollectionDetailData(context);
                        controller.setShowSSheet(false);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: SpaceData.spaceSizeHeight8),
                      decoration: BoxDecoration(
                        color: SystemColors.hoverThemeBgColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SpaceData.spaceSizeWidth10)),
                      ),
                      child: CommonText.text18('加入收藏夹',
                          color: SystemColors.blackColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SystemColors.themeBgColor,
        appBar: PreferredSize(
            child: AppBar(
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(0)),
        body: Obx(() => controller.isPageLoading.value
            ? CommonHintTextContain(text: '数据加载中...')
            : Stack(
                children: [
                  Column(
                    children: [
                      _buildVideoPlayer(),
                      _buildVideoTabBar(context),
                      Expanded(
                          child: TabBarView(
                              controller: controller.tabController.value,
                              children: [
                            VideoInfoContent(),
                            CommonText.mainTitle('text'),
                            // VideoInfoContent(
                            //   getVideoDetail: getVideoDetail,
                            //   urlInfo: urlInfo,
                            //   onChanged: _playWithIndex,
                            //   isCollected: isCollected,
                            //   onCollected: handleOnCollect(context),
                            // ),
                            // SameTypeVideoContent(getVideoDetail: getVideoDetail),
                          ])),
                    ],
                  ),
                  _buildBottomSheet(context),
                ],
              )));
  }
}
