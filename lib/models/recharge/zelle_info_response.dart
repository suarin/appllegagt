import 'dart:convert';

class ZelleInfoResponse {
  int? errorCode;
  String? companyName;
  String? zelleEmail;

  ZelleInfoResponse({this.companyName, this.zelleEmail, this.errorCode});

  ZelleInfoResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    companyName = json['CompanyName'];
    zelleEmail = json['ZelleEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['CompanyName'] = this.companyName;
    data['ZelleEmail'] = this.zelleEmail;

    return data;
  }
}
