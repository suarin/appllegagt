
class BillPaymentResponse {
  int? errorCode;
  int? accountNo;
  String? billerName;
  double? totalPaid;
  int? fee;
  double? productCost;
  String? authNo;

  BillPaymentResponse({this.errorCode, this.accountNo, this.billerName, this.totalPaid, this.fee, this.productCost, this.authNo});

  BillPaymentResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.accountNo = json["AccountNo"];
    this.billerName = json["BillerName"];
    this.totalPaid = json["TotalPaid"];
    this.fee = json["Fee"];
    this.productCost = json["ProductCost"];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["AccountNo"] = this.accountNo;
    data["BillerName"] = this.billerName;
    data["TotalPaid"] = this.totalPaid;
    data["Fee"] = this.fee;
    data["ProductCost"] = this.productCost;
    data["AuthNo"] = this.authNo;
    return data;
  }
}