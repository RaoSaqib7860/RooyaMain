class RooyaPostModel {
  int? postId;
  int? userPosted;
  String? userName;
  String? userfullname;
  int? comments;
  int? likecount;
  bool? islike;
  String? userPicture;
  String? text;
  String? time;
  String? event_id;
  String? origin_id;
  String? pre_user_name;
  String? pre_user_id;
  List<Posthashtags>? posthashtags;
  List<Postusertags>? postusertags;
  List<CommentsText>? commentsText;
  List<Attachment>? attachment;
  String? pre_user_picture;
  String? pre_time;
  String? pre_text;
  String? event_name;

  RooyaPostModel(
      {this.postId,
      this.userPosted,
      this.userName,
      this.userfullname,
      this.comments,
      this.likecount,
      this.islike,
      this.userPicture,
      this.text,
      this.time,
      this.event_id,
      this.origin_id,
      this.posthashtags,
      this.postusertags,
      this.commentsText,
      this.pre_user_id,
      this.pre_user_name,
      this.event_name,
      this.attachment,
      this.pre_time,
      this.pre_user_picture,
      this.pre_text});

  RooyaPostModel.fromJson(Map<String, dynamic> json) {
    pre_text = json['pre_text'].toString();
    event_name = json['event_name'].toString();
    pre_time = json['pre_time'].toString();
    pre_user_picture = json['pre_user_picture'].toString();
    postId = json['post_id'];
    pre_user_id = json['pre_user_id'].toString();
    pre_user_name = json['pre_user_name'].toString();
    userPosted = json['user_posted'];
    userName = json['user_name'];
    userfullname = json['userfullname'];
    comments = json['comments'];
    likecount = json['likecount'];
    islike = json['islike'];
    event_id = json['event_id'].toString();
    origin_id = json['origin_id'].toString();
    userPicture = json['user_picture'];
    text = json['text'].toString();
    time = json['time'];
    if (json['posthashtags'] != null) {
      posthashtags = <Posthashtags>[];
      json['posthashtags'].forEach((v) {
        posthashtags!.add(Posthashtags.fromJson(v));
      });
    }
    if (json['postusertags'] != null) {
      postusertags = <Postusertags>[];
      json['postusertags'].forEach((v) {
        postusertags!.add(Postusertags.fromJson(v));
      });
    }
    if (json['comments_text'] != null) {
      commentsText = <CommentsText>[];
      json['comments_text'].forEach((v) {
        commentsText!.add(CommentsText.fromJson(v));
      });
    }
    if (json['attachment'] != null) {
      attachment = <Attachment>[];
      json['attachment'].forEach((v) {
        attachment!.add(Attachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pre_text'] = this.pre_text;
    data['event_name'] = this.event_name;
    data['post_id'] = this.postId;
    data['user_posted'] = this.userPosted;
    data['user_name'] = this.userName;
    data['userfullname'] = this.userfullname;
    data['comments'] = this.comments;
    data['likecount'] = this.likecount;
    data['islike'] = this.islike;
    data['user_picture'] = this.userPicture;
    data['text'] = this.text;
    data['time'] = this.time;
    data['event_id'] = this.event_id;
    data['origin_id'] = this.origin_id;
    data['pre_user_name'] = this.pre_user_name;
    data['pre_user_id'] = this.pre_user_id;
    data['pre_time'] = this.pre_time;
    data['pre_user_picture'] = this.pre_user_picture;
    if (this.posthashtags != null) {
      data['posthashtags'] = this.posthashtags!.map((v) => v.toJson()).toList();
    }
    if (this.postusertags != null) {
      data['postusertags'] = this.postusertags!.map((v) => v.toJson()).toList();
    }
    if (this.commentsText != null) {
      data['comments_text'] =
          this.commentsText!.map((v) => v.toJson()).toList();
    }
    if (this.attachment != null) {
      data['attachment'] = this.attachment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posthashtags {
  String? hashtag;
  int? hashtagId;

  Posthashtags({this.hashtag, this.hashtagId});

  Posthashtags.fromJson(Map<String, dynamic> json) {
    hashtag = json['hashtag'];
    hashtagId = json['hashtag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashtag'] = this.hashtag;
    data['hashtag_id'] = this.hashtagId;
    return data;
  }
}

class Postusertags {
  int? userId;
  String? userName;
  String? userPicture;

  Postusertags({this.userId, this.userName, this.userPicture});

  Postusertags.fromJson(Map<String, dynamic> json) {
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
}

class CommentsText {
  int? commentId;
  String? text;
  int? userId;
  String? userfullname;
  String? profileImg;
  String? time;
  int? numbersOfLikes;
  int? replies;
  bool? islike;

  CommentsText(
      {this.commentId,
      this.text,
      this.userId,
      this.userfullname,
      this.profileImg,
      this.time,
      this.numbersOfLikes,
      this.replies,
      this.islike});

  CommentsText.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    text = json['text'].toString();
    userId = json['user_id'];
    userfullname = json['userfullname'];
    profileImg = json['profile_img'];
    time = json['time'];
    numbersOfLikes = json['numbers_of_likes'];
    replies = json['replies'];
    islike = json['islike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['text'] = this.text;
    data['user_id'] = this.userId;
    data['userfullname'] = this.userfullname;
    data['profile_img'] = this.profileImg;
    data['time'] = this.time;
    data['numbers_of_likes'] = this.numbersOfLikes;
    data['replies'] = this.replies;
    data['islike'] = this.islike;
    return data;
  }
}

class Attachment {
  int? photoId;
  String? attachment;
  String? type;

  Attachment({this.photoId, this.attachment, this.type});

  Attachment.fromJson(Map<String, dynamic> json) {
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
