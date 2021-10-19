class RooyaSouqFeatured {
  int? postId;
  int? productId;
  String? text;
  String? time;
  String? userName;
  Null userPicture;
  int? userId;
  String? name;
  int? price;
  String? status;
  String? location;
  int? featured;
  String? categoryName;
  int? categoryId;
  List<Attachment>? attachment;

  RooyaSouqFeatured(
      {this.postId,
        this.productId,
        this.text,
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
        this.attachment});

  RooyaSouqFeatured.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    productId = json['product_id'];
    text = json['text'];
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
    if (json['attachment'] != null) {
      attachment =  <Attachment>[];
      json['attachment'].forEach((v) {
        attachment!.add(new Attachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['product_id'] = this.productId;
    data['text'] = this.text;
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
    if (this.attachment != null) {
      data['attachment'] = this.attachment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachment {
  int? photoId;
  String? source;

  Attachment({this.photoId, this.source});

  Attachment.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['source'] = this.source;
    return data;
  }
}
