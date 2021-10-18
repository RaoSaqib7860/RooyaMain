class HomeBannerModel {
  int? id;
  String? bannerImage;
  String? bannerExpDate;

  HomeBannerModel({this.id, this.bannerImage, this.bannerExpDate});

  HomeBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerImage = json['banner_image'];
    bannerExpDate = json['banner_exp_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_image'] = this.bannerImage;
    data['banner_exp_date'] = this.bannerExpDate;
    return data;
  }
}