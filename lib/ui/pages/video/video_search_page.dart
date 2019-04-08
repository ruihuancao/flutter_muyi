import 'package:flutter/material.dart';
import 'package:flutter_muyi/ui/widget/statepage.dart';
import 'package:flutter_muyi/data/repository/video_repository.dart';
import 'package:flutter_muyi/ui/pages/video/video_detail_page.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:flutter_muyi/data/bean/videos.dart';
import 'package:flutter_muyi/data/data_manager.dart';

class VideoSearchPage extends StatefulWidget {
  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> {

  TextEditingController controller;
  RefreshController refreshController;
  StateController stateController;

  List<VideoBean> list = [];
  VideoListBean videoListBean;
  int current = 1;
  VideoRepository videoRepository;
  List<String> historyList = [];
  bool isSearch = false;
  String key;

  @override
  void initState() {
    controller = TextEditingController();
    refreshController = new RefreshController();
    stateController = StateController();
    videoRepository = DataManager().provideVideoRepository();
    super.initState();
  }


  void _onRefresh(bool up) async {
    if (up) {
      debugPrint("下拉刷新数据");
    } else {
      debugPrint("上拉加载更多,当前第${current}页,一共：${videoListBean.total}页");
      if(current < videoListBean.total){
        List<VideoBean> result = await videoRepository.getSearchVideoListByLink(key, current+1);
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search(String query) async {
    setState(() {
      isSearch = true;
    });
    print('Search key: $query');
    if(videoListBean != null){
      stateController.showLoading();
    }
    videoListBean = await videoRepository.getVideoListByKey(query);
    if(videoListBean != null && videoListBean.list != null && videoListBean.list.length > 0){
      current = 1;
      key = query;
      list.clear();
      setState(() {
        list.addAll(videoListBean.list);
      });
      stateController.showConetent();
    }else{
      stateController.showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: IconTheme(
                data: Theme.of(context).iconTheme,
                child: Icon(Icons.arrow_back)),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          child: Center(
            child: TextField(
              controller: controller,
              autofocus: true,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: new InputDecoration.collapsed(hintText: "输入关键词"),
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontFamily: "Roboto"),
              onSubmitted: search,
            ),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            tooltip: 'Clear',
            icon: IconTheme(
                data: Theme.of(context).iconTheme,
                child: const Icon(Icons.clear)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: isSearch ? StatePage(
          controller: stateController, content: SmartRefresher(
          controller: refreshController,
          enablePullDown: false,
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
      )) : Container()
    );
  }
}