import 'package:flutter_tagging/flutter_tagging.dart';

class HashTagModel extends Taggable  {
  int? hashtagId;
  String? hashtag;

  HashTagModel({this.hashtagId, this.hashtag});

  HashTagModel.fromJson(Map<String, dynamic> json) {
    hashtagId = json['hashtag_id'];
    hashtag = json['hashtag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashtag_id'] = this.hashtagId;
    data['hashtag'] = this.hashtag;
    return data;
  }

  @override
  List<Object> get props => [hashtag!];
}