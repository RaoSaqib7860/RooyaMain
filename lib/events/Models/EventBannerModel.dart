class EventBannerModel {
  int? photoId;
  String? attachment;
  String? type;

  EventBannerModel({this.photoId, this.attachment, this.type});

  EventBannerModel.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    attachment = json['attachment'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['attachment'] = this.attachment;
    data['type'] = this.type;
    return data;
  }
}
