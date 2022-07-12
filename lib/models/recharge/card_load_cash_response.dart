
class CardLoadCashResponse {
  int? errorCode;
  double? balance;
  String? authno;

  CardLoadCashResponse({this.errorCode, this.balance, this.authno});

  CardLoadCashResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.balance = json["Balance"];
    this.authno = json["authno"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["Balance"] = this.balance;
    data["authno"] = this.authno;
    return data;
  }
}