class Country {
  String name = "";
  String alpha3 = "";
  String countryCode = "";

  Country({this.name = "", this.alpha3 = "", this.countryCode = ""});

  Country.fromJson(Map<String, dynamic> json){
    name = json['name'];
    alpha3 = json['alpha-3'];
    countryCode = json['country-code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['alpha-3'] = this.alpha3;
    data['country-code'] = this.countryCode;

    return data;
  }
}