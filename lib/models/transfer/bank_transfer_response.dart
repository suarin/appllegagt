class BankTransferResponse {
  int? errorCode;
  String? cardNumber;
  double? debitedAmount;
  String? authNo;

  BankTransferResponse({this.errorCode, this.cardNumber, this.debitedAmount, this.authNo});

  BankTransferResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.cardNumber = json["CardNumber"];
    this.debitedAmount = json["DebitedAmount"];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["CardNumber"] = this.cardNumber;
    data["DebitedAmount"] = this.debitedAmount;
    data["AuthNo"] = this.authNo;
    return data;
  }
}