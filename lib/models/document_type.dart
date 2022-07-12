class DocumentType {
  String ID = "";
  String description = "";

  DocumentType({this.description = "", this.ID = ""});

  DocumentType.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.ID;
    data['Description'] = this.description;

    return data;
  }
}