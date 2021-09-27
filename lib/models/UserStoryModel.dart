class UserStoryModel {
  int? id;
  int? userId;
  String? userFirstname;
  String? userLastname;
  String? userPicture;
  int? lastUpdated;
  List<Items>? items;

  UserStoryModel(
      {this.id,
        this.userId,
        this.userFirstname,
        this.userLastname,
        this.userPicture,
        this.lastUpdated,
        this.items});

  UserStoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userFirstname = json['user_firstname'];
    userLastname = json['user_lastname'];
    userPicture = json['user_picture'];
    lastUpdated = json['lastUpdated'];
    if (json['items'] != null) {
      items =  <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_firstname'] = this.userFirstname;
    data['user_lastname'] = this.userLastname;
    data['user_picture'] = this.userPicture;
    data['lastUpdated'] = this.lastUpdated;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? type;
  String? src;
  String? link;
  String? linkText;
  int? time;

  Items({this.id, this.type, this.src, this.link, this.linkText, this.time});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    src = json['src'];
    link = json['link'];
    linkText = json['linkText'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['src'] = this.src;
    data['link'] = this.link;
    data['linkText'] = this.linkText;
    data['time'] = this.time;
    return data;
  }
}