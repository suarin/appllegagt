import 'cooperative.dart';

class Cooperatives {
  List<Cooperative>? cooperativesList;

  Cooperatives({this.cooperativesList});

  Cooperatives.fromJson(Map<String, dynamic> json) {
    this.cooperativesList = json == null
        ? null
        : (json as List).map((e) => Cooperative.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cooperativesList != null)
      data =
          this.cooperativesList?.map((e) => e.toJson()) as Map<String, dynamic>;
    return data;
  }
}
