class VisaCard {
  String? cardNo;
  String? holderName;

  VisaCard({this.cardNo, this.holderName});

  VisaCard.fromJson(Map<String, dynamic> json) {
    this.cardNo = json["CardNo"];
    this.holderName = json["HolderName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["CardNo"] = this.cardNo;
    data["HolderName"] = this.holderName;
    return data;
  }
}