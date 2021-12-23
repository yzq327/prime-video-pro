import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_icon.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/controllers/detail_controller.dart';
import 'package:rive/rive.dart';

class VideoInfoContent extends GetView<DetailController> {
  Widget _buildSelectVideo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText.mainTitle('选集'),
            GestureDetector(
              child: Icon(IconFont.icon_daoxu, color: SystemColors.primaryColor),
              onTap: controller.setReverse,
            ),
          ],
        ),
        SizedBox(height: SpaceData.spaceSizeHeight18),
        Container(
          height: SpaceData.spaceSizeHeight44,
          width: double.infinity,
          child: GridView.builder(
            reverse: controller.reverse.value,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.45,
              mainAxisSpacing: SpaceData.spaceSizeWidth8,
            ),
            itemCount: controller.urlInfo!.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == controller.currentIndex.value
                      ? SystemColors.darkBlueColor
                      : SystemColors.darkWhiteColor,
                  borderRadius: BorderRadius.circular(SpaceData.spaceSizeWidth2),
                ),
                child: CommonText.text18(controller.urlInfo![index][0],
                    color: index == controller.currentIndex.value
                        ? SystemColors.hoverThemeBgColor
                        : SystemColors.blackColor),
              ),
              onTap: () {
                controller.setCurrentIndex(index);
                controller.playWithIndex(index);

              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCollection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.mainTitle(controller.getVideoDetail.vodName),
        GestureDetector(
          onTap: () => controller.handleOnCollect(context),
          child: Container(
            width: SpaceData.spaceSizeWidth36,
            height: SpaceData.spaceSizeWidth36,
            child: controller.artboard != null ? Rive(artboard: controller.artboard!) : Container(),
          ),
        ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceData.spaceSizeWidth20),
      child: ListView(
        children: [
          _buildAddCollection(context),
          SizedBox(height: SpaceData.spaceSizeHeight18),
          Obx(()=> controller.urlInfo!.length > 0 ? _buildSelectVideo() : Container()),
          SizedBox(height: SpaceData.spaceSizeHeight18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.mainTitle('介绍'),
              SizedBox(height: SpaceData.spaceSizeHeight12),
              CommonText.normalText('导演：${controller.getVideoDetail.vodDirector}'),
              CommonText.normalText('主演：${controller.getVideoDetail.vodActor}'),
              CommonText.normalText('年代：${controller.getVideoDetail.vodYear}'),
              CommonText.normalText('语言：${controller.getVideoDetail.vodLang}'),
              CommonText.normalText('介绍：${controller.getVideoDetail.vodContent}',
                  overflow: TextOverflow.visible, textAlign: TextAlign.left),
            ],
          ),
        ],
      ),
    );
  }
}
