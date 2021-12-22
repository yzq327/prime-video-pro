import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';

class CommonHintTextContain extends StatelessWidget{
  final String? text;
  final double? height;

  CommonHintTextContain({this.text = '暂无数据', this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SystemColors.themeBgColor,
      height: height ?? SpaceData.spaceSizeHeight580,
      alignment: Alignment.center,
      child: CommonText.mainTitle(text,
          color: SystemColors.hoverThemeBgColor, overflow: TextOverflow.visible),
    );
  }
}
