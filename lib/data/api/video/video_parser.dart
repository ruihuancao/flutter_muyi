import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:flutter_muyi/log/mlog.dart';
import 'package:flutter_muyi/data/bean/videos.dart';

class VideoParser{

  static int parserPageCount(int type, String body){
    int total = 0;
    try{
      var document = parse(body);
      String pages = document.getElementsByClassName("pages")[0].text;
      RegExp re = new RegExp("当前:[0-9]/(.*?)页");
      Match match = re.firstMatch(pages);
      total = int.parse(match.group(1));
    }catch(e){
      MLog.d("$type 解析links出错:${e.toString()}");
    }
    return total;
  }

  static int parserSearchPageCount(String key, String body){
    int total = 0;
    try{
      var document = parse(body);
      String pages = document.getElementsByClassName("pages")[0].text;
      MLog.d(pages);
      RegExp re = new RegExp("共(.*?)条数据");
      Match match = re.firstMatch(pages);
      int totalNum = int.parse(match.group(1));
      MLog.d(pages);
      if(totalNum > 0) {
        re = new RegExp("当前:[0-9]/(.*?)页");
        match = re.firstMatch(pages);
        total = int.parse(match.group(1));
      }
    }catch(e){
      MLog.d("$key 解析links出错:${e.toString()}");
    }
    return total;
  }


  static List<VideoBean> parserListVideo(String body){
    List<VideoBean> list = [];
    try{
      var document = parse(body);
      List<Element> vb = document.getElementsByClassName("xing_vb");
      List<Element> tt = vb[0].getElementsByClassName("tt");
      String host = "https://okzyw.com";
      for (int i = 0; i < tt.length; i++) {
        Element element = tt[i].parent;
        Element vb4 = element.getElementsByClassName("xing_vb4")[0];
        Element vb5 = element.getElementsByClassName("xing_vb5")[0];
        Element vb6 = element.getElementsByClassName("xing_vb6")[0];
        String link = host + vb4.getElementsByTagName("a")[0].attributes['href'];
        String name = vb4.text;
        String category = vb5.text;
        String date = vb6.text;
        VideoBean video = VideoBean(name: name, link: link, category: category, date: date);
        list.add(video);
      }
    }catch(e){
      MLog.d("解析video list出错:${e.toString()}");
    }
    return list;
  }

  static VideoDetailBean parserVideoDetail(String body){
    try{
      Map<String, List<String>> source = {};
      var document = parse(body);
      List<Element> list = document.getElementsByClassName("suf");
      for (int i = 0; i < list.length; i++) {
        List<Element> li = list[i].parent.nextElementSibling.children;
        List<String> sourceList = [];
        for (int j = 0; j < li.length; j++) {
          sourceList.add(li[j].text);
        }
        source[list[i].text] = sourceList;
      }
      List<Element> liList = document
          .getElementsByClassName("vodinfobox")
          .first.getElementsByTagName("li");
      List<String> infoList = [];
      for (int i = 0; i < liList.length; i++) {
        if(liList[i].text.contains("片长")){
          continue;
        }
        if(liList[i].text.contains("总播放量")){
          break;
        }
        infoList.add(liList[i].text);
      }
      String detail = document.getElementsByClassName("vodplayinfo")[1].text.trim();
      String image  = document.getElementsByClassName("lazy").first.attributes['src'];
      return VideoDetailBean(infoList: infoList, detail: detail, source: source, image: image);
    }catch(e){
      return null;
    }
  }
}