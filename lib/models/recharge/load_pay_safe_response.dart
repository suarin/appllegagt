class LoadPaySafeResponse {
  LoadPaySafeResponse({
    required this.ErrorCode,
    required this.CHolderID,
    required this.Token,
  });
  late final int ErrorCode;
  late final String CHolderID;
  late final String Token;

  LoadPaySafeResponse.fromJson(Map<String, dynamic> json) {
    ErrorCode = json['ErrorCode'];
    CHolderID = json['CHolderID'];
    Token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ErrorCode'] = ErrorCode;
    _data['CHolderID'] = CHolderID;
    _data['Token'] = Token;
    return _data;
  }
}
