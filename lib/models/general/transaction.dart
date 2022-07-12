class Transaction {
  String? fecha;
  String? hora;
  String? authNo;
  String? transaccion;
  double? debito;
  double? credito;
  double? saldo;

  Transaction({this.fecha, this.hora, this.authNo, this.transaccion, this.debito, this.credito, this.saldo});

  Transaction.fromJson(Map<String, dynamic> json) {
    this.fecha = json["Fecha"];
    this.hora = json["Hora"];
    this.authNo = json["AuthNo"];
    this.transaccion = json["Transaccion"];
    this.debito = json["Debito"] is int ? (json["Debito"] as int).toDouble(): json["Debito"];
    this.credito = json["Credito"] is int ? (json["Credito"] as int).toDouble(): json["Credito"];
    this.saldo = json["Saldo"] is int ? (json["Saldo"] as int).toDouble(): json["Saldo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["Fecha"] = this.fecha;
    data["Hora"] = this.hora;
    data["AuthNo"] = this.authNo;
    data["Transaccion"] = this.transaccion;
    data["Debito"] = this.debito;
    data["Credito"] = this.credito;
    data["Saldo"] = this.saldo;
    return data;
  }
}