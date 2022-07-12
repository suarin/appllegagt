import 'package:appllegagt/models/shop/virtual_transaction.dart';

class VirtualTransactionsResponse {
  int? errorCode;
  List<VirtualTransaction>? transacciones;

  VirtualTransactionsResponse({this.errorCode, this.transacciones});

  VirtualTransactionsResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json["ErrorCode"];
    this.transacciones = json["Transacciones"]==null ? null : (json["Transacciones"] as List).map((e)=>VirtualTransaction.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    if(this.transacciones != null)
      data["Transacciones"] = this.transacciones?.map((e)=>e.toJson()).toList();
    return data;
  }
}