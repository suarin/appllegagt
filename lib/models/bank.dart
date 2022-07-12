
class Bank {
  String? countryId;
  String? bankId;
  String? bankName;

  Bank({this.countryId, this.bankId, this.bankName});

  Bank.fromJson(Map<String, dynamic> json) {
    this.countryId = json["CountryID"];
    this.bankId = json["BankID"];
    this.bankName = json["BankName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["CountryID"] = this.countryId;
    data["BankID"] = this.bankId;
    data["BankName"] = this.bankName;
    return data;
  }
}