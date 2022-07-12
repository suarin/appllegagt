class BgpAccount {
  String? accountNo;
  String? holderName;

  BgpAccount({this.accountNo, this.holderName});

  BgpAccount.fromJson(Map<String, dynamic> json) {
    this.accountNo = json["AccountNo"];
    this.holderName = json["HolderName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["AccountNo"] = this.accountNo;
    data["HolderName"] = this.holderName;
    return data;
  }
}

