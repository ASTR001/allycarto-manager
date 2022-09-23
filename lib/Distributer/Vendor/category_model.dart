class CategoryModel {
  final String id;
  final String name;

  CategoryModel({this.id, this.name,});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CategoryModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
    );
  }

  static List<CategoryModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CategoryModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CategoryModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => id;

}
