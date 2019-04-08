import 'package:flutter/material.dart';
import 'package:flutter_muyi/data/bean/videos.dart';
import 'package:flutter_muyi/ui/widget/statepage.dart';
import 'package:flutter_muyi/data/data_manager.dart';
import 'package:flutter_muyi/data/repository/video_repository.dart';
import 'dart:ui' show ImageFilter;
import 'package:flutter_muyi/ui/widget/simple_view_player.dart';
import 'package:flutter_muyi/log/mlog.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoBean videoBean;

  VideoDetailPage(this.videoBean);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  StateController _stateController;
  VideoRepository _videoRepository;
  VideoDetailBean _videoDetailBean;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _stateController = StateController();
    _videoRepository = DataManager().provideVideoRepository();
    _tabController = new TabController(length: 2, vsync: this);
    init();
  }

  void init() async {
    VideoDetailBean videoDetailBean =
        await _videoRepository.getVideoDetailByLink(widget.videoBean.link);
    if (videoDetailBean == null) {
      _stateController.showError();
    } else {
      _stateController.showConetent();
      _videoDetailBean = videoDetailBean;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _videoDetailBean == null
            ? AppBar(
                title: Text(widget.videoBean.name),
              )
            : null,
        body: StatePage(
          content: Container(
            child: _videoDetailBean == null
                ? Container()
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          title: Text(widget.videoBean.name),
                          expandedHeight: 280.0,
                          pinned: true,
                          snap: false,
                          floating: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              _videoDetailBean.image),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.srcOver))),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 68.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Image.network(
                                            _videoDetailBean.image,
                                            width: 135.0,
                                            height: 192.0,
                                            fit: BoxFit.cover,
                                          ),
                                          padding: EdgeInsets.all(12.0),
                                        ),
                                        Expanded(
                                            child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: _videoDetailBean.infoList
                                                .map((text) {
                                              return Text(
                                                text,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }).toList(),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              labelColor: Colors.black87,
                              unselectedLabelColor: Colors.grey,
                              controller: _tabController,
                              tabs: [
                                Tab(text: "视频介绍"),
                                Tab(text: "播放列表"),
                              ],
                            ),
                          ),
                        )
                      ];
                    },
                    body: TabBarView(controller: _tabController, children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          _videoDetailBean.detail,
                        ),
                      ),
                      ListView(
                        children:
                            _videoDetailBean.source.keys.toList().map((key) {
                          return ExpansionTile(
                            title: Text("播放源：$key"),
                            backgroundColor: Theme.of(context)
                                .accentColor
                                .withOpacity(0.025),
                            children: _videoDetailBean.source[key].map((text) {
                              return GestureDetector(
                                child: ListTile(
                                    title: Text(text.split("\$")[0]),
                                    trailing: Icon(Icons.play_circle_filled)),
                                onTap: () {
                                  tryPlay(text.split("\$")[1]);
                                },
                              );
                            }).toList(),
                          );
                        }).toList(),
                      )
                    ]),
                  ),
          ),
          controller: _stateController,
        ));
  }

  void tryPlay(String source) {
    MLog.d("play source: $source");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleViewPlayer(
                source,
                isFullScreen: true,
              ),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
