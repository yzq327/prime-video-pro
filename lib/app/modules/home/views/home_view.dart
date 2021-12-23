import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_size.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/modules/home/local_widgets/stub_tab_indicator.dart';
import 'package:prime_video_pro/app/modules/home/local_widgets/tab_view/tab_content.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  Widget _buildTab(item) {
    return Container(
      width: SpaceData.spaceSizeWidth110,
      child: Tab(text: item.typeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: SystemColors.themeBgColor,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CommonText.mainTitle('Prime', color: SystemColors.hoverThemeBgColor),
            SizedBox(width: SpaceData.spaceSizeWidth8),
            CommonText.mainTitle('Video'),
          ],
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: SpaceData.spaceSizeHeight16),
          color: SystemColors.themeBgColor,
          child: Obx(() => TabBar(
            controller: controller.tabController,
            padding: EdgeInsets.symmetric(horizontal: SpaceData.spaceSizeWidth16),
            labelStyle: TextStyle(fontSize: FontSizes.fontSize20),
            unselectedLabelStyle: TextStyle(fontSize: FontSizes.fontSize20),
            isScrollable: true,
            labelPadding: EdgeInsets.all(0),
            labelColor: SystemColors.hoverTextColor,
            unselectedLabelColor: SystemColors.primaryColor,
            indicatorWeight: 0.0,
            indicator: StubTabIndicator(color:SystemColors.hoverThemeBgColor),
            tabs: controller.getTypeList.map((e) => _buildTab(e)).toList(),
          )),
        ),
        Expanded(
          child: Obx(() => TabBarView(
            controller: controller.tabController,
            children: controller.tabContentControllerList.map((controller) => TabContent(controller: controller)).toList(),
          )),
        )
      ]),
    );
  }
}

