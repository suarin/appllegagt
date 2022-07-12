class AuthorizationResponse {
  int? errorCode;
  String? authNo;

  AuthorizationResponse({this.errorCode, this.authNo});

  AuthorizationResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    authNo = json['AuthNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['AuthNo'] = this.authNo;
    return data;
  }
}