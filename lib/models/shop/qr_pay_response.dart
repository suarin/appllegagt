
class QrPayResponse {
  int? errorCode;
  String? customer;
  double? amount;
  String? authNo;

  QrPayResponse({this.errorCode, this.customer, this.amount, this.authNo});

  QrPayResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.customer = json["Customer"];
    this.amount = json["Amount"]  is int ? (json['Amount'] as int).toDouble() : json['Amount'];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["Customer"] = this.customer;
    data["Amount"] = this.amount;
    data["AuthNo"] = this.authNo;
    return data;
  }
}