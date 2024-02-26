class Cooperative {
  String? id;
  String? name;

  Cooperative({this.id, this.name});

  Cooperative.fromJson(Map<String, dynamic> json) {
    this.name = json["name"];
    this.id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["id"] = this.id;
    return data;
  }
}
