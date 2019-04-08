import 'dart:async';
import 'package:flutter_muyi/data/api/video/video_parser.dart';
import 'package:flutter_muyi/data/bean/videos.dart';
import 'package:flutter_muyi/log/mlog.dart';
import 'package:flutter_muyi/data/api/api.dart';
import 'package:flutter_muyi/data/api/api_options.dart';

class VideoApi extends Api{

  VideoApi(ApiOptions apiOptions):super(apiOptions);

  String getPageLink(int type, int page) {
    return "https://okzyw.com/?m=vod-type-id-$type-pg-$page.html";
  }

  String getSearchLink(String key, int page) {
    return "https://okzyw.com/index.php?m=vod-search-pg-$page-wd-$key.html";
  }

  /// 返回类型下影视
  Future<VideoListBean> getVideoListByType(int type) async {
    int total = 0;
    String url = "https://www.okzyw.com/?m=vod-type-id-$type.html";
    final response = await get(url);
    if (response.isSuccess) {
      total = VideoParser.parserPageCount(type, response.body);
      if (total <= 0) {
        MLog.d("获取链接失败");
        return null;
      }
      List<VideoBean> list = await getPageVideoList(type, 1);
      if (list == null || list.isEmpty) {
        MLog.d("获取List失败");
        return null;
      }
      return VideoListBean(total, list, type: type);
    } else {
      MLog.d("请求出错：${response.message}");
      return null;
    }
  }

  ///搜索影视返回最新影视
  Future<VideoListBean> getVideoListByKey(String key) async {
    String url = "https://okzyw.com/index.php?m=vod-search";
    Map<String, String> body = {"wd": key, "submit": "search"};
    final response = await post(url, body: body);
    if (response.isSuccess) {
      int total = VideoParser.parserSearchPageCount(key, response.body);
      MLog.d("共$total页");
      if (total <= 0) {
        MLog.d("获取链接失败");
        return null;
      }
      List<VideoBean> list = await getSearchVideoList(key, 1);
      if (list == null || list.isEmpty) {
        MLog.d("获取List失败");
        return null;
      }
      return VideoListBean(total, list, key: key);
    } else {
      MLog.d("请求出错：${response.message}");
      return null;
    }
  }

  /// 从列表页面获取电影
  Future<List<VideoBean>> getPageVideoList(int type, int page) async {
    String url = getPageLink(type, page);
    final response = await get(url);
    List<VideoBean> list = [];
    if (response.isSuccess) {
      list = VideoParser.parserListVideo(response.body);
    } else {
      MLog.d("请求出错：${response.message}");
    }
    return list;
  }

  /// 从搜索页面获取电影
  Future<List<VideoBean>> getSearchVideoList(String key, int page) async {
    String url = getSearchLink(key, page);
    final response = await get(url);
    List<VideoBean> list = [];
    if (response.isSuccess) {
      list = VideoParser.parserListVideo(response.body);
    } else {
      MLog.d("请求出错：${response.message}");
    }
    return list;
  }

  /// 获取页面的详情，包括播放链接
  Future<VideoDetailBean> getVideoDetail(String url) async {
    final response = await get(url);
    if (response.isSuccess) {
      return VideoParser.parserVideoDetail(response.body);
    }
    return null;
  }

}
