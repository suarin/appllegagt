class VirtualCardRequestResponse {
  int? errorCode;
  String? cardNumber;
  String? expDate;
  String? cardCvv;
  String? authNo;

  VirtualCardRequestResponse(
      {this.errorCode,
      this.cardNumber,
      required this.expDate,
      this.cardCvv,
      required this.authNo});

  VirtualCardRequestResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.cardNumber = json["CardNumber"];
    this.expDate = json["ExpDate"];
    this.cardCvv = json["CardCVV"];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["CardNumber"] = this.cardNumber;
    data["ExpDate"] = this.expDate;
    data["CardCVV"] = this.cardCvv;
    data["AuthNo"] = this.authNo;
    return data;
  }
}
