class CustomerAccessResponse {
  int? errorCode;
  String? iDAcceso;
  String? contrasena;

  CustomerAccessResponse({this.errorCode, this.iDAcceso, this.contrasena});

  CustomerAccessResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    iDAcceso = json['ID_Acceso'];
    contrasena = json['Contrasena'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ID_Acceso'] = this.iDAcceso;
    data['Contrasena'] = this.contrasena;
    return data;
  }
}
