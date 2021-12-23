import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/values/assets_data.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';

class CommonImg extends StatelessWidget {
  final String vodPic;

  CommonImg({required this.vodPic});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: vodPic,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          SizedBox(
            width: SpaceData.spaceSizeHeight50,
            height: SpaceData.spaceSizeHeight50,
            child: Center(
              child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  strokeWidth: 2.0, color: SystemColors.primaryColor),
            ),
          ),
      errorWidget: (context, url, error) => Image.asset(AssetsData.defaultImg),
    );
  }
}
