import 'package:appllegagt/models/general/virtual_card.dart';

class VirtualCardsResponse {
  List<VirtualCard>? virtualCards;

  VirtualCardsResponse({this.virtualCards});

  VirtualCardsResponse.fromJson(Map<String, dynamic> json) {
    this.virtualCards = json["Cards"]==null ? null : (json["Cards"] as List).map((e)=>VirtualCard.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.virtualCards != null)
      data["Cards"] = this.virtualCards?.map((e)=>e.toJson()).toList();
    return data;
  }
}