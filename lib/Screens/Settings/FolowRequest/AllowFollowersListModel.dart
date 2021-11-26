import 'package:flutter/material.dart';

class AllowFollowersList {
  String? userId;
  String? userName;
  String? userPicture;
  String? requestStatus;

  AllowFollowersList(
      {this.userId, this.userName, this.userPicture, this.requestStatus});

  AllowFollowersList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    data['request_status'] = this.requestStatus;
    return data;
  }
}
