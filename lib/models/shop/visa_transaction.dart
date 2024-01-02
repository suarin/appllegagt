class VisaTransaction {
  int? id;
  String? inserted;
  String? description;
  String? reference;
  String? amount;
  String? balance;

  VisaTransaction(
      {this.id,
      this.inserted,
      this.description,
      this.reference,
      this.amount,
      this.balance});

  VisaTransaction.fromJson(Map<String, dynamic> json) {
    this.id = json["ID"];
    this.inserted = json["Inserted"];
    this.description = json["Description"];
    this.reference = json["Reference"];
    this.amount = json["Amount"];
    this.balance = json["Balance"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ID"] = this.id;
    data["Inserted"] = this.inserted;
    data["Description"] = this.description;
    data["Reference"] = this.reference;
    data["Amount"] = this.amount;
    data["Balance"] = this.balance;
    return data;
  }
}
