import 'package:get/get.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/bindings/detail_binding.dart';
import 'package:prime_video_pro/app/modules/home_modules/detail/views/detail_view.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/bindings/home_binding.dart';
import 'package:prime_video_pro/app/modules/home_modules/home/views/home_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mine/bindings/mine_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mine/views/mine_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineAbout/bindings/mine_about_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineAbout/views/mine_about_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineActivities/bindings/mine_activities_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineActivities/views/mine_activities_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineCollection/bindings/mine_collection_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineCollection/views/mine_collection_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineCollectionDetail/bindings/mine_collection_detail_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineCollectionDetail/views/mine_collection_detail_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineHistory/bindings/mine_history_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineHistory/views/mine_history_view.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineWeb/bindings/mine_web_binding.dart';
import 'package:prime_video_pro/app/modules/mine_modules/mineWeb/views/mine_web_view.dart';
import 'package:prime_video_pro/app/modules/search_modules/search/bindings/search_binding.dart';
import 'package:prime_video_pro/app/modules/search_modules/search/views/search_view.dart';
import 'package:prime_video_pro/app/modules/search_modules/searchResult/bindings/search_result_binding.dart';
import 'package:prime_video_pro/app/modules/search_modules/searchResult/views/search_result_view.dart';

import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_RESULT,
      page: () => SearchResultView(),
      binding: SearchResultBinding(),
    ),
    GetPage(
      name: _Paths.MINE,
      page: () => MineView(),
      binding: MineBinding(),
    ),
    GetPage(
      name: _Paths.MINE_HISTORY,
      page: () => MineHistoryView(),
      binding: MineHistoryBinding(),
    ),
    GetPage(
      name: _Paths.MINE_COLLECTION,
      page: () => MineCollectionView(),
      binding: MineCollectionBinding(),
    ),
    GetPage(
      name: _Paths.MINE_ABOUT,
      page: () => MineAboutView(),
      binding: MineAboutBinding(),
    ),
    GetPage(
      name: _Paths.MINE_COLLECTION_DETAIL,
      page: () => MineCollectionDetailView(),
      binding: MineCollectionDetailBinding(),
    ),
    GetPage(
      name: _Paths.MINE_ACTIVITIES,
      page: () => MineActivitiesView(),
      binding: MineActivitiesBinding(),
    ),
    GetPage(
      name: _Paths.MINE_WEB,
      page: () => MineWebView(),
      binding: MineWebBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
  ];
}
