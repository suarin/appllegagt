class BankAccount {
  String? bankId;
  String? bankName;
  String? accountNo;

  BankAccount({this.bankId, this.bankName, this.accountNo});

  BankAccount.fromJson(Map<String, dynamic> json) {
    this.bankId = json["BankID"];
    this.bankName = json["BankName"];
    this.accountNo = json["AccountNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["BankID"] = this.bankId;
    data["BankName"] = this.bankName;
    data["AccountNo"] = this.accountNo;
    return data;
  }
}