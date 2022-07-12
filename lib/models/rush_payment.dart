class RushPayment {
  String? optionId;
  String? optionName;

  RushPayment({this.optionId, this.optionName});

  RushPayment.fromJson(Map<String, dynamic> json) {
    this.optionId = json["OptionID"];
    this.optionName = json["OptionName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["OptionID"] = this.optionId;
    data["OptionName"] = this.optionName;
    return data;
  }
}