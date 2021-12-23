import 'package:flutter/material.dart';

import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/global_widgets/common_img_display.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/local_widgets/tab_view/tab_content_controller.dart';


class VideoSwiper extends StatelessWidget {
  final TabContentController controller;

  const VideoSwiper({Key? key, required this.controller}) : super(key: key);

  Widget _buildPageViewItemWidget(int index) {
    return  Container(
      margin: EdgeInsets.only(right: SpaceData.spaceSizeWidth16),
      child: CommonImgDisplay(vodPic: controller.videoList[index].vodPic, vodId: controller.videoList[index].vodId, vodName: controller.videoList[index].vodName,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: SpaceData.spaceSizeWidth320/SpaceData.spaceSizeHeight172,
      child: Container(
        padding: EdgeInsets.fromLTRB(SpaceData.spaceSizeWidth16,0,0,0),
        decoration: BoxDecoration(
          color: SystemColors.themeBgColor,
        ),
        child:  NotificationListener(
          //当用户用手滑动轮播的时候取消定时器，然后在轮播滑动结束后重设定时器
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollStartNotification) {
              if (notification.dragDetails != null) {
                controller.timer.cancel();
              }
            } else if (notification is ScrollEndNotification) {
              controller.timer.cancel();
              controller.startTimer();
            }
            return true;
          },
          child: PageView.builder(
            itemBuilder: (BuildContext context, int index) => _buildPageViewItemWidget(index),
            controller: controller.pageController,
            itemCount: controller.videoList.length,
            pageSnapping: false,
            onPageChanged: (int index) {
              int newIndex;
              if (index == controller.videoList.length -1) {
                newIndex = 0;
                controller.pageController.jumpToPage(newIndex);
              } else {
                newIndex = index;
              }
              controller.updateCurrentIndex(newIndex);
            },
          ),
        ),
      ),
    );
  }
}
