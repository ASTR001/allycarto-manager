class PincodeModel {
  final String id;
  final String name;

  PincodeModel({this.id, this.name,});

  factory PincodeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PincodeModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
    );
  }

  static List<PincodeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => PincodeModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(PincodeModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;

}
