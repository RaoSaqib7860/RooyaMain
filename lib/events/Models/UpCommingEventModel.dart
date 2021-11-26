class UpComingEventsModel {
  String? eventId;
  String? eventPrivacy;
  String? eventAdmin;
  String? eventCategory;
  String? eventTitle;
  String? eventLocation;
  String? eventDescription;
  String? eventStartDate;
  String? eventEndDate;
  String? eventPublishEnabled;
  String? eventPublishApprovalEnabled;
  String? eventCover;
  String? eventCoverId;
  String? eventCoverPosition;
  String? eventAlbumCovers;
  String? eventAlbumTimeline;
  String? eventPinnedPost;
  String? eventInvited;
  String? eventInterested;
  String? eventGoing;
  String? eventDate;
  String? eventWebsite;
  String? eventFacility;
  String? eventContact;
  String? eventFreePaid;
  String? eventPayLink;
  String? eventLat;
  String? eventLong;

  UpComingEventsModel(
      {this.eventId,
      this.eventPrivacy,
      this.eventAdmin,
      this.eventCategory,
      this.eventTitle,
      this.eventLocation,
      this.eventDescription,
      this.eventStartDate,
      this.eventEndDate,
      this.eventPublishEnabled,
      this.eventPublishApprovalEnabled,
      this.eventCover,
      this.eventCoverId,
      this.eventCoverPosition,
      this.eventAlbumCovers,
      this.eventAlbumTimeline,
      this.eventPinnedPost,
      this.eventInvited,
      this.eventInterested,
      this.eventGoing,
      this.eventDate,
      this.eventWebsite,
      this.eventFacility,
      this.eventContact,
      this.eventFreePaid,
      this.eventPayLink,
      this.eventLat,
      this.eventLong});

  UpComingEventsModel.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'].toString();
    eventPrivacy = json['event_privacy'].toString();
    eventAdmin = json['event_admin'].toString();
    eventCategory = json['event_category'].toString();
    eventTitle = json['event_title'].toString();
    eventLocation = json['event_location'].toString();
    eventDescription = json['event_description'].toString();
    eventStartDate = json['event_start_date'].toString();
    eventEndDate = json['event_end_date'].toString();
    eventPublishEnabled = json['event_publish_enabled'].toString();
    eventPublishApprovalEnabled =
        json['event_publish_approval_enabled'].toString();
    eventCover = json['event_cover'].toString();
    eventCoverId = json['event_cover_id'].toString();
    eventCoverPosition = json['event_cover_position'].toString();
    eventAlbumCovers = json['event_album_covers'].toString();
    eventAlbumTimeline = json['event_album_timeline'].toString();
    eventPinnedPost = json['event_pinned_post'].toString();
    eventInvited = json['event_invited'].toString();
    eventInterested = json['event_interested'].toString();
    eventGoing = json['event_going'].toString();
    eventDate = json['event_date'].toString();
    eventWebsite = json['event_website'].toString();
    eventFacility = json['event_facility'].toString();
    eventContact = json['event_contact'].toString();
    eventFreePaid = json['event_free_paid'].toString();
    eventPayLink = json['event_pay_link'].toString();
    eventLat = json['event_lat'].toString();
    eventLong = json['event_long'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_privacy'] = this.eventPrivacy;
    data['event_admin'] = this.eventAdmin;
    data['event_category'] = this.eventCategory;
    data['event_title'] = this.eventTitle;
    data['event_location'] = this.eventLocation;
    data['event_description'] = this.eventDescription;
    data['event_start_date'] = this.eventStartDate;
    data['event_end_date'] = this.eventEndDate;
    data['event_publish_enabled'] = this.eventPublishEnabled;
    data['event_publish_approval_enabled'] = this.eventPublishApprovalEnabled;
    data['event_cover'] = this.eventCover;
    data['event_cover_id'] = this.eventCoverId;
    data['event_cover_position'] = this.eventCoverPosition;
    data['event_album_covers'] = this.eventAlbumCovers;
    data['event_album_timeline'] = this.eventAlbumTimeline;
    data['event_pinned_post'] = this.eventPinnedPost;
    data['event_invited'] = this.eventInvited;
    data['event_interested'] = this.eventInterested;
    data['event_going'] = this.eventGoing;
    data['event_date'] = this.eventDate;
    data['event_website'] = this.eventWebsite;
    data['event_facility'] = this.eventFacility;
    data['event_contact'] = this.eventContact;
    data['event_free_paid'] = this.eventFreePaid;
    data['event_pay_link'] = this.eventPayLink;
    data['event_lat'] = this.eventLat;
    data['event_long'] = this.eventLong;
    return data;
  }
}
