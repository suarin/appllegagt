import 'bill.dart';

class BillsResponse {
  List<Bill>? bills;

  BillsResponse({this.bills});

  BillsResponse.fromJson(Map<String, dynamic> json) {
    this.bills = json["Facturas"]==null ? null : (json["Facturas"] as List).map((e)=>Bill.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.bills != null)
      data["Facturas"] = this.bills?.map((e)=>e.toJson()).toList();
    return data;
  }
}