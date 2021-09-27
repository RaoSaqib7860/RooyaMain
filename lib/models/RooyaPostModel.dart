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
  List<Posthashtags>? posthashtags;
  List<Postusertags>? postusertags;
  List<CommentsText>? commentsText;
  List<Attachment>? attachment;

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
        this.posthashtags,
        this.postusertags,
        this.commentsText,
        this.attachment});

  RooyaPostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userPosted = json['user_posted'];
    userName = json['user_name'];
    userfullname = json['userfullname'];
    comments = json['comments'];
    likecount = json['likecount'];
    islike = json['islike'];
    userPicture = json['user_picture'];
    text = json['text'];
    time = json['time'];
    if (json['posthashtags'] != null) {
      posthashtags =  <Posthashtags>[];
      json['posthashtags'].forEach((v) {
        posthashtags!.add( Posthashtags.fromJson(v));
      });
    }
    if (json['postusertags'] != null) {
      postusertags =  <Postusertags>[];
      json['postusertags'].forEach((v) {
        postusertags!.add( Postusertags.fromJson(v));
      });
    }
    if (json['comments_text'] != null) {
      commentsText =  <CommentsText>[];
      json['comments_text'].forEach((v) {
        commentsText!.add( CommentsText.fromJson(v));
      });
    }
    if (json['attachment'] != null) {
      attachment =  <Attachment>[];
      json['attachment'].forEach((v) {
        attachment!.add( Attachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.posthashtags != null) {
      data['posthashtags'] = this.posthashtags!.map((v) => v.toJson()).toList();
    }
    if (this.postusertags != null) {
      data['postusertags'] = this.postusertags!.map((v) => v.toJson()).toList();
    }
    if (this.commentsText != null) {
      data['comments_text'] = this.commentsText!.map((v) => v.toJson()).toList();
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
    text = json['text'];
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