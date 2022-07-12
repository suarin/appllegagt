import 'package:appllegagt/models/general/visa_card.dart';

class VisaCardsResponse {
  List<VisaCard>? visaCards;

  VisaCardsResponse({this.visaCards});

  VisaCardsResponse.fromJson(Map<String, dynamic> json) {
    this.visaCards = json["Cards"]==null ? null : (json["Cards"] as List).map((e)=>VisaCard.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.visaCards != null)
      data["Cards"] = this.visaCards?.map((e)=>e.toJson()).toList();
    return data;
  }
}