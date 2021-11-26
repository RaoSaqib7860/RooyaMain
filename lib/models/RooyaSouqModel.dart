class RooyaSouqModel {
  int? postId;
  int? productId;
  String? text;
  List<Images>? images;
  String? time;
  String? userName;
  String? userPicture;
  int? userId;
  String? name;
  int? price;
  String? status;
  String? location;
  int? featured;
  String? categoryName;
  int? categoryId;
  bool? isLike;

  RooyaSouqModel(
      {this.postId,
      this.productId,
      this.text,
      this.images,
      this.time,
      this.userName,
      this.userPicture,
      this.userId,
      this.name,
      this.price,
      this.status,
      this.location,
      this.featured,
      this.categoryName,
      this.categoryId,
      this.isLike});

  RooyaSouqModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    productId = json['product_id'];
    text = json['text'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    time = json['time'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
    userId = json['user_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    location = json['location'];
    featured = json['featured'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['product_id'] = this.productId;
    data['text'] = this.text;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['location'] = this.location;
    data['featured'] = this.featured;
    data['category_name'] = this.categoryName;
    data['category_id'] = this.categoryId;
    data['is_like'] = this.isLike;
    return data;
  }
}

class Images {
  int? photoId;
  String? attachment;
  String? type;

  Images({this.photoId, this.attachment, this.type});

  Images.fromJson(Map<String, dynamic> json) {
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
