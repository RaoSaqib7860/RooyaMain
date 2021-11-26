class CountryModel {
  int? countryId;
  String? countryCode;
  String? countryName;

  CountryModel({this.countryId, this.countryCode, this.countryName});

  CountryModel.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    return data;
  }
}
