import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/common_hint_text_contain.dart';
import 'package:prime_video_pro/app/global_widgets/common_img_display.dart';
import 'package:prime_video_pro/app/global_widgets/common_smart_refresher.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/controllers/detail_controller.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/local_widgets/video_info/same_type_video_controller.dart';
import 'package:prime_video_pro/app/routes/app_pages.dart';

class SameTypeVideoContent extends StatelessWidget {
  final SameTypeVideoController controller;
  const SameTypeVideoContent({Key? key, required this.controller})
      : super(key: key);

  Widget _buildRecommendVideo(int index) {
    return Obx(() => index == controller.getVideoList.length
        ? Container(
            height: SpaceData.spaceSizeHeight60,
            alignment: Alignment.center,
            child: CommonText.normalText('没有更多同类型影片啦',
                color: SystemColors.subThemeBgColor),
          )
        : Container(
            margin: EdgeInsets.only(
              left: SpaceData.spaceSizeWidth20,
              bottom: SpaceData.spaceSizeHeight8,
              right: SpaceData.spaceSizeWidth16,
            ),
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: SpaceData.spaceSizeHeight104,
                    width: SpaceData.spaceSizeWidth160,
                    child: CommonImgDisplay(
                        vodPic: controller.getVideoList[index].vodPic,
                        vodId: controller.getVideoList[index].vodId,
                        vodName: controller.getVideoList[index].vodName,
                        recordRoute: false)),
                SizedBox(width: SpaceData.spaceSizeWidth18),
                Expanded(
                  child: Obx(() => GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.text18(
                                  controller.getVideoList[index].vodName),
                              SizedBox(
                                height: SpaceData.spaceSizeHeight8,
                              ),
                              CommonText.text18(
                                  "评分：${controller.getVideoList[index].vodScore}",
                                  color: SystemColors.subTextColor),
                              SizedBox(
                                height: SpaceData.spaceSizeHeight8,
                              ),
                              CommonText.text14(
                                  "上线年份： ${controller.getVideoList[index].vodYear}",
                                  color: SystemColors.hoverThemeBgColor),
                            ],
                          ),
                        ),
                        onTap: () {
                          controller.onVideoDetailPageParamsChanged(
                              VideoDetailPageParams(
                                  vodId: controller.getVideoList[index].vodId,
                                  vodName:
                                      controller.getVideoList[index].vodName,
                                  vodPic:
                                      controller.getVideoList[index].vodPic));
                          // Get.offNamed(Routes.DETAIL,
                          //     preventDuplicates: false,
                          //     arguments: VideoDetailPageParams(
                          //         vodId: controller.getVideoList[index].vodId,
                          //         vodName:
                          //             controller.getVideoList[index].vodName,
                          //         vodPic:
                          //             controller.getVideoList[index].vodPic));
                        },
                      )),
                )
              ],
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => controller.isLoading.value && controller.getVideoList.length == 0
            ? CommonHintTextContain(text: '加载中')
            : controller.getVideoList.length == 0
                ? CommonHintTextContain(text: '暂无同类型影片，看看其他的吧')
                : Obx(() => CommonSmartRefresher(
                    enablePullUp: controller.enablePullUp,
                    controller: controller.refreshController.value,
                    onRefresh: controller.onRefresh,
                    onLoading: controller.onLoading,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.enablePullUp
                          ? controller.getVideoList.length
                          : controller.getVideoList.length + 1,
                      itemBuilder: (context, index) {
                        return _buildRecommendVideo(index);
                      },
                    ))));
  }
}
