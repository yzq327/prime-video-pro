import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_icon.dart';
import 'package:prime_video_pro/app/core/values/font_size.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/views/home_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mine/views/mine_view.dart';
import 'package:prime_video_pro/app/modules/search_modules/search/views/search_view.dart';

import '../controllers/main_controller.dart';
class _NavigationBarItem {
  IconData icon;
  _NavigationBarItem(this.icon);
}


class MainView extends GetView<MainController> {
  List<_NavigationBarItem> get _getBottomNavigationList {
    return [
      _NavigationBarItem(IconFont.icon_home_fill),
      _NavigationBarItem(IconFont.icon_search),
      _NavigationBarItem(IconFont.icon_wode_F),
    ];
  }
  List<Widget> _buildIndexedStack() {
    return <Widget>[
      HomeView(),
      SearchView(),
      MineView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: null,
      body: GetBuilder<MainController>(builder: (main) {
        return IndexedStack(
          index: main.stackIndex,
          children: _buildIndexedStack(),
        );
      },),
      bottomNavigationBar: GetBuilder<MainController>(builder: (main) {
          return BottomNavigationBar(
            backgroundColor: SystemColors.themeBgColor,
            elevation: 0.0,
            iconSize: FontSizes.fontSize26,
            type: BottomNavigationBarType.fixed,
            currentIndex: main.stackIndex,
            onTap: controller.onItemTapped,
            items: _getBottomNavigationList
                .asMap()
                .keys
                .map((index) => _buildBottomNavigationBarItem(index))
                .toList(),
          );
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
          width: ScreenUtil().setWidth(26),
          height: ScreenUtil().setWidth(26),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: SpaceData.spaceSizeHeight16),
              child: GetBuilder<MainController>(builder: (main) {
                  return Icon(_getBottomNavigationList[index].icon,
                      color: main.stackIndex == index
                          ? SystemColors.hoverThemeBgColor
                          : SystemColors.subTextColor);
                }
              ))),
      label: '',
    );
  }
}
