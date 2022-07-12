import 'package:appllegagt/models/shop/visa_transaction.dart';

class VisaTransactionsResponse {
  int? errorCode;
  List<VisaTransaction>? transacciones;

  VisaTransactionsResponse({this.errorCode, this.transacciones});

  VisaTransactionsResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.transacciones = json["Transacciones"]==null ? null : (json["Transacciones"] as List).map((e)=>VisaTransaction.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    if(this.transacciones != null)
      data["Transacciones"] = this.transacciones?.map((e)=>e.toJson()).toList();
    return data;
  }
}