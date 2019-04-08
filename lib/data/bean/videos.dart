
class VideoBean {
  final String name;
  final String link;
  final String category;
  final String date;

  VideoBean({this.name, this.link, this.category, this.date});

  VideoBean.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        link = json['link'],
        category = json['category'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'category': category,
        'date': date,
      };
}

class VideoListBean{

  final String key;
  final int type;
  final int total;
  final List<VideoBean> list;

  VideoListBean(this.total, this.list, {this.key, this.type});

  Map<String, dynamic> toJson() => {
    'total': total,
    'list': list,
  };
}

class VideoDetailBean{

  final List<String>  infoList;
  final Map<String, List<String>>  source;
  final String detail;
  final String image;

  VideoDetailBean({this.infoList, this.source, this.detail, this.image});

  Map<String, dynamic> toJson() => {
    'infoList': infoList,
    'source': source,
    'detail': detail,
    'image': image,
  };
}
