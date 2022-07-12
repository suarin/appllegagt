import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:appllegagt/services/api_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enough_convert/enough_convert.dart';

class RechargeServices {

  static Future<dynamic> getCHolderID() async{
    String reqCHolderID='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('cHolderID') != null) {
      reqCHolderID = prefs.get('cHolderID').toString();
    }
    return reqCHolderID;
  }
  static Future<dynamic> reqMerchantID() async{
    var merchantScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('merchantId') != null) {
      merchantScope = dotenv.env[prefs.getString('merchantId')]!;
    }
    return merchantScope;
  }
  static Future<dynamic> reqToken() async{
    var tokenScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      tokenScope = dotenv.env[prefs.getString('token')]!;
    }
    return tokenScope;
  }
  static Future<dynamic> getBaseUrl() async{
    var baseUrlScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('baseUrl') != null) {
      baseUrlScope = dotenv.env[prefs.getString('baseUrl')]!;
    }
    return baseUrlScope;
  }

  static Future<dynamic> getLoadBank(
      String reqPassword,
      String reqBankID,
      String reqAmount,
      String reqReferenceNo) async{

    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.loadBkUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqBankID=$reqBankID&ReqAmount=$reqAmount&ReqReferenceNo=$reqReferenceNo');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCardLoadVoucher(
      String reqMMerchantID,
      String reqPaymentTypeID,
      String reqVoucherNumber,
      String reqCardNumber,
      String reqMobileNo) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.cardLoadVoucherUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqMMerchantID=$reqMMerchantID&ReqPaymentTypeID=$reqPaymentTypeID&ReqVoucherNumber=$reqVoucherNumber&ReqCardNumber=$reqCardNumber&ReqMobileNo=$reqMobileNo');

    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<String> getLoadPaySafe(
      String reqAmount) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.loadPaySafeUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqAmount=$reqAmount');

    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {

      return response.body;

    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCardLoadCash(
      String reqMMerchantID,
      String reqMPassw,
      String reqCardNumber,
      String reqMobileNo,
      String reqAmount) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.cardLoadCashUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqMMerchantID=$reqMMerchantID&ReqMPassw=$reqMPassw&ReqCardNumber=$reqCardNumber&ReqMobileNo=$reqMobileNo&ReqAmount=$reqAmount');

    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }
}