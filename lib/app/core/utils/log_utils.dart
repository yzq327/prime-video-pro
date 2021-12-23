
import 'package:prime_video_pro/app/data/provider/http_options.dart';

class LogUtils {
  static void _print(String msg) {
    if (HttpOptions.isInDebugMode) print(msg);
  }

  static void printLog(String logContent, {int showLength = 500, String ? tag}) {
    if (HttpOptions.isInDebugMode) {
      if (logContent.length > showLength) {
        String show = logContent.substring(0, showLength);
        _print(show);
        /*剩余的字符串如果大于规定显示的长度，截取剩余字符串进行递归，否则打印结果*/
        if ((logContent.length - showLength) > showLength) {
          String partLog = logContent.substring(showLength, logContent.length);
          printLog(partLog, showLength: showLength);
        } else {
          String printLog = logContent.substring(showLength, logContent.length);
          _print(printLog);
        }
      } else {
        _print(logContent);
      }
    }
  }
}
