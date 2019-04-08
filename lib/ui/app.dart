import 'package:flutter/material.dart';
import 'package:flutter_muyi/ui/pages/home_page.dart';
import 'package:flutter_muyi/data/data_manager.dart';
import 'package:flutter_muyi/log/mlog.dart';
import 'package:flutter_muyi/ui/pages/video/home_video_page.dart';

class MuyiApp extends StatefulWidget {
  @override
  _MuyiAppState createState() => _MuyiAppState();
}

class _MuyiAppState extends State<MuyiApp> {

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init(){
    MLog.d("应用初始化");
    DataManager().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: HomePage()
    );
  }
}


