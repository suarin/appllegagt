
class PaymentType {
  String? typeId;
  String? type;

  PaymentType({this.typeId, this.type});

  PaymentType.fromJson(Map<String, dynamic> json) {
    this.typeId = json["TypeID"];
    this.type = json["Type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["TypeID"] = this.typeId;
    data["Type"] = this.type;
    return data;
  }
}