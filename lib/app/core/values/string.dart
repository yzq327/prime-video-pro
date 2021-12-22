
import 'package:flutter/cupertino.dart';

class StringsHelper {

  //判断是否包含特殊字符
  static bool isSpecialChar(String str) {
    RegExp regEx = RegExp("[\$()（）”“‘’\'\"]|-");
    return regEx.hasMatch(str);
  }

  //获取截止秒的时间
  static String getCurrentTimeMillis() {
    return DateTime.now().toLocal().toString().substring(0,19);
  }

  //转换duration
  static String formatDuration(Duration? duration) {
    //padLeft: 如果字符串没有'2'的长度，则在前面加上字符串'0'并返回,不会改变原字符串
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if(duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

  }

  //获取widget的size
  static Size getWidgetSize (BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

