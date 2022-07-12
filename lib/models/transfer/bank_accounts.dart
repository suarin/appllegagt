import 'bank_account.dart';

class BankAccounts {
  List<BankAccount>? accounts;

  BankAccounts({this.accounts});

  BankAccounts.fromJson(Map<String, dynamic> json) {
    this.accounts = json["Accounts"]==null ? null : (json["Accounts"] as List).map((e)=>BankAccount.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.accounts != null)
      data["Accounts"] = this.accounts?.map((e)=>e.toJson()).toList();
    return data;
  }
}