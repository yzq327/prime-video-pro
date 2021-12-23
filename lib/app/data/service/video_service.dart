import 'package:get/get.dart';
import 'package:prime_video_pro/app/data/model/video_detail_list_model.dart';
import 'package:prime_video_pro/app/data/provider/http_options.dart';
import 'package:prime_video_pro/app/data/model/video_list_model.dart';
import 'package:prime_video_pro/app/data/model/video_type_list_model.dart';
import 'package:prime_video_pro/app/data/provider/http_provider.dart';

class VideoService {
  final HttpProvider _httpProvider = Get.find();
  Future<List<VideoType>> getTypeList() async {
    final res = await  _httpProvider.get(HttpOptions.baseUrl);
    final VideoTypeListModel model = VideoTypeListModel.fromJson(res.data);
    return model.typeList;
  }

  Future<VideoListModel> getVideoList( Map<String, dynamic>? queryParameters) async {
    final res = await  _httpProvider.get(HttpOptions.baseUrl, queryParameters: queryParameters);
    VideoListModel model = VideoListModel.fromJson(res.data);
    return model;
  }

  Future<VideoDetail> getVideoDetailById( Map<String, dynamic>? queryParameters) async {
    final res = await  _httpProvider.get(HttpOptions.baseUrl, queryParameters: queryParameters);
    VideoDetailListModel model = VideoDetailListModel.fromJson(res.data);
    return model.list[0];
  }
}