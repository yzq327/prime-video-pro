import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/common_img_display.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/tab_content_controller.dart';

class RecentVideoContainer extends StatelessWidget {
  final TabContentController controller;
  const RecentVideoContainer({Key? key, required this.controller})
      : super(key: key);

  Widget _buildVideoInfo(int index) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SpaceData.spaceSizeWidth160,
              height: SpaceData.spaceSizeHeight200,
              child: CommonImgDisplay(
                  vodPic: controller.videoList[index].vodPic,
                  vodId: controller.videoList[index].vodId,
                  vodName: controller.videoList[index].vodName),
            ),
            Container(
                width: SpaceData.spaceSizeWidth160,
                alignment: Alignment.topLeft,
                margin:
                    EdgeInsets.symmetric(vertical: SpaceData.spaceSizeHeight8),
                child: CommonText.normalText(
                    controller.videoList.length > 0
                        ? controller.videoList[index].vodName
                        : '没有值',
                    color: SystemColors.mainTextColor)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpaceData.spaceSizeWidth400,
      color: SystemColors.themeBgColor,
      padding: EdgeInsets.symmetric(
          vertical: SpaceData.spaceSizeHeight8,
          horizontal: SpaceData.spaceSizeHeight16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: SpaceData.spaceSizeHeight16),
          child: CommonText.mainTitle('最新发布',
              color: SystemColors.hoverThemeBgColor),
        ),
        Obx(
          () => GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.66,
              mainAxisSpacing: SpaceData.spaceSizeHeight8,
              crossAxisSpacing: SpaceData.spaceSizeWidth16,
            ),
            itemCount: controller.videoList.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildVideoInfo(index),
          ),
        )
      ]),
    );
  }
}
