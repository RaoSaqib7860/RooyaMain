import 'package:flutter_tagging/flutter_tagging.dart';

class UserTagModel extends Taggable{
  int? userId;
  String? userName;
  String? userPicture;

  UserTagModel({this.userId, this.userName, this.userPicture});

  UserTagModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    return data;
  }

  @override
  List<Object> get props => [userId!];
}