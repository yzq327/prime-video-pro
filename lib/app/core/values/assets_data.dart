import 'package:flutter/material.dart';
import 'colors.dart';
import 'font_size.dart';

class AssetsData {

  //images
  static const String imageDir = "assets/images";
  static const String defaultImg = "$imageDir/default_img.png"; //加载失败默认图片
  static const String myImg = "$imageDir/my_img.png"; //我的头像
  static const String collectionDefaultImg = "$imageDir/my_default_collection_img.png"; //收藏夹默认头像
  static const String imageChatMineBg = '$imageDir/icon_chat_mine_bg.png'; //聊天页面我的背景图
  static const String imageChatOtherBg = '$imageDir/icon_chat_other_bg.png';

  //icons
  static Icon iconMyMessage =
  Icon(IconData(0xe8e4, fontFamily: 'iconfont_new'), color: SystemColors.primaryColor, size: FontSizes.fontSize20); //我的-我的消息



}
