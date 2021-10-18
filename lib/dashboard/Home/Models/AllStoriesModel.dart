class AllStoriesModel {
  List<Storyobjects>? storyobjects;

  AllStoriesModel({this.storyobjects});

  AllStoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['storyobjects'] != null) {
      storyobjects =  <Storyobjects>[];
      json['storyobjects'].forEach((v) {
        storyobjects!.add(new Storyobjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storyobjects != null) {
      data['storyobjects'] = this.storyobjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Storyobjects {
  int? storyid;
  int? userId;
  String? userPicture;
  int? lastUpdated;
  String? type;
  String? src;
  String? link;
  String? linkText;
  int? time;

  Storyobjects(
      {this.storyid,
        this.userId,
        this.userPicture,
        this.lastUpdated,
        this.type,
        this.src,
        this.link,
        this.linkText,
        this.time});

  Storyobjects.fromJson(Map<String, dynamic> json) {
    storyid = json['storyid'];
    userId = json['user_id'];
    userPicture = json['user_picture'];
    lastUpdated = json['lastUpdated'];
    type = json['type'];
    src = json['src'];
    link = json['link'];
    linkText = json['linkText'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storyid'] = this.storyid;
    data['user_id'] = this.userId;
    data['user_picture'] = this.userPicture;
    data['lastUpdated'] = this.lastUpdated;
    data['type'] = this.type;
    data['src'] = this.src;
    data['link'] = this.link;
    data['linkText'] = this.linkText;
    data['time'] = this.time;
    return data;
  }
}