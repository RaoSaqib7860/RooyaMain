class Folowers {
  int? userId;
  String? userName;
  String? userPicture;
  bool? is_follow;

  Folowers({this.userId, this.userName, this.userPicture, this.is_follow});

  Folowers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
    is_follow = json.containsKey('is_follow') ? json['is_follow'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    data['is_follow'] = this.is_follow;
    return data;
  }
}
