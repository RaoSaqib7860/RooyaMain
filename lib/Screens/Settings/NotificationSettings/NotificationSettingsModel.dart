class NotificationSettings {
  String? likeMyPost;
  String? commentMyPost;
  String? shareMyPost;
  String? followedMe;
  String? likeMyPage;
  String? visitMe;
  String? mentionMe;
  String? followRequest;
  String? joinGroup;
  String? postOnMyWall;
  String? myDay;

  NotificationSettings(
      {this.likeMyPost,
      this.commentMyPost,
      this.shareMyPost,
      this.followedMe,
      this.likeMyPage,
      this.visitMe,
      this.mentionMe,
      this.followRequest,
      this.joinGroup,
      this.postOnMyWall,
      this.myDay});

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    likeMyPost = json['like_my_post'];
    commentMyPost = json['comment_my_post'];
    shareMyPost = json['share_my_post'];
    followedMe = json['followed_me'];
    likeMyPage = json['like_my_page'];
    visitMe = json['visit_me'];
    mentionMe = json['mention_me'];
    followRequest = json['follow_request'];
    joinGroup = json['join_group'];
    postOnMyWall = json['post_on_my_wall'];
    myDay = json['my_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like_my_post'] = this.likeMyPost;
    data['comment_my_post'] = this.commentMyPost;
    data['share_my_post'] = this.shareMyPost;
    data['followed_me'] = this.followedMe;
    data['like_my_page'] = this.likeMyPage;
    data['visit_me'] = this.visitMe;
    data['mention_me'] = this.mentionMe;
    data['follow_request'] = this.followRequest;
    data['join_group'] = this.joinGroup;
    data['post_on_my_wall'] = this.postOnMyWall;
    data['my_day'] = this.myDay;
    return data;
  }
}
