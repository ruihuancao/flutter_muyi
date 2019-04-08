import 'package:sqflite/sqflite.dart';
import 'package:flutter_muyi/data/local/db_helper.dart';
import 'package:flutter_muyi/data/repository/video_repository.dart';
import 'package:flutter_muyi/data/api/video/video_api.dart';
import 'package:flutter_muyi/data/local/video_local.dart';
import 'package:flutter_muyi/log/mlog.dart';
import 'package:flutter_muyi/data/api/api_options.dart';

class DataManager {
  static final DataManager _instance = new DataManager._internal();
  factory DataManager() {
    return _instance;
  }
  DataManager._internal();

  Database _db;
  VideoApi _videoApi;
  VideoLocal _videoLocal;
  VideoRepository _videoRepository;

  ApiOptions _buildVideoApiOptions() {
    Map<String, String> videoConmonHeaders = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1"
    };
    ApiOptions videoApiOptions = ApiOptions(commonHeader: videoConmonHeaders);
    return videoApiOptions;
  }

  void init() async {
    MLog.d("init datamanager start");
    _videoApi = VideoApi(_buildVideoApiOptions());
    _db = await DBHelper.initDataBase();
    _videoLocal = VideoLocal(_db);
    MLog.d("init datamanager end");
  }

  VideoRepository provideVideoRepository() {
    if (_videoRepository == null) {
      _videoRepository = VideoRepository(_videoApi);
    }
    return _videoRepository;
  }
}
