class CategorySouqModel {
  int? categoryId;
  String? categoryName;
  int? categoryOrder;
  String? categoryDescription;
  String? icons;

  CategorySouqModel(
      {this.categoryId,
      this.categoryName,
      this.categoryOrder,
      this.categoryDescription,
      this.icons});

  CategorySouqModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryOrder = json['category_order'];
    categoryDescription = json['category_description'];
    icons = json['icons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_order'] = this.categoryOrder;
    data['category_description'] = this.categoryDescription;
    data['icons'] = this.icons;
    return data;
  }
}
