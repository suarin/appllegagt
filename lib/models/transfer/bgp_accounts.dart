import 'bgp_account.dart';

class BgpAccounts {
  List<BgpAccount>? accounts;

  BgpAccounts({this.accounts});

  BgpAccounts.fromJson(Map<String, dynamic> json) {
    this.accounts = json["Accounts"]==null ? null : (json["Accounts"] as List).map((e)=>BgpAccount.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.accounts != null)
      data["Accounts"] = this.accounts?.map((e)=>e.toJson()).toList();
    return data;
  }
}