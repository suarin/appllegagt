class CardLoadVoucherResponse {
  int? errorCode;
  double? amountLoad;
  String? authNo;

  CardLoadVoucherResponse({this.errorCode, this.amountLoad, this.authNo});

  CardLoadVoucherResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.amountLoad = json["AmountLoad"];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["AmountLoad"] = this.amountLoad;
    data["AuthNo"] = this.authNo;
    return data;
  }
}