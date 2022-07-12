
class CardTransferResponse {
  int? errorCode;
  String? transferTo;
  double? debitedAmount;
  String? authNo;

  CardTransferResponse({this.errorCode, this.transferTo, this.debitedAmount, this.authNo});

  CardTransferResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.transferTo = json["TransferTo"];
    this.debitedAmount = json["DebitedAmount"]  is int ? (json["DebitedAmount"] as int).toDouble(): json["DebitedAmount"];
    this.authNo = json["AuthNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["TransferTo"] = this.transferTo;
    data["DebitedAmount"] = this.debitedAmount;
    data["AuthNo"] = this.authNo;
    return data;
  }
}