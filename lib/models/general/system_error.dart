class SystemError {
  int? errorCode;
  String? spanishDescription;
  String? englishDescription;

  SystemError(
      {this.errorCode, this.spanishDescription, this.englishDescription});

  SystemError.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    spanishDescription = json['SpanishDescription'];
    englishDescription = json['EnglishDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['SpanishDescription'] = this.spanishDescription;
    data['EnglishDescription'] = this.englishDescription;
    return data;
  }
}