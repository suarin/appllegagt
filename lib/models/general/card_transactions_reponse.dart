import 'package:appllegagt/models/general/transaction.dart';

class CardTransactionsResponse {
  List<Transaction>? transactions;

  CardTransactionsResponse({this.transactions});

  CardTransactionsResponse.fromJson(Map<String, dynamic> json) {
    this.transactions = json["Transacciones"]==null ? null : (json["Transacciones"] as List).map((e)=>Transaction.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.transactions != null)
      data["Transacciones"] = this.transactions?.map((e)=>e.toJson()).toList();
    return data;
  }
}