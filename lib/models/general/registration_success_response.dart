class RegistrationSuccessResponse {
  int? errorCode;
  int? cHolderId;
  int? cardNo;
  String? userId;
  int? password;
  String? authno;

  RegistrationSuccessResponse({this.errorCode, this.cHolderId, this.cardNo, this.userId, this.password, this.authno});

  RegistrationSuccessResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.cHolderId = json["CHolderID"];
    this.cardNo = json["CardNo"];
    this.userId = json["UserID"];
    this.password = json["Password"];
    this.authno = json["Authno"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["CHolderID"] = this.cHolderId;
    data["CardNo"] = this.cardNo;
    data["UserID"] = this.userId;
    data["Password"] = this.password;
    data["Authno"] = this.authno;
    return data;
  }
}