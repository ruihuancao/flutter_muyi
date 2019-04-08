import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:flutter_muyi/data/bean/videos.dart';
import 'package:flutter_muyi/data/data_manager.dart';
import 'package:flutter_muyi/data/repository/video_repository.dart';
import 'package:flutter_muyi/ui/widget/statepage.dart';
import 'package:flutter_muyi/ui/pages/video/video_detail_page.dart';

class VideoTypeListPage extends StatefulWidget {
  final int type;

  VideoTypeListPage(this.type);

  @override
  _VideoTypeListPageState createState() => _VideoTypeListPageState();
}

class _VideoTypeListPageState extends State<VideoTypeListPage> with AutomaticKeepAliveClientMixin{
  List<VideoBean> list = [];
  RefreshController refreshController;
  StateController stateController;

  VideoListBean videoListBean;
  int current = 1;
  VideoRepository videoRepository;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    refreshController = new RefreshController();
    stateController = StateController();
    videoRepository = DataManager().provideVideoRepository();
    initData();
    super.initState();
  }

  void initData() async {
    debugPrint("init");
    videoListBean =
    await videoRepository.getVideoListByType(widget.type);
    if(videoListBean == null || videoListBean.list == null || videoListBean.list.length <= 0){
      debugPrint("下拉刷新数据失败：type:"+widget.type.toString());
      stateController.showError();
    }else{
      debugPrint("下拉刷新数据成功type:"+widget.type.toString());
      list.clear();
      current = 1;
      setState(() {
        list.addAll(videoListBean.list);
      });
      stateController.showConetent();
    }
  }

  void _onRefresh(bool up) async {
    if (up) {
      debugPrint("下拉刷新数据");
      videoListBean =
      await videoRepository.getVideoListByType(widget.type);
      if(videoListBean == null || videoListBean.list == null || videoListBean.list.length <= 0){
        debugPrint("下拉刷新数据失败：type:"+widget.type.toString());
        refreshController.sendBack(true, RefreshStatus.failed);
      }else{
        debugPrint("下拉刷新数据成功type:"+widget.type.toString());
        list.clear();
        current = 1;
        setState(() {
          list.addAll(videoListBean.list);
        });
        refreshController.sendBack(true, RefreshStatus.completed);
      }
    } else {
      debugPrint("上拉加载更多,当前第${current}页,一共：${videoListBean.total}页");
      if(current < videoListBean.total){
        List<VideoBean> result = await videoRepository.getVideoListByLink(videoListBean.type, current+1);
        if (result == null) {
          debugPrint("上拉加载更多失败");
          refreshController.sendBack(false, RefreshStatus.failed);
        } else {
          debugPrint("上拉加载更多成功");
          current++;
          setState(() {
            list.addAll(result);
          });
          refreshController.sendBack(false, RefreshStatus.idle);
        }
      }else{
        debugPrint("上拉加载更多,已经加载所有");
        refreshController.sendBack(false, RefreshStatus.noMore);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatePage(
      content: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  child: ListTile.divideTiles(context: context, tiles: list.map((VideoBean item){
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(item.name.substring(0, 1)),
                      ),
                      title: Text(item.name),
                      subtitle: Text(item.date),
                    );
                  })).toList()[index],
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoDetailPage(list[index])),
                    );
                  },
                );
              }))
      ),
      controller: stateController,
    );
  }
}

class VideoItem extends StatelessWidget {
  final VideoBean videoBean;

  VideoItem(this.videoBean);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(videoBean.name),
      ),
      onTap: (){
        Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return VideoDetailPage(videoBean);
            }));
      },
    );
  }
}