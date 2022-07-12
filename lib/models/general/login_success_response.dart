
class LoginSuccessResponse {
  int? errorCode;
  int? cHolderID;
  String? userName;
  String? cardNo;
  String? currency;
  String? balance;

  LoginSuccessResponse(
      {this.errorCode,
        this.cHolderID,
        this.userName,
        this.cardNo,
        this.currency,
        this.balance});

  LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    cHolderID = json['CHolderID'];
    userName = json['UserName'];
    cardNo = json['CardNo'];
    currency = json['Currency'];
    balance = json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['CHolderID'] = this.cHolderID;
    data['UserName'] = this.userName;
    data['CardNo'] = this.cardNo;
    data['Currency'] = this.currency;
    data['Balance'] = this.balance;
    return data;
  }
}
