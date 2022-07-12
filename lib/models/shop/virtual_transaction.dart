class VirtualTransaction {
  String? id;
  String? description;
  String? reference;
  String? amt;
  String? inserted;
  String? merchant;
  String? authno;

  VirtualTransaction({this.id, this.description, this.reference, this.amt, this.inserted, this.merchant, this.authno});

  VirtualTransaction.fromJson(Map<String, dynamic> json) {
    this.id = json["ID"];
    this.description = json["Description"];
    this.reference = json["Reference"];
    this.amt = json["Amt"];
    this.inserted = json["Inserted"];
    this.merchant = json["Merchant"];
    this.authno = json["authno"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ID"] = this.id;
    data["Description"] = this.description;
    data["Reference"] = this.reference;
    data["Amt"] = this.amt;
    data["Inserted"] = this.inserted;
    data["Merchant"] = this.merchant;
    data["authno"] = this.authno;
    return data;
  }
}