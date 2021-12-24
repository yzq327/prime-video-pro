import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/controllers/detail_controller.dart';
import 'package:prime_video_pro/app/routes/app_pages.dart';

import 'commom_image.dart';

class CommonImgDisplay extends StatelessWidget {
  final String vodPic;
  final int vodId;
  final String vodName;
  final bool? recordRoute;

  CommonImgDisplay(
      {required this.vodPic,
      required this.vodId,
      required this.vodName,
      this.recordRoute = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SpaceData.spaceSizeWidth12),
        child: CommonImg(vodPic: vodPic),
      ),
      onTap: () {
        if (recordRoute == true) {
          Get.toNamed(Routes.DETAIL,
              arguments: VideoDetailPageParams(
                  vodId: vodId, vodName: vodName, vodPic: vodPic));
        } else {
          Get.offAndToNamed(Routes.DETAIL,
              arguments: VideoDetailPageParams(
                  vodId: vodId, vodName: vodName, vodPic: vodPic));
        }
      },
    );
  }
}
