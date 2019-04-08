import 'dart:async';
import 'package:flutter_muyi/data/api/video/video_api.dart';
import 'package:flutter_muyi/data/bean/videos.dart';
import 'package:flutter_muyi/log/mlog.dart';

class VideoRepository{

  VideoApi _videoApi;

  VideoRepository(VideoApi api){
    MLog.d("init VideoRepository");
    this._videoApi = api;
  }

  Future<VideoListBean> getVideoListByType(int type) async{
    // api返回刷新数据
    VideoListBean videoListBean = await _videoApi.getVideoListByType(type);
    //TODO save to db

    return videoListBean;
  }

  Future<VideoListBean> getVideoListByKey(String key) async{
    // api返回刷新数据
    VideoListBean videoListBean = await _videoApi.getVideoListByKey(key);
    //TODO save to db

    return videoListBean;
  }



  Future<List<VideoBean>> getVideoListByLink(int type, int page) async{
    List<VideoBean> list = await _videoApi.getPageVideoList(type, page);
    //TODO save to db
    return list;
  }

  Future<List<VideoBean>> getSearchVideoListByLink(String key, int page) async{
    List<VideoBean> list = await _videoApi.getSearchVideoList(key, page);
    //TODO save to db
    return list;
  }

  Future<VideoDetailBean> getVideoDetailByLink(String link) async{
    VideoDetailBean videoDetailBean = await _videoApi.getVideoDetail(link);
    return videoDetailBean;
  }

}