class AllStoryies {
  List<Storyobjects>? storyobjects;

  AllStoryies({this.storyobjects});

  AllStoryies.fromJson(Map<String, dynamic> json) {
    if (json['storyobjects'] != null) {
      storyobjects = <Storyobjects>[];
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
  String? userName;
  String? userPicture;
  int? lastUpdated;
  String? type;
  String? src;
  String? link;
  String? linkText;
  int? story_element_id;
  String? time;
  String? event_id ;

  Storyobjects(
      {this.storyid,
      this.userId,
      this.userName,
      this.userPicture,
      this.lastUpdated,
      this.type,
      this.src,
      this.link,
      this.linkText,
      this.story_element_id,this.event_id,
      this.time});

  Storyobjects.fromJson(Map<String, dynamic> json) {
    event_id = json['event_id'].toString();
    storyid = json['storyid'];
    userId = json['user_id'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
    lastUpdated = json['lastUpdated'];
    type = json['type'];
    src = json['src'];
    link = json['link'];
    linkText = json['linkText'];
    time = json['time'];
    story_element_id = json['story_element_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storyid'] = this.storyid;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    data['lastUpdated'] = this.lastUpdated;
    data['type'] = this.type;
    data['src'] = this.src;
    data['link'] = this.link;
    data['linkText'] = this.linkText;
    data['time'] = this.time;
    data['story_element_id'] = this.story_element_id;
    data['event_id'] = this.event_id;
    return data;
  }
}
