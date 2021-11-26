class ProfileInfoModel {
  int? userId;
  String? userName;
  int? userGroup;
  String? userEmail;
  String? userFirstname;
  String? userLastname;
  String? userPicture;
  String? userCover;
  int? totalFollowers;
  int? totalFollowings;
  bool? isFollow;
  int? totalPosts;
  String? private_account;
  String? already_requested;
  String? user_verified;

  ProfileInfoModel(
      {this.userId,
      this.userName,
      this.userGroup,
      this.userEmail,
      this.userFirstname,
      this.userLastname,
      this.userPicture,
      this.userCover,
      this.totalFollowers,
      this.totalFollowings,
      this.isFollow,
      this.totalPosts,
      this.private_account,
      this.already_requested,
        this.user_verified,
      });

  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    print('already_requested key data = ${json['already_requested']}');
    user_verified = json['user_verified'].toString();
    userId = json['user_id'];
    userName = json['user_name'];
    userGroup = json['user_group'];
    userEmail = json['user_email'];
    userFirstname = json['user_firstname'];
    userLastname = json['user_lastname'];
    userPicture = json['user_picture'];
    userCover = json['user_cover'];
    totalFollowers = json['total_followers'];
    totalFollowings = json['total_followings'];
    isFollow = json['is_follow'];
    totalPosts = json['total_posts'];
    private_account = json['private_account'].toString();
    already_requested = '${json['already_requested']}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_group'] = this.userGroup;
    data['user_email'] = this.userEmail;
    data['user_firstname'] = this.userFirstname;
    data['user_lastname'] = this.userLastname;
    data['user_picture'] = this.userPicture;
    data['user_cover'] = this.userCover;
    data['total_followers'] = this.totalFollowers;
    data['total_followings'] = this.totalFollowings;
    data['is_follow'] = this.isFollow;
    data['total_posts'] = this.totalPosts;
    data['private_account'] = this.private_account;
    data['already_requested'] = this.already_requested;
    data['user_verified'] = this.user_verified;
    return data;
  }
}
