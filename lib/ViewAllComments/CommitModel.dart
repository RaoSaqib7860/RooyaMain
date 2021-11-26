class CommentModel {
  int? postId;
  String? commentTime;
  int? reactionLikeCount;
  int? comments;
  int? shares;
  int? commentId;
  String? nodeType;
  String? text;
  int? userId;
  String? userName;
  String? userPicture;
  bool? isLike;
  List<Recomments>? recomments;

  CommentModel(
      {this.postId,
      this.commentTime,
      this.reactionLikeCount,
      this.comments,
      this.shares,
      this.commentId,
      this.nodeType,
      this.text,
      this.userId,
      this.userName,
      this.userPicture,
      this.isLike,
      this.recomments});

  CommentModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    commentTime = json['comment_time'];
    reactionLikeCount = json['reaction_like_count'];
    comments = json['comments'];
    shares = json['shares'];
    commentId = json['comment_id'];
    nodeType = json['node_type'];
    text = json['text'].toString();
    userId = json['user_id'];
    userName = json['user_name'];
    userPicture = json['user_picture'];
    isLike = json['is_like'];
    if (json['recomments'] != null) {
      recomments = <Recomments>[];
      json['recomments'].forEach((v) {
        recomments!.add(new Recomments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['comment_time'] = this.commentTime;
    data['reaction_like_count'] = this.reactionLikeCount;
    data['comments'] = this.comments;
    data['shares'] = this.shares;
    data['comment_id'] = this.commentId;
    data['node_type'] = this.nodeType;
    data['text'] = this.text;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_picture'] = this.userPicture;
    data['is_like'] = this.isLike;
    if (this.recomments != null) {
      data['recomments'] = this.recomments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recomments {
  int? postId;
  int? commentId;
  String? recommentTime;
  int? reuserId;
  bool? reIsLike;
  String? reuserName;
  String? reuserPicture;
  String? retext;
  int? reactionLikeCount;

  Recomments(
      {this.postId,
      this.commentId,
      this.recommentTime,
      this.reuserId,
      this.reIsLike,
      this.reuserName,
      this.reuserPicture,
      this.retext,
      this.reactionLikeCount});

  Recomments.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    commentId = json['comment_id'];
    recommentTime = json['recomment_time'];
    reuserId = json['reuser_id'];
    reIsLike = json['re_is_like'];
    reuserName = json['reuser_name'];
    reuserPicture = json['reuser_picture'];
    retext = json['retext'].toString();
    reactionLikeCount = json['re_reaction_like_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['comment_id'] = this.commentId;
    data['recomment_time'] = this.recommentTime;
    data['reuser_id'] = this.reuserId;
    data['re_is_like'] = this.reIsLike;
    data['reuser_name'] = this.reuserName;
    data['reuser_picture'] = this.reuserPicture;
    data['retext'] = this.retext;
    data['reaction_like_count'] = this.reactionLikeCount;
    return data;
  }
}
