import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_size.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/common_hint_text_contain.dart';
import 'package:prime_video_pro/app/global_widgets/common_smart_refresher.dart';
import 'package:prime_video_pro/app/modules/home/local_widgets/stub_tab_indicator.dart';
import 'package:prime_video_pro/app/modules/mineAbout/views/mine_about_view.dart';

import '../controllers/home_controller.dart';

class TabContent extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (home) {
          return CommonSmartRefresher(
            enablePullUp: home.enablePullUp,
            controller: home.refreshController,
            onRefresh: home.onRefresh,
            onLoading: home.onLoading,
            child: home.isLoading && home.getVideoList.length == 0
                ? CommonHintTextContain(text: '数据加载中..')
                : home.getVideoList.length > 0
                    ? ListView(
                        children: [
                          // VideoSwiper(videoList: getVideoList),
                          // RecentVideoContainer(videoList: getVideoList),
                          Container(
                            height: SpaceData.spaceSizeHeight60,
                            alignment: Alignment.center,
                            child: CommonText.normalText(
                                home.enablePullUp ? '' : '没有更多数据了!',
                                color: SystemColors.subThemeBgColor),
                          )
                        ],
                      )
                    : CommonHintTextContain(),
          );
        });
  }
}
