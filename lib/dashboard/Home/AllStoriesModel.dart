class AllStoriesModel {
  int? storyid;
  int? userId;
  String? userPicture;
  int? lastUpdated;
  String? type;
  String? src;
  String? link;
  String? linkText;
  int? time;

  AllStoriesModel(
      {this.storyid,
      this.userId,
      this.userPicture,
      this.lastUpdated,
      this.type,
      this.src,
      this.link,
      this.linkText,
      this.time});

  AllStoriesModel.fromJson(Map<String, dynamic> json) {
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
