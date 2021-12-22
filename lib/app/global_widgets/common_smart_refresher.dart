import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommonSmartRefresher extends StatefulWidget {
  late final Widget? child;
  late final Widget? header;
  late final Widget? footer;
  late final bool enablePullUp;
  late final bool enablePullDown;
  late final VoidCallback? onRefresh;
  late final VoidCallback? onLoading;
  late final RefreshController controller;

  CommonSmartRefresher({Key? key, this.child,
    this.header ,
    this.footer,
    this.enablePullUp = false,
    this.enablePullDown = true,
    this.onRefresh,
    this.onLoading,
    required this.controller})
      : super(key: key);

  _CommonSmartRefresherState createState() => _CommonSmartRefresherState();

}
class _CommonSmartRefresherState extends State<CommonSmartRefresher> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget RefreshHeaderContent() {
    return WaterDropHeader(
        refresh: CircularProgressIndicator(
            strokeWidth: 2.0, color: SystemColors.hoverThemeBgColor),
        waterDropColor: SystemColors.hoverThemeBgColor,
        complete: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.done,
              color: Colors.grey,
            ),
            Container(
              width: 15.0,
            ),
            CommonText.normalText('加载完成!', color: SystemColors.subThemeBgColor)
          ],
        ),
        idleIcon: Icon(
          Icons.autorenew,
          size: 20,
          color: Colors.white,
        ));
  }

  Widget RefreshFooterContent() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        String text;
        if (mode == LoadStatus.loading) {
          body = CircularProgressIndicator(
              strokeWidth: 2.0, color: SystemColors.hoverThemeBgColor);
        } else {
          if (mode == LoadStatus.idle) {
            text = '上拉加载更多';
          } else if (mode == LoadStatus.failed) {
            text = '加载失败！点击重试！';
          } else if (mode == LoadStatus.canLoading) {
            text = '松手即可加载更多!';
          } else {
            text = '没有更多数据了!';
          }
          body = CommonText.normalText(text, color: SystemColors.subThemeBgColor);
        }
        return Container(
          height: SpaceData.spaceSizeHeight60,
          child: body,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SmartRefresher(
        enablePullDown: widget.enablePullDown,
        enablePullUp: widget.enablePullUp,
        header: widget.header ?? RefreshHeaderContent(),
        footer: widget.footer ?? RefreshFooterContent(),
        controller: widget.controller,
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        child: widget.child);
  }
}
