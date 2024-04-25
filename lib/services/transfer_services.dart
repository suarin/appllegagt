import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:appllegagt/services/api_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enough_convert/enough_convert.dart';

class TransferServices {
  static Future<dynamic> getCHolderID() async {
    String reqCHolderID = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('cHolderID') != null) {
      reqCHolderID = prefs.get('cHolderID').toString();
    }
    return reqCHolderID;
  }

  static Future<dynamic> reqMerchantID() async {
    var merchantScope = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('merchantId') != null) {
      merchantScope = dotenv.env[prefs.getString('merchantId')]!;
    }
    return merchantScope;
  }

  static Future<dynamic> reqToken() async {
    var tokenScope = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      tokenScope = dotenv.env[prefs.getString('token')]!;
    }
    return tokenScope;
  }

  static Future<dynamic> getBaseUrl() async {
    var baseUrlScope = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('baseUrl') != null) {
      baseUrlScope = dotenv.env[prefs.getString('baseUrl')]!;
    }
    return baseUrlScope;
  }

  static Future<dynamic> getCardTransfer(String reqPassword,
      String reqCardNumberTo, String reqStrTotal, String notes) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.cardTransferUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqStrTotal=$reqStrTotal&ReqCardNumberTo=$reqCardNumberTo&Notes=$notes');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCardTransferInt(String reqPassword,
      String reqCardNumberTo, String reqStrTotal, String notes) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.cardTansferInt}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqStrTotal=$reqStrTotal&ReqCardNumberTo=$reqCardNumberTo&Notes=$notes');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCooitzaTransfer(String reqPassword,
      String reqCardNumberTo, String reqStrTotal, String notes) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.cooitzaTansfer}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqStrTotal=$reqStrTotal&ReqCardNumberTo=$reqCardNumberTo&Notes=$notes');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaLoad(
    String reqPassword,
    String reqAmount,
    String reqVisaCardNumber,
  ) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaLoadUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqVisaCardNumber=$reqVisaCardNumber');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaUnload(
      String reqPassword,
      String reqAmount,
      String reqVisaCardNumber,
      ) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaUnloadUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqVisaCardNumber=$reqVisaCardNumber');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getBankAccounts() async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.bankAccountsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getBankTransfer(String reqPassword, String reqAmount,
      String reqBankID, String reqNotes) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.bankTransferUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqBankID=$reqBankID&ReqNotes=$reqNotes');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getBgpAccounts(String setMethod) async {
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri

    var methodUri = setMethod == 'US'
        ? ApiResources.bgpAccountsUri
        : ApiResources.ypmAccountsUri;
    var url = Uri.parse(
        '${baseUrl + methodUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVirtualLoad(
      String reqPassword,
      String reqAmount,
      String reqVirtualCardNumber,
      ) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.virtualCardLoadUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqVirtualCardNumber=$reqVirtualCardNumber');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }
  }

