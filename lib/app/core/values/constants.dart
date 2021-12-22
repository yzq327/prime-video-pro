import 'package:flutter/cupertino.dart';

import 'colors.dart';
import 'font_icon.dart';

class ToastType {
  static final String success = 'success';
  static final String fail = 'fail';
}

const Map<String, Color> ToastTypeColor = {
  'success': SystemColors.successBgColor,
  'fail': SystemColors.failBgColor,
};

const Map<String, IconData> ToastTypeIcon = {
  'success': IconFont.icon_chenggong,
  'fail': IconFont.icon_shibai,
};