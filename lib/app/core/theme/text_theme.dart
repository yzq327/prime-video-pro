import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_size.dart';

class CommonText {
  //主标题
  static Widget mainTitle(text,
      {color = SystemColors.mainTextColor, textAlign = TextAlign.center, overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.mainTitleFontSize),
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  //常规标题
  static Widget normalTitle(text,
      {color = SystemColors.mainTextColor, textAlign = TextAlign.center, overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.normalTitleFontSize, fontWeight: FontWeight.bold),
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  //常规文本
  static Widget normalText(text,
      {color = SystemColors.mainTextColor, textAlign = TextAlign.center, overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.normalTitleFontSize, fontWeight: FontWeight.normal),
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  //深灰色20号字
  static Widget darkGrey20Text(text,
      {maxLines, overflow = TextOverflow.ellipsis, textAlign = TextAlign.center, FontWeight ? fontWeight}) {
    return Text(
      text,
      style: TextStyle(color: SystemColors.themeBgColor, fontSize: FontSizes.fontSize20, fontWeight: fontWeight),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  //自定义颜色24号字
  static Widget text24(text, {height, textAlign = TextAlign.start, color = SystemColors.primaryColor, TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.fontSize24, height: height),
      textAlign: textAlign,
      overflow: overflow,
    );
  }


  //自定义颜色18号字
  static Widget text18(text, {height, textAlign = TextAlign.start, color = SystemColors.primaryColor, TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.fontSize18, height: height),
      textAlign: textAlign,
      overflow: overflow,
    );
  }

//自定义颜色16号字-
  static Widget text16(text, {height, textAlign = TextAlign.start, color = SystemColors.primaryColor, FontWeight ?fontWeight,TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: FontSizes.fontSize16,
          height: height,
          fontWeight: fontWeight),
      textAlign: textAlign,
      overflow: overflow,
    );
  }


  //自定义颜色14号字
  static Widget text14(text,
      {height,maxLines,
        textAlign = TextAlign.start,
        color = SystemColors.primaryColor,
        TextDecoration ? textDecoration,
        TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.fontSize14, height: height, decoration: textDecoration),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  //自定义颜色12号字
  static Widget text12(text,
      {height,maxLines,
        textAlign = TextAlign.start,
        color = SystemColors.primaryColor,
        TextDecoration ? textDecoration,
        TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: FontSizes.fontSize12, height: height, decoration: textDecoration),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}



