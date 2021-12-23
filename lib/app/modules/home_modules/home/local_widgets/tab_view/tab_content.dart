import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/common_hint_text_contain.dart';
import 'package:prime_video_pro/app/global_widgets/common_smart_refresher.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/recent_video_container.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/tab_content_controller.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/video_swiper.dart';

class TabContent extends StatelessWidget {
  final TabContentController controller;
  const TabContent({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CommonSmartRefresher(
      enablePullUp: controller.enablePullUp,
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: controller.isLoading.value && controller.videoList.isEmpty
          ? CommonHintTextContain(text: '数据加载中..')
          : controller.videoList.length > 0
          ? ListView(
        children: [
          VideoSwiper(controller: controller),
          RecentVideoContainer(controller: controller),
          Container(
            height: SpaceData.spaceSizeHeight60,
            alignment: Alignment.center,
            child: CommonText.normalText(
                controller.enablePullUp ? '' : '没有更多数据了!',
                color: SystemColors.subThemeBgColor),
          )
        ],
      )
          : CommonHintTextContain(),
    ));
  }
}
