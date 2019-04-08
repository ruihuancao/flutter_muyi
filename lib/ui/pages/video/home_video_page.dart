import 'package:flutter/material.dart';
import 'package:flutter_muyi/ui/pages/video/video_list_page.dart';
import 'package:flutter_muyi/ui/pages/video/video_search_page.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final List<VideoModel> _allPages = [
    VideoModel(text: '电影', type: 1),
    VideoModel(text: '连续剧', type: 2),
    VideoModel(text: '综艺', type: 3),
    VideoModel(text: '动漫', type: 4),
    VideoModel(text: '动作片', type: 5),
    VideoModel(text: '喜剧片', type: 6),
    VideoModel(text: '爱情片', type: 7),
    VideoModel(text: '科幻片', type: 8),
    VideoModel(text: '恐怖片', type: 9),
    VideoModel(text: '剧情片', type: 10),
    VideoModel(text: '战争片', type: 11),
    VideoModel(text: '国产剧', type: 12),
    VideoModel(text: '香港剧', type: 13),
    VideoModel(text: '韩国剧', type: 14),
    VideoModel(text: '欧美剧', type: 15),
    VideoModel(text: '台湾剧', type: 16),
    VideoModel(text: '日本剧', type: 17),
    VideoModel(text: '海外剧', type: 18),
    VideoModel(text: '纪录片', type: 19),
    VideoModel(text: '微电影', type: 20),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: _allPages.length,
        child: Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.search),
                            ),
                            Expanded(child: Container(
                              child: Text("输入关键词", style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontFamily: "Roboto"),),
                            )),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.menu),
                            )
                          ],
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoSearchPage()),
                  );
                },
              ),
              bottom: TabBar(
                tabs: _allPages.map((page) {
                  return Tab(text: page.text);
                }).toList(),
                isScrollable: true,
              ),
            ),
            body: TabBarView(
              children: _allPages.map((videoModel) {
                return VideoTypeListPage(videoModel.type);
              }).toList(),
            )));
  }
}

class VideoModel {
  String text;
  int type;

  VideoModel({this.text, this.type});
}
