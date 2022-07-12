class VisaBalanceResponse {
  int? errorCode;
  double? balance;

  VisaBalanceResponse({this.errorCode, this.balance});

  VisaBalanceResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.balance = json["Balance"] is int ? (json["Balance"] as int).toDouble(): json["Balance"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["Balance"] = this.balance;
    return data;
  }
}