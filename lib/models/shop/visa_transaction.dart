class VisaTransaction {
  int? id;
  String? inserted;
  String? description;
  String? reference;
  String? credit;
  String? debit;

  VisaTransaction({this.id, this.inserted, this.description, this.reference, this.credit, this.debit});

  VisaTransaction.fromJson(Map<String, dynamic> json) {
    this.id = json["ID"];
    this.inserted = json["Inserted"];
    this.description = json["Description"];
    this.reference = json["Reference"];
    this.credit = json["Credit"];
    this.debit = json["Debit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ID"] = this.id;
    data["Inserted"] = this.inserted;
    data["Description"] = this.description;
    data["Reference"] = this.reference;
    data["Credit"] = this.credit;
    data["Debit"] = this.debit;
    return data;
  }
}
