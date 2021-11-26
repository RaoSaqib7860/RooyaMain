class PrivacySettings {
  String? userPrivacyWall;
  String? userPrivacyGender;
  String? userPrivacyBirthdate;
  String? userPrivacyFriends;
  String? userPrivacyFollow;
  String? userChatEnabled;
  String? seeOnlineOffline;
  String? privateAccount;

  PrivacySettings(
      {this.userPrivacyWall,
      this.userPrivacyGender,
      this.userPrivacyBirthdate,
      this.userPrivacyFriends,
      this.userPrivacyFollow,
      this.userChatEnabled,
      this.seeOnlineOffline,
      this.privateAccount});

  PrivacySettings.fromJson(Map<String, dynamic> json) {
    userPrivacyWall = json['user_privacy_wall'];
    userPrivacyGender = json['user_privacy_gender'];
    userPrivacyBirthdate = json['user_privacy_birthdate'];
    userPrivacyFriends = json['user_privacy_friends'];
    userPrivacyFollow = json['user_privacy_follow'];
    userChatEnabled = json['user_chat_enabled'];
    seeOnlineOffline = json['see_online_offline'];
    privateAccount = json['private_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_privacy_wall'] = this.userPrivacyWall;
    data['user_privacy_gender'] = this.userPrivacyGender;
    data['user_privacy_birthdate'] = this.userPrivacyBirthdate;
    data['user_privacy_friends'] = this.userPrivacyFriends;
    data['user_privacy_follow'] = this.userPrivacyFollow;
    data['user_chat_enabled'] = this.userChatEnabled;
    data['see_online_offline'] = this.seeOnlineOffline;
    data['private_account'] = this.privateAccount;
    return data;
  }
}
