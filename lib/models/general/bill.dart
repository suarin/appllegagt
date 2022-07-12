class Bill {
  int? billerId;
  String? billerName;
  int? invoiceNo;
  double? amount;
  int? acoountNo;

  Bill(
      {this.billerId, this.billerName, this.invoiceNo, this.amount, this.acoountNo});

  Bill.fromJson(Map<String, dynamic> json) {
    this.billerId = json["BillerID"];
    this.billerName = json["BillerName"];
    this.invoiceNo = json["InvoiceNo"];
    this.amount = json["Amount"];
    this.acoountNo = json["AcoountNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["BillerID"] = this.billerId;
    data["BillerName"] = this.billerName;
    data["InvoiceNo"] = this.invoiceNo;
    data["Amount"] = this.amount;
    data["AcoountNo"] = this.acoountNo;
    return data;
  }
}